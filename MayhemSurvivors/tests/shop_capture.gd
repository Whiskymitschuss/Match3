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
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	root.size=Vector2i(1280,591);await process_frame;await process_frame;g.update_safe_area()
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.settings.shop_help_seen=true;g.selected=1;g.start_run();g.begin_wave();g.cleanup();g.wave_number=4;g.coins=340;g.open_shop()
	g.weapons.append({'id':'arc','level':2,'clock':0.0});g.run_items.add('grip');g.run_items.add('plate')
	g.offers=[{'type':'weapon','id':'splitgun','name':'SPLITGUN','description':'Neue Waffe','rarity':'STANDARD','price':38}]
	for id in ['battery','coolant','boots']:
		var d=g.run_items.data[id];g.offers.append({'type':'item','id':id,'name':d.name,'description':d.description,'rarity':d.rarity,'price':int(d.price)+16})
	g.show_shop();await capture('shop_market_wide')
	g.shop_view.tab='items';g.show_shop();await capture('shop_items_wide')
	g.shop_view.tab='sets';g.show_shop();await capture('shop_sets_wide')
	g.shop_view.stats();await capture('shop_stats_wide')
	g.shop_view.weapon_details('blaster');await capture('shop_workbench_wide')
	g.shop_view.help_page(0);await capture('shop_tutorial_wide')
	g.queue_free();await process_frame;quit()
