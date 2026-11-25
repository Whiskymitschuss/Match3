extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.refresh_hud();g.queue_redraw()
	if is_instance_valid(g.joystick):g.joystick.queue_redraw()
	if is_instance_valid(g.ability_button):g.ability_button.queue_redraw()
	for i in range(5):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/arena_mechanics_'+name+'.png');print('ARENA MECHANICS FRAME ',name)
func start(arena:String,wave:int=3,hero:int=0):
	g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode='campaign';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area()
	for arena in ['reactor','docks']:
		start(arena);g.state=g.State.WAVE_PREPARATION;g.arena_coach.show(g.prepare_wave);await capture(arena+'_coach')
		g.saved.settings.arena_briefings=['reactor','docks'];g.prepare_wave();await capture(arena+'_briefing')
	start('reactor',3,1)
	for offset in [Vector2(-80,20),Vector2(100,35),Vector2(50,-70)]:g.arena_mechanics.cores.append({'pos':g.player.position+offset})
	await capture('reactor_cores');g.arena_mechanics.charge=3;g.arena_mechanics.cores.clear();await capture('reactor_ready')
	g.player.position=g.arena_mechanics.terminal;g.arena_mechanics.update(1.21);g.player.position+=Vector2(-240,30)
	for i in range(5):g.spawn_enemy('grunt');g.enemies.back().pos=g.arena_mechanics.terminal+Vector2.from_angle(i*TAU/5)*70
	await capture('reactor_warning');g.arena_mechanics.update(2.51);await capture('reactor_complete')
	for dimensions in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=dimensions;await process_frame;g.update_safe_area();start('docks',3,0);g.remaining=44;g.arena_mechanics.update(.01);g.player.position+=Vector2(0,220)
		for i in range(4):g.spawn_enemy('grunt');g.enemies.back().pos=g.arena_mechanics.hazards[0].pos+Vector2.from_angle(i*TAU/4)*50
		await capture('container_warning_'+str(dimensions.x));g.arena_mechanics.update(2.01);await capture('container_landed_'+str(dimensions.x))
	root.size=Vector2i(1600,900);await process_frame;g.update_safe_area()
	for arena in ['reactor','docks']:
		start(arena,10);g.prepare_wave();await capture(arena+'_boss_intro');g.begin_wave();var boss=g.enemies[0];boss.pos=g.player.position+Vector2(240,0);g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01);await capture(arena+'_boss_warning')
	start('docks',3);g.pause_game();g.arena_coach.show(g.pause_menu);await capture('pause_help')
	for arena in ['reactor','docks']:
		g.main_menu();g.arena_select(g.Arenas.IDS.find(arena));await capture(arena+'_map')
	g.saved=original;g.save_game();g.free();await process_frame;quit()
