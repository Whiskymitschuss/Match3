extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw()
	for i in range(6):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/interface_'+name+'.png');print('INTERFACE FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.games=1;g.saved.highest_wave=10;g.saved.kills=520;g.saved.time=548;g.saved.settings.shop_help_seen=true
	g.statistics();await capture('statistics')
	g.recent_runs_screen();await capture('history_empty')
	g.challenges_screen();await capture('challenges')
	g.selected=1;g.start_run();g.begin_wave();g.xp=g.required_xp();g.level_up();await capture('level_up')
	g.resume();g.pause_game();g.confirm_leave();await capture('confirm_leave')
	g.test_mode=true;g.state=g.State.SHOP;g.weapons=[{'id':'blaster','level':5,'clock':0.0}];g.specialization_screen();await capture('evolution')
	g.choose_specialization('blaster',g.Specs.choices('blaster')[0]);g.weapons.append({'id':'arc','level':2,'clock':0.0});g.shop_view.confirm_salvage('arc');await capture('salvage')
	for id in g.run_items.data:g.run_items.add(id)
	g.level=21;g.wave_number=10;g.run_time=548;g.kills=520;g.dealt=56363;g.earned=1780;g.finish(false);await capture('defeat_full_build')
	g.queue_free();await process_frame;quit()
