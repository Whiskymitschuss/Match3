extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.camera.position_smoothing_enabled=false;g.camera.reset_smoothing();g.camera.force_update_scroll()
	g.refresh_hud();g.queue_redraw()
	if is_instance_valid(g.joystick):g.joystick.queue_redraw()
	if is_instance_valid(g.ability_button):g.ability_button.queue_redraw()
	for i in range(5):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/synergy_'+name+'.png');print('SYNERGY FRAME ',name)
func start(hero:int,wave:int=3):
	g.main_menu();g.selected=hero;g.arena_id='reactor' if hero==1 else 'scrapyard';g.run_mode='campaign';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.shop_help_seen=true
	for dimensions in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=dimensions;await process_frame;await process_frame;g.update_safe_area()
		for hero in range(3):
			start(hero);g.run_items.add(g.synergies.module_id())
			for i in range(5):g.spawn_enemy('tank');var e=g.enemies.back();e.pos=g.player.position+Vector2.from_angle(i*.6-.9)*160;e.hp=2000
			g.hero_ability.activate()
			if hero==1:g.hero_ability.update(.66)
			if hero!=2:
				for e in g.enemies:g.synergies.mark(e)
			await capture(['bruiser','sparky','shade'][hero]+'_'+str(dimensions.x))
			if dimensions.x==1600:
				g.pause_game();g.synergies.show_help(g.resume);await capture('rules_'+str(hero));g.cleanup();g.run_items.clear();g.coins=150;g.open_shop();await capture('shop_'+str(hero))
	root.size=Vector2i(1600,900);await process_frame;g.update_safe_area();start(0,10);g.run_items.add('fault_core');var boss=g.enemies[0];boss.pos=g.player.position+Vector2(160,0);g.hero_ability.activate();await capture('boss_marked')
	g.saved=original;g.save_game();g.free();await process_frame;quit()
