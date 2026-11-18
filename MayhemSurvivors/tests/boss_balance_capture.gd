extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(id:String):
	g.refresh_hud();g.queue_redraw()
	for i in range(6):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/boss_balance_'+id+'.png');print('BOSS BALANCE FRAME ',id)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	g.main_menu();g.selected=1;g.arena_id='docks';g.start_run()
	for wave in [2,4,6,8,10]:
		g.wave_number=wave;g.prepare_wave();await capture('intro_'+str(wave));g.begin_wave();var e=g.enemies[0];e.pos=g.player.position+Vector2(260,0)
		if wave==6:g.breaker.update(1.41)
		else:g.united.bosses.update(1.41)
		await capture('opening_'+str(wave))
	g.main_menu();g.character_select(2);await capture('shade_selection');g.game_guide.show('heroes',2);await capture('shade_guide');g.character_select(8);await capture('volt_selection')
	g.selected=2;g.arena_id='docks';g.start_run();g.begin_wave();g.damage_mult=2.2;g.weapons=[{'id':'orbit','level':5,'clock':0.0,'spec':'wide'}];g.open_shop();g.shop_view.weapon_details('orbit');await capture('orbit_details')
	g.main_menu();g.selected=8;g.start_run();g.begin_wave();g.damage_mult=2.2;g.weapons=[{'id':'tesla','level':5,'clock':0.0,'spec':'thunder_prism'}];g.open_shop();g.shop_view.weapon_details('tesla');await capture('tesla_details')
	g.audio_director.stop();g.free();await process_frame;quit()
