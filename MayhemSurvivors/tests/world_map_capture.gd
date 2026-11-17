extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(id:String):
	g.queue_redraw()
	for i in range(14):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/world_map_'+id+'.png');print('WORLD MAP FRAME ',id)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	g.saved=g.default_save();g.world_map.save_path='user://world_map_capture_020.json';g.garage.save_path=g.world_map.save_path;g.main_menu();g.character_select();g.arena_select(0);await capture('fresh')
	g.arena_select(1);await capture('locked')
	g.world_map.wallet_help();await capture('currencies')
	g.arena_id='scrapyard';g.start_run();g.wave_number=10;g.begin_wave();g.run_time=554;g.run_waves=9;g.level=18;g.kills=602;g.dealt=48700;g.damage_enemy(g.enemies[0],1000000000);await capture('victory')
	g.arena_select(0);await capture('reward');g.world_map.claim('scrapyard');g.world_map.show();await capture('claimed')
	g.arena_select(1);await capture('next_world')
	for id in ['reactor','docks','foundry']:
		g.WorldProgress.complete(g.saved,id,'campaign',true,10);g.Arenas.sync(g.saved);g.saved.arena_records[id].highest_wave=10;g.saved.arena_records[id].wins=1
	g.arena_select(3);await capture('complete')
	g.run_mode='endless';g.saved.endless_records.foundry.highest_wave=31;g.saved.endless_records.foundry.runs=4;g.world_map.show();await capture('endless')
	g.world_map.error='Speichern fehlgeschlagen. Bitte erneut versuchen.';g.world_map.show();await capture('save_retry');g.world_map.error=''
	root.size=Vector2i(2340,1080);await process_frame;g.update_safe_area();g.world_map.show();await capture('wide')
	root.size=Vector2i(1920,1440);await process_frame;g.update_safe_area();g.world_map.show();await capture('tablet')
	g.audio_director.stop();g.alert_audio.stop();g.alert_audio.stream=null
	for voice in g.sfx_players:voice.stop();voice.stream=null
	for i in range(6):await process_frame
	g.queue_free();await process_frame;DirAccess.remove_absolute('user://world_map_capture_020.json');quit()
