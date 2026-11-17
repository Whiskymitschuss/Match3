extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw();g.refresh_hud()
	for i in range(18):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/live_'+name+'.png');print('LIVE FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	g.character_select(4);await capture('hero')
	g.arena_select(2);await capture('arena')
	g.saved.meta.coins=480;g.saved.meta.daily.kills=100;g.reward_hub.show();await capture('daily')
	g.saved.meta.pass.xp=350;g.reward_hub.show('pass');await capture('pass')
	g.reward_hub.show('shop');await capture('shop')
	g.selected=3;g.arena_id='scrapyard';g.run_mode='campaign';g.start_run();g.wave_number=6;g.begin_wave();g.remaining=34;g.spawn_clock=999;g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll()
	var i=0
	for kind in ['bombling','longshot','hexling']:
		g.spawn_enemy(kind);var e=g.enemies.back();e.pos=g.player.position+Vector2(-270+i*270,-170);e.pack_clock=0;g.enemy_pack.velocity(e,Vector2.ZERO,.01);i+=1
	g.arena_events.update(.01);g.saved.meta.owned=['comet','mini_bot'];g.saved.meta.equipped.ring='comet';g.saved.meta.equipped.buddy='mini_bot';await capture('combat')
	g.queue_free();await process_frame;quit()
