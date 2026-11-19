extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	for i in range(6):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/recap_'+name+'.png');print('RECAP FRAME ',name)
func fixture(hero:int=0,mode:String='campaign',count:int=10):
	g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.run_mode=mode;g.start_run();g.begin_wave();g.run_items.add(['fault_core','ion_relay','umbra_spool'][hero]);g.recap.reset();g.run_time=0;g.dealt=0;g.kills=0;g.earned=0;g.run_abilities=0
	for wave in range(1,count+1):
		g.wave_number=wave;g.recap.begin();g.recap.current.boss_name=['SÄUREPANZER','SCHROTTWALZE','BREAKER AXEL','STURMADMIRAL','THE OVERLORD'][mini(4,wave/2-1)] if wave%2==0 else '';g.recap.current.boss=wave%2==0
		var seconds=14.5+wave*.7 if wave%2==0 else 60.0;g.recap.tick(seconds);g.run_time+=seconds;g.dealt+=350*wave;g.kills+=7*wave;g.earned+=45+wave*10;g.run_abilities+=2;g.recap.hurt(3+wave);g.recap.proc();g.recap.bonus(50+wave*4);g.recap.close('cleared')
	g.coins=250;g.level=18;g.weapons[0].level=5;g.weapons[0].spec=g.Specs.choices(g.weapons[0].id)[0];g.finish(mode=='campaign')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.reduced_motion=true
	var sizes=[Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]
	for i in range(3):
		root.size=sizes[i];await process_frame;await process_frame;g.update_safe_area();fixture(i);var suffix=str(sizes[i].x)
		await capture('result_'+suffix);g.recap_view.show_current();await capture('overview_'+suffix);g.recap_view.select('waves');await capture('waves_'+suffix);g.recap_view.select('module');await capture('module_'+suffix);g.main_menu();g.recent_runs_screen();await capture('history_'+suffix)
	root.size=Vector2i(1600,900);await process_frame;g.update_safe_area();g.recap_view.show(g.RunRecords.clean_run({'character':'bruiser','wave':6}),g.main_menu);await capture('legacy')
	fixture(1,'endless',65);g.recap_view.show_current();g.recap_view.select('waves');g.recap_view.only_bosses=true;g.recap_view.render();await capture('endless_bosses');g.recap_view.only_bosses=false;g.recap_view.page=2;g.recap_view.render();await capture('endless_page')
	g.saved=original;g.save_game();g.free();await process_frame;quit()
