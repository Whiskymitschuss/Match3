extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
const ROOT='user://beta_test_capture'
var g
func _initialize():call_deferred('run')
func frame(name:String):
	g.queue_redraw()
	for i in range(6):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/beta_'+name+'.png');print('BETA FRAME ',name)
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT)
	g=load('res://scenes/boot/main.tscn').instantiate();g.profile_root=ROOT;g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	var nina=g.profiles.create('Nina');g.profiles.create('Tom');g.profiles.create('Luca');g.switch_profile(nina)
	# Controlled UI fixture; these values are not human playtest evidence.
	g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.saved.collection.heroes.append('sparky');g.saved.collection.levels.blaster=1;g.saved.meta.coins=240;g.saved.games=7;g.saved.wins=1;g.selected=1;g.save_game();g.saved.meta.coins=275;g.save_game()
	for size in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;await process_frame;g.update_safe_area();g.main_menu();await frame('home_'+str(size.x));g.profile_view.show();await frame('profiles_'+str(size.x));g.settings_view.show(g.main_menu,'profile');await frame('settings_'+str(size.x));g.beta_view.show(g.main_menu);await frame('help_'+str(size.x))
	root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area();g.main_menu();g.profile_view.show();g.profile_view.prompt(false);await frame('rename');g.profile_view.confirm_restore(g.main_menu);await frame('restore')
	g.main_menu();g.beta_view.show(g.main_menu);g.beta_view.guide=true;g.beta_view.render();await frame('guide')
	g.main_menu();g.arena_id='scrapyard';g.start_run();g.begin_wave();g.remaining=0;g.spawn_clock=999;g._physics_process(.01);g.confirm_frozen_run_exit();await frame('run_exit')
	g.free();call_deferred('finish_capture')
func finish_capture():
	await process_frame;await process_frame;await process_frame;Files.clear(ROOT);quit()
