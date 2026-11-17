extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw();g.refresh_hud()
	for i in range(16):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/steelfist_'+name+'.png');print('STEELFIST FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();g.saved.settings.shop_help_seen=true;g.saved.wins=1
	g.character_select(5);await capture('hero')
	g.selected=5;g.arena_id='foundry';g.run_mode='campaign';g.start_run();g.begin_wave();g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll();g.spawn_clock=999
	for i in range(6):
		g.spawn_enemy('tank' if i%2==0 else 'grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2.from_angle(i*TAU/6)*170;e.hp=1000;e.max_hp=1000
	await capture('idle')
	g.weapons[0].clock=0;g.steelfist.attacks=3;g.enemies[0].pos=g.player.position+Vector2(100,0);g.update_weapons(.01);g.combat_visuals.update(.12);await capture('double')
	g.hero_ability.activate();g.steelfist.update(.25);await capture('ultimate')
	g.cleanup();g.open_shop();g.weapons[0].level=5;g.specialization_screen();await capture('evolution')
	g.choose_specialization('tools','pressure_breaker');g.shop_view.weapon_details('tools');await capture('weapon')
	g.mastery_screen(5);await capture('mastery')
	g.statistics(5);await capture('stats')
	g.queue_free();await process_frame;quit()
