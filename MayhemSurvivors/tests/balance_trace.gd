extends SceneTree
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	var trace:Array=[]
	for hero in range(3):
		g.selected=hero
		g.start_run()
		g.rng.seed=24891+hero
		g.begin_wave()
		g.max_hp=20000
		g.hp=20000
		g.weapons=[]
		var ids=[['hammer','blaster','arc','orbit'],['splitgun','blaster','arc','orbit'],['orbit','splitgun','hammer','blaster']][hero]
		for id in ids:g.weapons.append({'id':id,'level':3,'clock':0.0})
		for j in range(24):
			g.spawn_enemy(['grunt','runner','tank'][j%3])
			g.enemies.back().pos=g.player.position+Vector2.from_angle(j*TAU/24)*(80+j*17)
		for frame in range(1200):
			g.move_input=Vector2.from_angle(frame*.011)*.65
			g._physics_process(1.0/60)
			while g.state==g.State.LEVEL_UP:
				g.apply_upgrade('damage')
				g.if_more_levels()
			if frame%120==0 or frame==1199:
				var foes:Array=[]
				for e in g.enemies:foes.append([e.kind,snappedf(e.pos.x,.0001),snappedf(e.pos.y,.0001),snappedf(e.hp,.0001)])
				var bullets:Array=[]
				for s in g.shots:
					if s.active:bullets.append([snappedf(s.pos.x,.0001),snappedf(s.pos.y,.0001),snappedf(s.damage,.0001),snappedf(s.life,.0001),s.hostile])
				trace.append({'hero':hero,'frame':frame,'hp':g.hp,'coins':g.coins,'kills':g.kills,'dealt':snappedf(g.dealt,.0001),'level':g.level,'xp':g.xp,'rng':str(g.rng.state),'foes':foes,'bullets':bullets})
	var args=OS.get_cmdline_user_args()
	var matches=true
	if args.size()>0:
		var out=FileAccess.open(args[0],FileAccess.WRITE)
		out.store_string(JSON.stringify(trace))
		out.close()
	else:
		var reference=JSON.parse_string(FileAccess.get_file_as_string('res://tests/fixtures/balance_v0.1_trace.json'))
		matches=same_value(trace,reference)
		print('BALANCE REGRESSION ', 'PASS' if matches else 'FAIL', ': 33 checkpoints, 3600 fixed-clock steps, 3 heroes; HP, XP, kills, coins, damage, enemies, projectiles and critical RNG compared with v0.1')
		if not matches:push_error('Run with --fixed-fps 60; gameplay diverged from reference trace')
	g.queue_free()
	await process_frame
	quit(0 if matches else 1)

# JSON numbers load as float; compare numbers by value, not Dictionary storage type.
func same_value(a, b) -> bool:
	if (a is int or a is float) and (b is int or b is float): return absf(float(a)-float(b))<.000001
	if a is Array and b is Array:
		if a.size()!=b.size(): return false
		for i in range(a.size()):
			if not same_value(a[i],b[i]): return false
		return true
	if a is Dictionary and b is Dictionary:
		if a.size()!=b.size(): return false
		for key in a:
			if not b.has(key) or not same_value(a[key],b[key]): return false
		return true
	return a==b
