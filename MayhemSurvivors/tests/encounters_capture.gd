extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.refresh_hud();g.queue_redraw();if is_instance_valid(g.joystick):g.joystick.queue_redraw()
	for i in range(5):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/encounter_'+name+'.png');print('ENCOUNTER FRAME ',name)
func setup(arena:String,hero:int,wave:int):
	g.selected=hero;g.arena_id=arena;g.start_run();g.wave_number=wave;g.begin_wave();g.remaining=40;g.run_time=19
	g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll()
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	g.saved=g.default_save();g.saved.wins=1;g.saved.settings.shop_help_seen=true
	setup('scrapyard',0,4);g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2(-230,-45);e.elite_clock=0;g.encounters.movement(e,Vector2.RIGHT,.01);e.elite_clock=.6
	await capture('ram_warning')
	setup('reactor',1,4);g.spawn_enemy('grunt');e=g.enemies.back();e.pos=g.player.position+Vector2(-170,-20);e.elite_clock=0;g.encounters.movement(e,Vector2.RIGHT,.01);e.elite_clock=1.0
	await capture('pulse_warning')
	g.encounters.movement(e,Vector2.RIGHT,2);var ring=g.encounters.hazards[0];g.player.position=ring.origin+Vector2.from_angle(ring.angle)*ring.radius;g.camera.reset_smoothing();g.camera.force_update_scroll()
	await capture('pulse_gap')
	g.damage_enemy(e,100000);g.cleanup();g.coins=220;g.open_shop();await capture('elite_cache')
	setup('scrapyard',1,10);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(260,-90);boss.hp=boss.max_hp*.64;g.encounters.update(.01);g.encounters.update(1.3);g.encounters.update(.01)
	await capture('overlord_phase_two')
	setup('reactor',2,10);boss=g.enemies[0];boss.pos=g.player.position+Vector2(250,-65);boss.hp=boss.max_hp*.29;g.encounters.update(.01);g.encounters.update(1.3);g.encounters.update(.01)
	await capture('guardian_phase_three')
	g.queue_free();await process_frame;quit()
