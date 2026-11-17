extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(id:String):
	g.queue_redraw();g.refresh_hud()
	for i in range(12):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/axel_'+id+'.png');print('AXEL FRAME ',id)
func fresh():
	g.selected=0;g.arena_id='scrapyard';g.run_mode='campaign';g.start_run();g.wave_number=5;g.prepare_wave()
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	fresh();await capture('intro')
	g.begin_wave();g.spawn_clock=999;g.camera.reset_smoothing();g.camera.force_update_scroll();var e:Dictionary=g.breaker.actor();e.pos=g.player.position+Vector2(290,0)
	g.breaker.begin_attack('ring',e);g.breaker.clock=.55;await capture('ring_warning')
	g.breaker.update(.6);g.breaker.update_hazards(.4);await capture('shockwave')
	g.breaker.rings.clear();g.hit_feedback.clear();g.breaker.begin_attack('hammer',e);g.breaker.clock=.45;await capture('hammer_warning')
	g.breaker.update(.5);await capture('hammer')
	g.breaker.cracks.clear();g.hit_feedback.clear();g.breaker.begin_attack('charge',e);g.breaker.clock=.55;await capture('charge')
	e.hp=e.max_hp*.35;g.breaker.update(.01);g.breaker.begin_attack('hammer',e);g.breaker.clock=.6;g.breaker.add_crack(e.pos,e.pos+Vector2(-300,200),9);await capture('rage')
	g.xp=0;g.damage_enemy(e,100000);await capture('defeat')
	while g.state==g.State.LEVEL_UP:g.apply_upgrade('vital');g.if_more_levels()
	await capture('shop');g.next_shop_wave();await capture('wave6')
	g.wave_number=10;g.begin_wave();g.enemies[0].pos=g.player.position+Vector2(290,0);await capture('final_boss')
	g.audio_director.stop();g.alert_audio.stop();g.alert_audio.stream=null
	for voice in g.sfx_players:voice.stop();voice.stream=null
	for i in range(6):await process_frame
	g.queue_free();await process_frame;quit()
