extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw()
	for i in range(30):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/mastery_'+name+'.png');print('MASTERY FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save()
	g.mastery_screen(0,'neon');await capture('locked')
	g.saved.records.sparky.best_wave=10;g.saved.records.sparky.kills=602;g.saved.records.sparky.games=1;g.saved.records.sparky.wins=1
	g.Mastery.equip(g.saved,'sparky','champion');g.mastery_screen(1);await capture('champion')
	g.selected=1;g.start_run();g.begin_wave();g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll();await capture('combat')
	g.queue_free();await process_frame;quit()
