extends SceneTree
const Data=preload('res://scripts/progression/recap_data.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const PATH='user://recap_test.json'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.02
func start(hero:int=0,wave:int=1,mode:String='campaign'):
	g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.run_mode=mode;g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func enemy(health:float=10000,offset:Vector2=Vector2(70,0)) -> Dictionary:
	g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+offset;e.hp=health;e.max_hp=health;e.speed=0;return e
func control(value:String,index:int=0):
	var found=g.ui_root.get_children().filter(func(n):return n is Button and n.text==value)
	return found[index] if index<found.size() else null
func tap(b:Button):
	if not b:check(false,'Expected actual UI control');return
	await process_frame;await process_frame
	var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
	if native_touch:
		at=root.get_final_transform()*at
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=9;e.position=at;e.pressed=down;Input.parse_input_event(e);await process_frame
	else:
		var motion=InputEventMouseMotion.new();motion.position=at;root.push_input(motion,true);await process_frame
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=at;e.global_position=at;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true);await process_frame
	await process_frame;await process_frame
func label_contains(value:String) -> bool:
	return g.ui_root.get_children().any(func(n):return n is Label and value in n.text)
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.world_map.save_path=PATH;g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.saved.settings.shop_help_seen=true
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for quality in ['LOW','MEDIUM','HIGH']:
		start();g.saved.settings.quality=quality;g.weapons[0].clock=999;g._physics_process(.2)
		check(near(g.recap.current.seconds,.2) and near(g.run_time,.2),'Actual combat clock records once '+quality)
		for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
			g.state=state;g._physics_process(10);g.recap.tick(10);g.recap.proc();g.recap.hurt(50);g.recap.bonus(50)
			check(near(g.recap.current.seconds,.2) and g.recap.current.hits==0 and g.recap.current.procs==0 and g.recap.current.combo_damage==0,'Measurement APIs freeze in '+str(state)+' '+quality)
		g.state=g.State.COMBAT;g.armor=2;g.hurt(10);check(g.recap.current.received==8 and g.recap.current.hits==1,'Actual armored HP loss measured '+quality)
		g.hurt(10);check(g.recap.current.hits==1,'Invulnerability prevents duplicate hit measurement '+quality)
		var a=enemy(5);var reward=a.coin_reward;g.damage_enemy(a,100);g.damage_enemy(a,100);g.remaining=0;g._physics_process(.1)
		var summary=g.recap.snapshot();var row=summary.waves[0]
		check(near(row.seconds,.3) and row.outcome=='cleared' and not row.boss,'Timed normal wave produces complete receipt '+quality)
		check(row.kills==1 and row.damage==5 and row.coins==reward and row.received==8,'No overkill, duplicate kill or duplicate coins in receipt '+quality)
		check(g.state==g.State.SHOP and g.recap.current.is_empty(),'Receipt closes before shop '+quality)
		g._physics_process(20);g.coins-=1;check(g.recap.snapshot()==summary,'Shop spending and time cannot mutate finished receipt '+quality)
		g.next_shop_wave();g.begin_wave();check(g.recap.current.wave==2 and g.recap.current.boss,'Next wave records real boss type '+quality)
		g.weapons[0].clock=999;g._physics_process(.4);var boss=g.enemies[0];g.damage_enemy(boss,1000000000)
		check(g.recap.rows.size()==2 and near(g.recap.rows[1].seconds,.4) and g.recap.rows[1].outcome=='cleared' and not g.recap.rows[1].boss_name.is_empty(),'Actual boss death stores fight duration and name '+quality)
		g.finish(false);summary=g.recap.snapshot();check(summary.waves.size()==2 and g.saved.recent_runs[0].analysis==summary,'Result and persisted campaign history share immutable analysis '+quality)
		var count=g.saved.recent_runs.size();g.finish(false);check(g.saved.recent_runs.size()==count and g.recap.snapshot()==summary,'Repeated finish cannot duplicate measurement or history '+quality)
		g.start_run();check(g.recap.rows.is_empty() and g.recap.current.is_empty() and g.recap.totals.damage==0,'New run resets all measurements '+quality)
	# Marginal module damage includes resistance/crit, but never attributes an already lethal base hit.
	for hero in [0,2]:
		start(hero);g.run_items.add(['fault_core','ion_relay','umbra_spool'][hero]);var a=enemy()
		if hero==0:g.hero_ability.activate();a.pos=g.player.position+Vector2(70,0)
		else:g.hero_ability.activate()
		g.damage_enemy(a,10,'weapon','hammer' if hero==0 else 'orbit');g.recap.close('abandoned');var summary=g.recap.snapshot()
		check(near(summary.totals.combo_damage,6 if hero==0 else 8) and summary.totals.procs==1 and summary.totals.abilities==1,'Actual module marginal damage and activation '+str(hero))
		start(hero);g.run_items.add(['fault_core','ion_relay','umbra_spool'][hero]);a=enemy(5)
		if hero==0:g.synergies.mark(a)
		else:g.synergies.ability_started('shadow_step')
		g.damage_enemy(a,10,'weapon','hammer' if hero==0 else 'orbit');g.recap.close('abandoned');summary=g.recap.snapshot()
		check(summary.totals.combo_damage==0 and summary.totals.damage==5 and summary.totals.procs==1,'Already lethal base hit grants no invented bonus damage '+str(hero))
	start(1);g.run_items.add('ion_relay');var a=enemy();var b=enemy(10000,Vector2(140,0));var c=enemy(10000,Vector2(210,0));g.synergies.mark(a);g.damage_enemy(a,12,'weapon','blaster');g.recap.close('abandoned')
	var summary=g.recap.snapshot();check(near(summary.totals.combo_damage,13.2) and near(summary.totals.damage,25.2) and summary.totals.procs==1,'Both actual secondary chain hits measured once')
	start(1);g.run_items.add('ion_relay');a=enemy();g.synergies.mark(a);g.damage_enemy(a,12,'weapon','blaster');g.recap.close('abandoned');summary=g.recap.snapshot()
	check(summary.totals.procs==1 and summary.totals.combo_damage==0 and summary.totals.damage==12,'Relay with no neighbor records activation and zero bonus honestly')
	for hero in range(3):
		start(hero);g.hp=3;g.hurt(10000);summary=g.recap.snapshot()
		check(g.state==g.State.GAME_OVER and summary.totals.received==3 and summary.waves[0].outcome=='defeat','Lethal loss caps at actual HP and closes before cleanup '+str(hero))
		start(hero,2);g.remaining=0;g.weapons[0].clock=999;g._physics_process(.01);summary=g.recap.snapshot()
		check(g.state==g.State.GAME_OVER and summary.waves[0].outcome=='timeout' and summary.waves[0].boss,'Boss timeout distinguished from death '+str(hero))
	start();g._physics_process(.1);g.pause_game();g.finish(false);check(g.recap.rows[0].outcome=='abandoned' and near(g.recap.rows[0].seconds,.1),'Leaving a paused run preserves clock and honest outcome')
	start(0,10);g.damage_enemy(g.enemies[0],1000000000);check(g.state==g.State.VICTORY and g.recap.rows.size()==1 and g.recap.rows[0].outcome=='cleared','Final-boss victory stores exactly one completed boss wave')
	start(0,13,'endless');g._physics_process(.1);var games=g.saved.games;var wins=g.saved.wins;g.hp=1;g.hurt(10000)
	check(g.saved.games==games and g.saved.wins==wins and g.saved.recent_runs[0].mode=='endless' and g.saved.recent_runs[0].wave==13,'Endless history preserves wave and does not inflate campaign statistics')
	Save.save_local(g.saved,PATH);var loaded=Save.load_local(PATH);check(loaded.recent_runs[0].analysis==g.saved.recent_runs[0].analysis and loaded.recent_runs[0].mode=='endless','Real JSON roundtrip preserves new bounded history')
	var old=g.RunRecords.clean_run({'character':'bruiser','wave':4});check(not old.has('analysis'),'Old records retain an explicit missing-analysis state')
	for bad in [null,[],{}, {'version':2,'waves':[]},{'version':1,'waves':['bad',{'wave':0,'outcome':'cleared'}]}]:check(Data.clean(bad).is_empty(),'Malformed analysis rejected '+str(bad))
	var source={'version':1,'waves':[{'wave':1,'outcome':'cleared','damage':10,'combo_damage':100,'seconds':-1,'received':NAN,'kills':'bad','boss':true,'boss_name':'BOSS\nINJECT'}, {'wave':1,'outcome':'cleared'},{'wave':2,'outcome':'bad'}]}
	summary=Data.clean(source);check(summary.waves.size()==1 and summary.waves[0].seconds==0 and summary.totals.combo_damage==10 and summary.totals.received==0 and summary.totals.kills==0 and summary.waves[0].boss_name=='BOSS INJECT','Untrusted counts, duplicates, enums, NaN and text sanitized')
	check(source.waves[0].combo_damage==100,'Sanitizer does not mutate caller data')
	# A long endless session keeps bounded rows while its complete totals survive JSON normalization.
	start(0,1,'endless')
	for wave in range(1,66):
		g.wave_number=wave;g.recap.begin();g.recap.tick(1);g.dealt+=10;g.recap.close('cleared')
	summary=g.recap.snapshot();check(summary.waves.size()==50 and summary.waves[0].wave==16 and summary.waves.back().wave==65 and summary.omitted==15 and summary.totals.seconds==65 and summary.totals.damage==650,'Long endless analysis keeps last 50 waves and all cumulative totals')
	check(Data.clean(summary)==summary,'Re-sanitization preserves bounded long-run totals')
	var copy=g.recap.snapshot();copy.waves[0].damage=999;check(g.recap.snapshot().waves[0].damage==10,'Snapshots detach from live run data')
	var seed=g.rng.state;g.recap.snapshot();check(g.rng.state==seed,'Analysis never consumes gameplay RNG')
	# Result/history/tab/filter/back controls work through real touch events.
	start();g._physics_process(.1);g.finish(false);g.test_mode=false;await tap(control('RUN-ANALYSE'))
	check(control('WELLEN & BOSSE')!=null and g.state==g.State.GAME_OVER,'Actual result button opens report without changing game state')
	await tap(control('WELLEN & BOSSE'));await tap(control('NUR BOSSE'));check(label_contains('noch keine Bosswelle'),'Boss filter has useful empty state');await tap(control('ZURÜCK'));check(control('RUN-ANALYSE')!=null,'Return restores usable result')
	g.test_mode=true;g.main_menu();g.statistics();g.test_mode=false;await tap(control('LETZTE RUNDEN'));check(control('ANALYSE')!=null,'Actual statistics button opens history');await tap(control('NÄCHSTE'));check(label_contains('2 / '),'Actual stored-history pagination advances');await tap(control('VORHERIGE'));check(label_contains('1 / '),'Actual stored-history pagination goes back');await tap(control('ANALYSE'));check(control('KLASSENMODUL')!=null,'Actual stored-history button opens report')
	await tap(control('KLASSENMODUL'));check(label_contains('KEIN MODUL GEKAUFT'),'Module page explains unpurchased module');await tap(control('ZURÜCK'));check(control('ANALYSE')!=null,'History return preserves usable list')
	g.recap_view.show(old,func():g.recent_runs_screen());check(label_contains('NOCH KEINE MESSDATEN'),'Old run explains absent detail instead of fabricated zero chart');await tap(control('ZURÜCK'));g.test_mode=true
	g.recap_view.show({'character':'bruiser','mode':'endless','analysis':summary},g.main_menu);g.recap_view.select('waves');g.test_mode=false
	await tap(control('NÄCHSTE'));check(g.recap_view.page==1,'Actual long-history pagination advances');await tap(control('VORHERIGE'));check(g.recap_view.page==0,'Actual pagination goes back');await tap(control('NUR BOSSE'));check(g.recap_view.only_bosses,'Actual boss filter toggles');await tap(control('ZURÜCK'));g.test_mode=true
	start(0,1,'tutorial');g._physics_process(.1);check(g.recap.current.is_empty() and g.recap.rows.is_empty(),'Tutorial never writes player run measurements')
	g.saved=original;g.save_game();var refs=[weakref(g.recap),weakref(g.recap_view)];g.free();DirAccess.remove_absolute(PATH)
	call_deferred('verify_lifetime',refs)
func verify_lifetime(refs:Array):
	# Unwind this test's coroutine and temporary method receivers before observing lifetime.
	await process_frame;await process_frame;await process_frame
	check(refs[0].get_ref()==null and refs[1].get_ref()==null,'Recorder and view release without reference cycles')
	print('RECAP RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)
