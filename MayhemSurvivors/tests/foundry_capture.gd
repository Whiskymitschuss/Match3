extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.refresh_hud();g.queue_redraw()
	if is_instance_valid(g.joystick):g.joystick.queue_redraw()
	if is_instance_valid(g.ability_button):g.ability_button.queue_redraw()
	for i in range(5):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/foundry_'+name+'.png');print('FOUNDRY FRAME ',name)
func start(hero:int=0,wave:int=3):
	g.main_menu();g.selected=hero;g.arena_id='foundry';g.run_mode='campaign';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area();g.main_menu();g.arena_select(3);await capture('map')
	start();g.state=g.State.WAVE_PREPARATION;g.arena_coach.show(g.prepare_wave);await capture('coach');g.saved.settings.arena_briefings=['foundry'];g.prepare_wave();await capture('briefing')
	for dimensions in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=dimensions;await process_frame;g.update_safe_area();start();var v=g.arena_mechanics.valves.stations[0];v.age=8.4
		await capture('ready_'+str(dimensions.x));g.player.position=v.pos;v.age=7.6;g.arena_mechanics.update(.81)
		var h=g.arena_mechanics.hazards[0]
		for i in range(5):g.spawn_enemy('grunt');g.enemies.back().pos=h.rect.get_center()+Vector2.from_angle(i*TAU/5)*35
		await capture('warning_'+str(dimensions.x));g.arena_mechanics.update(1.61);await capture('impact_'+str(dimensions.x))
	root.size=Vector2i(1600,900);await process_frame;g.update_safe_area();start(1);var v=g.arena_mechanics.valves.stations[1];g.player.position=v.pos;v.age=7.6;g.arena_mechanics.update(.81);await capture('vertical')
	g.pause_game();g.arena_coach.show(g.pause_menu);await capture('pause_help')
	start(5,10);g.prepare_wave();await capture('boss_intro');g.begin_wave();var boss=g.enemies[0];boss.pos=g.player.position+Vector2(240,0);g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01);await capture('boss_warning')
	g.saved=original;g.save_game();g.free();await process_frame;quit()
