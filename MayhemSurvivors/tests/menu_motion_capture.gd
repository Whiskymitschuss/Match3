extends SceneTree
var g
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	root.size=Vector2i(960,540);await process_frame;await process_frame;g.update_safe_area()
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.settings.master=0;g.update_music();g.test_mode=false;g.main_menu()
	DirAccess.make_dir_recursive_absolute('/tmp/mayhem-v09-motion')
	for frame in range(84):
		if frame==30:g.character_select()
		if frame==60:g.main_menu()
		await process_frame;await RenderingServer.frame_post_draw
		root.get_texture().get_image().save_png('/tmp/mayhem-v09-motion/frame%03d.png' % frame)
	g.test_mode=true;g.queue_free();await process_frame;quit()
