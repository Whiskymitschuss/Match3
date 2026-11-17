extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw();g.refresh_hud()
	for i in range(12):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/ravox_'+name+'.png');print('RAVOX FRAME ',name)
func setup(arena:String,hero:int):
	g.selected=hero;g.arena_id=arena;g.start_run();g.wave_number=5;g.begin_wave();g.remaining=44;g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll();g.spawn_enemy('ravox')
	var e=g.enemies.back();e.pos=g.player.position+Vector2(260,-50);e.ravox_clock=0;g.ravox.velocity(e,Vector2.LEFT,.01);e.ravox_clock=.7
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	setup('scrapyard',0);await capture('warning')
	setup('reactor',3);await capture('reactor')
	g.twinkle.apply_stun(g.enemies[0],1);await capture('soap')
	g.queue_free();await process_frame;quit()
