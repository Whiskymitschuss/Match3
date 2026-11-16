extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.refresh_hud();g.queue_redraw()
	for i in range(20):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/twinkle_'+name+'.png');print('TWINKLE FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save()
	g.character_select(1);await capture('selection')
	g.selected=3;g.start_run();g.begin_wave();g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll();g.crit=0
	for at in [Vector2(100,0),Vector2(120,85),Vector2(-100,70),Vector2(0,-170)]:
		g.spawn_enemy('tank');g.enemies.back().pos=g.player.position+at
	g.update_weapons(.01);g.combat_visuals.rig('mop').swing=.13;g.combat_visuals.rig('mop').pulse=.05
	await capture('mop')
	g.hero_ability.activate();g.twinkle.update(.5);await capture('tornado')
	g.cleanup();g.state=g.State.SHOP;g.weapons[0].level=5;g.show_shop();await capture('evolution')
	g.queue_free();await process_frame;quit()
