extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/presentation_'+name+'.png');print('PRESENTATION FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;g.saved.settings.shop_help_seen=true
	g.main_menu();await capture('menu')
	g.character_select();await capture('characters')
	g.arena_select();await capture('arenas')
	g.selected=1;g.arena_id='reactor';g.start_run();await capture('preparation')
	g.begin_wave();g.pause_game();g.settings(g.pause_menu);await capture('settings')
	g.pause_menu();await capture('pause')
	g.resume();g.wave_number=10;g.run_time=548;g.kills=520;g.dealt=56363;g.earned=1780;g.finish(true);await capture('victory')
	g.queue_free();await process_frame;quit()
