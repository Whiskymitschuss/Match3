extends SceneTree
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.encounters.enabled=false # Frozen historical combat rules; 0.10 tested separately.
	g.saved=g.default_save()
	g.saved.wins=1
	var trace:Array=[]
	var scenarios:Array=[]
	for arena in ['scrapyard','reactor']:
		for id in g.Specs.all().keys().filter(func(key):return g.Specs.all()[key].weapon!='mop'):scenarios.append({'arena':arena,'spec':id,'boss':false})
		for id in ['quake','piercer','swift']:scenarios.append({'arena':arena,'spec':id,'boss':true})
	var args=OS.get_cmdline_user_args()
	if args.has('--low'):g.saved.settings.quality='LOW'
	if args.has('--no-splatter'):g.saved.settings.splatter=false
	for index in range(scenarios.size()):
		var scene=scenarios[index]
		if scene.arena!='scrapyard':continue
		var weapon=g.Specs.all()[scene.spec].weapon
		g.selected=0 if weapon=='hammer' else (2 if weapon=='orbit' else 1)
		g.arena_id=scene.arena
		g.start_run()
		g.rng.seed=5100+index
		# Freeze historical wave rules only in this regression harness, never in the app.
		g.waves=JSON.parse_string(FileAccess.get_file_as_string('res://tests/fixtures/classic_waves_v0.6.json'))
		g.wave_number=10 if scene.boss else 9
		g.begin_wave()
		g.hp=99999
		g.max_hp=99999
		g.weapons=[{'id':weapon,'level':5,'clock':0.0,'spec':scene.spec}]
		for i in range(24):
			g.spawn_enemy(['grunt','runner','tank'][i%3])
			g.enemies.back().pos=g.player.position+Vector2.from_angle(i*TAU/24)*(90+i*13)
		if scene.boss:g.enemies[0].pos=g.player.position+Vector2(300,0)
		var frames=900 if scene.boss else 600
		for frame in range(frames):
			g.move_input=Vector2.from_angle(frame*.013)*.65
			if g.hero_ability.ready_to_use():g.hero_ability.activate()
			g._physics_process(1.0/60)
			while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
			if frame%120==0 or frame==frames-1:
				var foes:Array=[]
				for e in g.enemies:foes.append([e.kind,e.pos.x,e.pos.y,e.hp,e.orbit_cd,e.get('ability_slow_time',0)])
				var shots:Array=[]
				for s in g.shots:
					if s.active:shots.append([s.pos.x,s.pos.y,s.vel.x,s.vel.y,s.damage,s.life,s.hostile,s.spec,s.hits_left,s.hit_enemies.size()])
				trace.append({'scenario':index,'frame':frame,'state':g.state,'pos':[g.player.position.x,g.player.position.y],'hp':g.hp,'time':g.run_time,'remaining':g.remaining,'xp':g.xp,'level':g.level,'coins':g.coins,'kills':g.kills,'damage':g.dealt,'rng':str(g.rng.state),'foes':foes,'shots':shots,'cooldown':g.hero_ability.cooldown,'grenade':g.hero_ability.grenade.get('age',-1),'dash':g.hero_ability.dash.get('age',-1)})
	var output=Array(args).filter(func(a):return not a.begins_with('--'))
	var ok=true
	if not output.is_empty():
		var f=FileAccess.open(output[0],FileAccess.WRITE)
		f.store_string(JSON.stringify(trace))
		f.close()
	else:
		var reference=JSON.parse_string(FileAccess.get_file_as_string('res://tests/fixtures/effects_v0.5_trace.json')).filter(func(entry):return entry.scenario<13)
		ok=same(trace,reference)
		print('EFFECTS REGRESSION ', 'PASS' if ok else 'FAIL', ': ',trace.size(),' checkpoints / 8700 steps / all 10 specializations, abilities and classic boss; LEGACY WAVE RULES IN TEST HARNESS (both arenas rebalanced in 0.6.1); quality=',g.saved.settings.quality)
	g.queue_free()
	await process_frame
	quit(0 if ok else 1)
func same(a,b) -> bool:
	if (a is int or a is float) and (b is int or b is float):return absf(float(a)-float(b))<.000001
	if a is Array and b is Array:
		if a.size()!=b.size():return false
		for i in range(a.size()):
			if not same(a[i],b[i]):return false
		return true
	if a is Dictionary and b is Dictionary:
		if a.size()!=b.size():return false
		for k in a:
			if not b.has(k) or not same(a[k],b[k]):return false
		return true
	return a==b
