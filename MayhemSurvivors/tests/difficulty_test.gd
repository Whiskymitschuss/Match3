extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Scores=preload('res://scripts/progression/difficulty_records.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.001
func start(id:String,arena:String='scrapyard',mode:String='campaign',wave:int=1):
	g.selected=1;g.selected_difficulty=id;g.arena_id=arena;g.run_mode=mode;g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	start('normal');g.spawn_enemy('grunt');var normal=g.enemies[0].duplicate();var interval=g.rules.current_wave().interval
	check(normal.hp==40 and normal.speed==105 and normal.damage==8,'Normal exact opening baseline retained')
	for id in ['veteran','mayhem']:
		start(id);g.spawn_enemy('grunt');var e=g.enemies[0];var d=g.Difficulty.definition(id)
		check(near(e.hp,40*d.hp) and near(e.speed,105*d.speed) and near(e.damage,8*d.damage),'Actual opening scaling '+id)
		check(near(g.rules.current_wave().interval,interval*d.interval),'Real spawn interval '+id)
		check(e.xp_reward==roundi(5*d.reward) and e.coin_reward==roundi(2*d.reward),'Real rounded rewards '+id)
		for arena in g.Arenas.IDS:
			start('normal',arena,'campaign',10);var baseline=g.enemies[0].max_hp
			start(id,arena,'campaign',10);check(near(g.enemies[0].max_hp,baseline*d.boss_hp),'Boss factor '+id+arena)
			g.damage_enemy(g.enemies[0],1000000000);check(g.saved.difficulty_records[id].campaign[arena].wins==1,'Distinct campaign victory '+id+arena)
			start(id,arena,'endless',20);g.damage_enemy(g.enemies[0],1000000000)
			check(g.state==g.State.SHOP and not g.result_recorded,'Endless boss continues '+id+arena)
			g.next_shop_wave();g.begin_wave();check(g.wave_number==21,'Endless crosses twenty '+id+arena)
	start('normal','scrapyard','campaign',4);g.remaining=40;g.spawn_enemy('grunt');var elite_hp=g.enemies[0].max_hp
	start('mayhem','scrapyard','campaign',4);g.remaining=40;g.spawn_enemy('grunt');var elite=g.enemies[0]
	check(elite.has('elite') and near(elite.max_hp,elite_hp*1.45),'Elite HP receives difficulty factor once')
	check(elite.coin_reward==21 and elite.xp_reward==29,'Elite replacement rewards receive bonus once')
	start('normal');g.selected_difficulty='mayhem';g.spawn_enemy('grunt')
	check(g.enemies[0].hp==40 and g.run_difficulty=='normal','Menu selection cannot mutate active run')
	start('mayhem');g.ravox.data.first_wave=5;g.wave_number=6;g.spawn_enemy('ravox');var e=g.enemies[0];e.pos=g.player.position+Vector2(250,0);e.ravox_clock=0;g.ravox.velocity(e,Vector2.LEFT,2)
	check(e.ravox_clock==1.25,'Difficulty never shortens warning')
	start('mayhem');var hp=g.hp;g.run_mode='tutorial';g.spawn_enemy('grunt');check(g.enemies[0].hp==40 and g.enemies[0].speed==105,'Training always uses normal values')
	g.run_mode='campaign'
	var legacy=g.default_save();legacy.erase('difficulty_records');legacy.arena_records.scrapyard.games=3;legacy.arena_records.scrapyard.wins=1;legacy.arena_records.scrapyard.highest_wave=10;legacy.endless_records.docks.runs=2;legacy.endless_records.docks.highest_wave=31
	var path='user://difficulty_test.json';Save.save_local(legacy,path);var loaded=Save.load_local(path)
	check(loaded.difficulty_records.normal.campaign.scrapyard.runs==3 and loaded.difficulty_records.normal.campaign.scrapyard.wins==1,'Old campaign attributed to Normal only')
	check(loaded.difficulty_records.normal.endless.docks.highest_wave==31 and loaded.difficulty_records.mayhem.endless.docks.runs==0,'Old endless record preserved without invented higher tier')
	Scores.add(loaded,'mayhem','endless','docks',51,300,400,false);Save.save_local(loaded,path);loaded=Save.load_local(path)
	check(loaded.difficulty_records.mayhem.endless.docks.highest_wave==51 and loaded.difficulty_records.normal.endless.docks.highest_wave==31,'Difficulty scores survive disk roundtrip independently')
	check(not Scores.add(loaded,'forged','endless','docks',10,10,10,false),'Unknown tier rejected')
	loaded.difficulty_records.veteran.campaign.docks={'runs':-2,'wins':99,'highest_wave':999,'kills':'bad'};Save.save_local(loaded,path);loaded=Save.load_local(path)
	check(loaded.difficulty_records.veteran.campaign.docks.runs==0 and loaded.difficulty_records.veteran.campaign.docks.wins==0 and loaded.difficulty_records.veteran.campaign.docks.highest_wave==10,'Corrupt score fields sanitized')
	start('mayhem');var runs=g.saved.difficulty_records.mayhem.campaign.scrapyard.runs;g.finish(false);g.finish(false)
	check(g.saved.difficulty_records.mayhem.campaign.scrapyard.runs==runs+1,'Game end records once')
	g.main_menu();g.character_select();g.arena_select();g.difficulty_select();var selected=false
	for child in g.ui_root.get_children():
		if child is Button and child.text=='AUSWÄHLEN':child.pressed.emit();selected=true;break
	check(selected and g.state==g.State.ARENA_SELECT,'Real card button returns to arena selection')
	g.difficulty_statistics('mayhem','endless');check(g.ui_root.get_child_count()>8,'Real record board populated')
	g.saved=original;g.save_game();g.queue_free();await process_frame;DirAccess.remove_absolute(path)
	print('DIFFICULTY RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
