extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw()
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	var im=root.get_texture().get_image()
	im.save_png('res://tests/'+name+'.png')
	var black=0
	for y in range(im.get_height()):
		for x in [0,1,im.get_width()-2,im.get_width()-1]:
			var c=im.get_pixel(x,y)
			if maxf(c.r,maxf(c.g,c.b))<.02:black+=1
	print('FULLSCREEN FRAME ',name,' pixels=',im.get_size(),' viewport=',g.get_viewport_rect().size,' side_black_pixels=',black,'/',im.get_height()*4,' safe=',g.safe_logical,' ability=',g.ability_rect())
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	g.saved=g.default_save();g.saved.wins=1
	for entry in [[Vector2i(1280,591),'wide'],[Vector2i(1280,720),'16_9'],[Vector2i(1024,768),'tablet']]:
		root.size=entry[0]
		await process_frame
		await process_frame
		g.update_safe_area()
		g.main_menu()
		await capture('fullscreen_menu_'+entry[1])
		g.selected=1;g.arena_id='reactor';g.start_run();g.wave_number=4;g.begin_wave()
		g.camera.reset_smoothing();g.camera.force_update_scroll()
		for i in range(10):
			g.spawn_enemy(['grunt','runner','tank'][i%3]);g.enemies.back().pos=g.player.position+Vector2.from_angle(i*TAU/10)*(170+i*10)
		await capture('fullscreen_combat_'+entry[1])
	g.finish(true)
	await capture('fullscreen_result_tablet')
	root.size=Vector2i(1280,591)
	await process_frame
	await process_frame
	g.update_safe_area();g.start_run();g.wave_number=10;g.begin_wave();g.finish(true)
	await capture('fullscreen_result_wide')
	g.queue_free();await process_frame;quit()
