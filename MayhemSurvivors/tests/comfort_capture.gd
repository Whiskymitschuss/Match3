extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
var g
func _initialize():call_deferred('run')
func frame(name:String):
	for i in range(5):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/comfort_'+name+'.png')
	print('COMFORT CAPTURE ',name)
func run():
	var profile='user://beta_test_capture_comfort';Files.clear(profile);DirAccess.make_dir_recursive_absolute(profile)
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=profile;root.add_child(g);g.set_physics_process(false);g.saved.settings.master=0;g.saved.settings.reduced_motion=true
	root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area()
	g.presets_view.Model.store(g.saved,'bruiser',0);g.presets_view.show(0);await frame('presets_1600')
	for l in g.ui_root.get_children():
		if l is Label and l.text.begins_with('BUILDS /'):print('HEADING RECT ',l.get_rect(),' SAFE ',g.safe_logical)
	g.main_menu();g.leaderboards_view.show();await frame('records_1600')
	root.size=Vector2i(1440,1080);await process_frame;await process_frame;g.update_safe_area();g.touch_editor.show(g.main_menu);await frame('layout_1440')
	g.touch_editor.leave();g.free();await process_frame;await create_timer(.25).timeout;Files.clear(profile);quit()
