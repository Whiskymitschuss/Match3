extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
const ROOT='user://beta_test_new_player_capture'
var g
func _initialize():call_deferred('run')
func frame(label:String):
	g.queue_redraw()
	for i in range(8):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/new_player_'+label+'.png')
	print('NEW PLAYER FRAME ',label)
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT)
	g=load('res://scenes/boot/main.tscn').instantiate();g.profile_root=ROOT;g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved.settings.master=0;g.saved.settings.reduced_motion=true
	for size in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;await process_frame;g.update_safe_area()
		g.main_menu();await frame('home_'+str(size.x))
		g.play();await frame('welcome_'+str(size.x))
		g.character_select(1);await frame('locked_'+str(size.x))
		g.arena_select(1);await frame('world_'+str(size.x))
		g.garage.cases();await frame('cases_'+str(size.x))
	g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT);print('NEW PLAYER CAPTURE RESULT PASS');quit()
