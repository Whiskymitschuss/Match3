extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(id:String):
	g.queue_redraw()
	for i in range(10):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/united_'+id+'.png');print('UNITED FRAME ',id)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area()
	g.saved=g.default_save();g.garage.save_path='user://united_capture.json';g.world_map.save_path=g.garage.save_path;g.main_menu();await capture('home')
	g.character_select();g.arena_select(9);await capture('map_locked')
	preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	g.arena_select(4);await capture('map_gardens')
	for i in [0,3,5,6,7,8,9,10]:g.character_select(i);await capture('hero_'+g.characters[i].id)
	g.main_menu();g.game_guide.show('heroes',6);await capture('guide_hero');g.game_guide.show('enemies',14);await capture('guide_enemy');g.game_guide.show('rules');await capture('guide_rules')
	g.game_guide.show('tech');await capture('guide_tech')
	g.main_menu();g.selected=6;g.arena_id='gardens';g.start_run();g.wave_number=3;g.begin_wave();g.spawn_clock=999;g.crit=0
	for i in range(10):
		g.spawn_enemy(preload('res://scripts/core/roster.gd').NEW_ENEMIES[i]);var e=g.enemies.back();e.pos=g.player.position+Vector2.from_angle(i*TAU/10)*260;e.hp=9999;e.max_hp=9999
	g.united.enemies.circle(g.player.position+Vector2(300,100),100,1.5,.4,10);g.hero_ability.activate();g.united.heroes.update(.2);g.update_weapons(.1);g.run_time=15;await capture('new_enemies_firestorm')
	for wave in [2,4,6,8,10]:
		g.wave_number=wave;g.prepare_wave();await capture('boss_intro_'+str(wave));g.begin_wave();var e=g.enemies[0];e.pos=g.player.position+Vector2(240,0);e.hp=e.max_hp*.3;g.united.bosses.update(.1);g.united.bosses.clock=0;g.united.bosses.update(.1);g.united.bosses.clock=0;g.united.bosses.update(.1);await capture('boss_combat_'+str(wave))
	g.pause_game();await capture('pause');g.game_guide.show('rules',0,g.pause_menu);await capture('pause_guide');g.resume();g.coins=900;g.open_shop();await capture('shop')
	g.main_menu();g.mastery_screen(10);await capture('mastery_nyx');g.statistics(10);await capture('statistics_nyx');g.endless_statistics(2);await capture('endless_page3');g.difficulty_statistics('normal','campaign',2);await capture('difficulty_page3')
	g.main_menu();g.settings(g.main_menu);await capture('settings');g.garage.show(10);await capture('garage_nyx')
	root.size=Vector2i(2340,1080);await process_frame;g.update_safe_area();g.arena_select(9);await capture('map_wide')
	root.size=Vector2i(1920,1440);await process_frame;g.update_safe_area();g.game_guide.show('heroes',10);await capture('guide_tablet')
	g.audio_director.stop();g.free();await process_frame;quit()
