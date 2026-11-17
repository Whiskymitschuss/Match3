extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw();g.refresh_hud()
	for i in range(16):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/garage_'+name+'.png');print('GARAGE FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();g.garage.save_path='user://garage_capture.json'
	g.character_select(5);await capture('locked')
	g.garage.cases();await capture('cases')
	g.garage.chances('crew');await capture('chances')
	g.garage.open_case('crew');await capture('reveal');g.garage.transact('ack','',g.saved.collection.pending.serial)
	preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	for id in g.Collection.catalog().items:g.saved.collection.levels[id]=3 if g.Collection.catalog().items[id].ranked else 1
	for id in ['comet','mini_bot']:g.saved.meta.owned.append(id)
	g.saved.meta.equipped.ring='comet';g.saved.meta.equipped.buddy='mini_bot';g.saved.collection.parts=120;g.saved.meta.coins=245
	for hero in g.Collection.HEROES:
		for id in ['reactor_plate','neon_soles','neon_visor','heart_module','frost_nova','cyan_core']:g.Collection.equip(g.saved,hero,id)
	g.garage.show(5,'body');await capture('outfit')
	for i in range(6):g.garage.show(i,'head');await capture('hero'+str(i))
	g.garage.show(0,'spell');await capture('spells')
	g.garage.show(1,'weapon');await capture('weapons')
	g.selected=5;g.arena_id='reactor';g.saved.wins=1;g.start_run();g.begin_wave();g.camera.reset_smoothing();g.camera.force_update_scroll();g.spawn_clock=999
	for i in range(6):
		g.spawn_enemy('tank' if i%2==0 else 'grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2.from_angle(i*TAU/6)*170;e.hp=1000;e.max_hp=1000
	g.equipped_spell.activate();await capture('combat')
	g.finish(false);g.main_menu();g.garage.cases();g.test_mode=false;g.garage.open_case('style');await capture('opening')
	for i in range(90):await process_frame
	g.test_mode=true;g.audio_director.stop()
	for voice in g.sfx_players:voice.stop();voice.stream=null
	g.alert_audio.stop();g.alert_audio.stream=null
	for i in range(6):await process_frame
	g.queue_free();await process_frame;DirAccess.remove_absolute('user://garage_capture.json');quit()
