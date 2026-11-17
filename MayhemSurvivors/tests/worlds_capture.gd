extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw();g.refresh_hud()
	for i in range(20):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/worlds_'+name+'.png');print('WORLDS FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;g.saved.kills=500;g.saved.settings.tutorial_complete=true
	g.selected=3;g.character_select(1);g.arena_select(1);await capture('arenas')
	for arena in ['docks','foundry']:
		g.run_mode='endless';g.arena_id=arena;g.start_run();g.wave_number=20;g.begin_wave();g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll();g.enemies[0].pos=g.player.position+Vector2(280,0);await capture(arena)
	g.main_menu();g.tutorial.start();await capture('tutorial_intro')
	g.tutorial.next();await capture('tutorial_move');g.tutorial.stop(false)
	g.motion_settings();await capture('motion')
	g.main_menu();g.selected=4;g.character_select(1);await capture('kicksy_selection')
	g.arena_id='docks';g.run_mode='campaign';g.start_run();g.begin_wave();g.spawn_enemy('tank');g.enemies[0].pos=g.player.position+Vector2(180,0);g.update_weapons(.01);g.bombs.update(.3);await capture('kicksy_bomb')
	g.main_menu();await capture('home')
	g.queue_free();await process_frame;quit()
