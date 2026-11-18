extends SceneTree
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	for id in g.Specs.all():
		var weapon=g.Specs.all()[id].weapon
		g.arena_id='reactor'
		g.selected=0 if weapon=='hammer' else (2 if weapon=='orbit' else 1)
		g.start_run()
		g.wave_number=9
		g.begin_wave()
		g.hp=100000
		g.max_hp=100000
		g.saved.settings.quality=['LOW','MEDIUM','HIGH'][g.Specs.all().keys().find(id)%3]
		g.rng.seed=505
		g.weapons=[{'id':weapon,'level':5,'clock':0.0,'spec':id}]
		for i in range(100):g.spawn_enemy(['grunt','runner','tank'][i%3])
		for frame in range(1800):
			g.remaining=60
			g.move_input=Vector2.from_angle(frame*.012)
			if g.hero_ability.ready_to_use():g.hero_ability.activate()
			g._physics_process(1.0/60)
			while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
			assert(g.state==g.State.COMBAT)
			assert(g.enemies.size()<=100 and g.shots.size()<=320)
			assert(g.loot.size()<=240 and g.specialized_combat.fx.size()<=16)
			assert(g.hit_feedback.numbers.size()<=64 and g.arena_hazards.items.size()<=12)
			assert(g.vfx.particles.size()<=g.vfx.limits().particles)
			assert(g.vfx.stains.size()<=g.vfx.limits().stains and g.vfx.events.size()<=g.vfx.limits().events)
			for s in g.shots:assert(s.hit_enemies.size()<=3)
		print('EFFECTS SOAK PASS ',id,' 1800 steps / 30 simulated seconds, kills=',g.kills)
	g.cleanup()
	for s in g.shots:assert(s.hit_enemies.is_empty() and not s.active)
	g.queue_free()
	await process_frame
	print('EFFECTS SOAK TOTAL 18000 steps / 300 simulated seconds / 10 variants / mixed LOW-MEDIUM-HIGH PASS')
	quit()
