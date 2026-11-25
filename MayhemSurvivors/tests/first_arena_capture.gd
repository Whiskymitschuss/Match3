extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.refresh_hud();g.queue_redraw()
	if is_instance_valid(g.joystick):g.joystick.queue_redraw()
	if is_instance_valid(g.ability_button):g.ability_button.queue_redraw()
	for i in range(5):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/first_arena_'+name+'.png');print('FIRST ARENA FRAME ',name)
func start(wave:int=1):
	g.main_menu();g.selected=0;g.arena_id='scrapyard';g.run_mode='campaign';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save()
	g.play();await capture('welcome');g.tutorial.start();await capture('training_intro');g.tutorial.next();await capture('training_move')
	g.tutorial.step=5;g.tutorial.enter_step();await capture('training_ability');g.tutorial.stop(false)
	start();g.saved.settings.shop_help_seen=true;g.coins=300;g.open_shop();await capture('market');g.bruiser_builds.show();await capture('build_paths')
	g.weapons[0].level=5;g.show_shop();await capture('evolution');g.choose_specialization('hammer','quake');g.shop_view.weapon_details('hammer');await capture('quake_details')
	start(3);g.prepare_wave();await capture('wave_briefing');g.begin_wave();g.remaining=35;g.scrapyard_salvage.update(.01);await capture('salvage_offer')
	g.player.position=g.scrapyard_salvage.position;g.scrapyard_salvage.update(1.2);await capture('salvage_active')
	for i in range(80):g.player.position=Vector2(1200,800);g.scrapyard_salvage.update(.1);g.arena_hazards.update(.1)
	await capture('salvage_complete')
	for dimensions in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=dimensions;await process_frame;g.update_safe_area();start(2);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(250,0);g.united.bosses.update(1.41);await capture('boss_'+str(dimensions.x))
	root.size=Vector2i(1600,900);await process_frame;g.update_safe_area();start(10);g.run_waves=9;g.kills=466;g.run_time=355;g.damage_enemy(g.enemies[0],10000000)
	await capture('victory');g.reward_details();await capture('reward_details');g.show_result();g.arena_select(0);await capture('world_reward')
	g.saved=original;g.save_game();g.free();await process_frame;quit()
