extends SceneTree
var g
func _initialize():call_deferred('run')
func frame(name:String):
	g.queue_redraw()
	if is_instance_valid(g.joystick):g.joystick.queue_redraw()
	if is_instance_valid(g.ability_button):g.ability_button.queue_redraw()
	g.camera.position_smoothing_enabled=false;g.camera.reset_smoothing();g.camera.force_update_scroll()
	for i in range(6):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/presentation_pack_'+name+'.png');print('PACK FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.saved.meta.coins=1000
	for size in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;await process_frame;g.update_safe_area();g.selected=0;g.main_menu();await frame('home_'+str(size.x))
		for section in ['audio','graphics','controls']:g.settings_view.show(g.main_menu,section);await frame(section+'_'+str(size.x))
	root.size=Vector2i(1600,900);await process_frame;g.update_safe_area()
	for hero in range(11,15):
		g.main_menu();g.selected=hero;g.character_select(hero);await frame(g.characters[hero].id+'_select');g.arena_id='scrapyard';g.start_run();g.begin_wave();g.spawn_clock=999;g.crit=0
		g.saved.collection.levels.toxic_stripe=1;g.run_loadout.skin='toxic_stripe' if hero==11 else ('ember_edge' if hero==12 else ('arctic_chrome' if hero==13 else 'cyan_core'))
		for i in range(5):g.spawn_enemy('tank');g.enemies.back().pos=g.player.position+Vector2.from_angle(i*.7-1.4)*160;g.enemies.back().hp=3000
		g.hero_ability.activate();g.crew.update(.12 if hero==12 else .51);g.update_weapons(.01);g.update_shots(.08);g.refresh_hud();await frame(g.characters[hero].id+'_combat')
	g.main_menu();g.garage.show(11,'skin');await frame('skins_one');g.garage.show(11,'skin',1);await frame('skins_two')
	g.saved=original;g.save_game();g.free();await process_frame;quit()
