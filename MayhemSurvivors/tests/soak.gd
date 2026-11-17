extends SceneTree
func _initialize(): call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	if OS.get_cmdline_user_args().has('--reactor'):
		g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
		g.arena_id='reactor'
	g.selected=1
	g.start_run()
	g.wave_number=9
	g.begin_wave()
	g.max_hp=100000
	g.hp=100000
	g.weapons=[{'id':'blaster','level':5,'clock':0.0},{'id':'splitgun','level':5,'clock':0.0},{'id':'arc','level':5,'clock':0.0},{'id':'orbit','level':5,'clock':0.0}]
	for i in range(100):g.spawn_enemy(['grunt','runner','tank'][i%3])
	var frames=7200
	var peak_enemies=0
	var peak_projectiles=0
	var start=Time.get_ticks_usec()
	for i in range(frames):
		g.remaining=60
		g.move_input=Vector2.from_angle(i*.003)
		g._physics_process(1.0/60)
		if g.state==g.State.LEVEL_UP:
			g.apply_upgrade('damage')
			g.resume()
		peak_enemies=maxi(peak_enemies,g.enemies.size())
		peak_projectiles=maxi(peak_projectiles,g.shots.size())
		assert(g.enemies.size()<=100)
		assert(g.shots.size()<=320)
		assert(g.loot.size()<=240)
		assert(g.effects.size()<=110)
		assert(g.arena_hazards.items.size()<=12)
		assert(g.state==g.State.COMBAT)
	var elapsed=(Time.get_ticks_usec()-start)/1000000.0
	print('SOAK PASS frames=',frames,' simulated_seconds=120 wall_seconds=',elapsed,' simulation_ms_per_frame=',elapsed*1000/frames,' peak_enemies=',peak_enemies,' pool_size=',peak_projectiles,' kills=',g.kills)
	g.music.stop()
	await create_timer(.15).timeout
	g.queue_free()
	await process_frame
	quit()
