extends SceneTree
const C=preload('res://scripts/progression/collection.gd')
const Compare=preload('res://scripts/progression/run_comparison.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const PATH='user://progress_comparison_test.json'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func control(value:String):
	for node in g.ui_root.get_children():
		if node is Button and node.text==value:return node
	return null
func contains(value:String) -> bool:return g.ui_root.get_children().any(func(n):return n is Label and value in n.text)
func tap(b:Button):
	if b==null:check(false,'Expected actual progress or comparison control');return
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
func actual_run(hero:int=0,arena:String='scrapyard',mode:String='campaign',difficulty:String='normal') -> Dictionary:
	g.main_menu();g.selected=hero;g.selected_difficulty=difficulty;g.arena_id=arena;g.run_mode=mode;g.start_run();g.begin_wave();g.spawn_clock=999;g.crit=0;g.weapons[0].clock=999
	g._physics_process(1);g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2(300,0);e.hp=20;e.max_hp=20;g.damage_enemy(e,50);g.hurt_clock=0;g.hurt(10);g.remaining=0;g._physics_process(.1);g.finish(false)
	return g.saved.recent_runs[0].duplicate(true)
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.garage.save_path=PATH;g.saved.settings.shop_help_seen=true
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for id in ['crew','arsenal','style']:
		g.saved.meta.coins=0
		var d=C.catalog().cases[id];var progress=C.case_progress(g.saved,id);var price=int(d.price)
		check(progress.ticket==0 and not progress.ready and progress.missing>0,'Fresh account must earn its first case '+id)
		g.saved.collection.tickets[id]=0
		for coins in [0,price-1,price,price+25]:
			g.saved.meta.coins=coins;var before=g.saved.duplicate(true);progress=C.case_progress(g.saved,id)
			check(progress.needed==maxi(0,price-coins) and progress.ready==(coins>=price),'Exact affordable case threshold '+id+' '+str(coins))
			check(g.saved==before,'Progress display does not mutate currency, seed or tickets')
	check(C.case_progress(g.saved,'invalid').is_empty(),'Unknown case cannot produce a misleading offer')
	g.saved=g.default_save();g.saved.collection.heroes=C.HEROES.duplicate();g.saved.collection.tickets={'crew':0,'arsenal':0,'style':0};g.saved.meta.coins=100000
	check(not C.case_progress(g.saved,'crew').ready and C.case_progress(g.saved,'crew').guarantee==0 and C.next_case(g.saved).id=='arsenal','Complete crew has no paid duplicate recommendation')
	g.saved.collection.tickets.crew=1;check(C.next_case(g.saved).id=='crew' and 'GRATISTICKET' in C.next_case(g.saved).label,'Complete crew can still use its existing free ticket')
	# Every independently seeded account honors the stated at-most-three guarantee.
	for seed in range(1,41):
		var profile=g.default_save();profile.collection.seed=seed;profile.collection.tickets.crew=60;var streak=0;var previous=0
		for i in range(60):
			var progress=C.case_progress(profile,'crew');var before=profile.collection.heroes.size();var receipt=C.open_case(profile,'crew');check(not receipt.is_empty(),'Real seeded case transaction '+str(seed)+' '+str(i))
			streak=streak+1 if receipt.duplicate else 0
			check(streak<=2 or before==15,'Published crew guarantee bound is honored')
			if progress.guarantee==1:check(not receipt.duplicate or before==15,'Guaranteed next case is actually new')
			check(profile.collection.heroes.size()>=before and profile.collection.parts>=previous,'No lost heroes or duplicate value');previous=profile.collection.parts
			C.acknowledge(profile,receipt.serial)
			if profile.collection.heroes.size()==15:break
		check(profile.collection.heroes.size()==15,'Bounded collection completion for seeded account '+str(seed))
	g.saved=g.default_save();g.saved.settings.master=0;preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	var a=actual_run(0);var b=actual_run(5);var c=actual_run(11);var foreign=actual_run(0,'reactor');var endless=actual_run(0,'scrapyard','endless');var harder=actual_run(0,'scrapyard','campaign','veteran')
	var options=Compare.candidates(g.saved.recent_runs,c)
	check(options.size()==2 and options.any(func(r):return r.character=='bruiser') and options.any(func(r):return r.character=='steelfist'),'Actual three-class runs compare only within identical arena/mode/difficulty')
	check(not Compare.compatible(a,foreign) and not Compare.compatible(a,endless) and not Compare.compatible(a,harder),'Different worlds, endless and higher difficulty never become comparison peers')
	var m=Compare.metrics(a);check(absf(m.seconds-1.1)<.01 and m.received==10 and absf(m.dps-20/1.1)<.01 and m.kills==1,'Comparison derives exact metrics from real gameplay receipts')
	var old=a.duplicate(true);old.erase('analysis');check(Compare.metrics(old).is_empty() and Compare.candidates([old],a).is_empty(),'Old records never acquire invented comparison measurements')
	check(Compare.candidates([null,{},false],a).is_empty() and Compare.candidates([],{}).is_empty(),'Invalid or absent history produces a safe empty state')
	var same=c.duplicate(true);check(Compare.candidates([c,same,a],c).size()==2,'Only one current receipt is excluded; a real identical previous run remains eligible')
	g.saved.recent_runs=[c,b,a,foreign,endless,harder];var history=g.saved.recent_runs.duplicate(true)
	for size in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;await process_frame;g.update_safe_area();g.main_menu();g.statistics();g.test_mode=false
		await tap(control('RUNS VERGLEICHEN'));check(g.recap_view.tab=='compare' and contains('AUSGEWÄHLTER RUN'),'Native statistics opens comparison '+str(size))
		var first=g.recap_view.compare_index;await tap(control('FRÜHEREN RUN WECHSELN'));check(g.recap_view.compare_index==first+1,'Native peer selector cycles actual eligible history')
		await tap(control('WELLEN & BOSSE'));await tap(control('VERGLEICH'));await tap(control('ZURÜCK'));check(control('LETZTE RUNDEN')!=null,'Tabs and back preserve the correct statistics return destination');g.test_mode=true
	check(g.saved.recent_runs==history,'Comparison browsing never rewrites past results')
	g.main_menu();g.recap_view.show(a,g.main_menu);g.recap_view.select('compare');g.saved.recent_runs=[a,foreign];g.recap_view.render();check(contains('ZWEITEN RUN'),'Empty comparison explains exact matching requirements')
	# Third statistics page must expose the four fighters added in 0.26.
	g.main_menu();g.statistics();g.test_mode=false;await tap(control('WEITERE HELDEN'));await tap(control('WEITERE HELDEN'));check(control('VIPER')!=null and control('RIVET')!=null,'Native statistics navigation reaches all fifteen fighters');await tap(control('WEITERE HELDEN'));check(control('ÜBERSICHT')!=null,'Statistics pages wrap back to overview');g.test_mode=true
	g.saved=g.default_save();g.saved.collection.tickets={'crew':0,'arsenal':0,'style':0};g.saved.collection.pity=2;g.saved.meta.coins=10;g.garage.cases()
	check(contains('NEUER FIGHTER IN MAX. 1 CASE') and contains('NOCH'),'Case shop exposes current guarantee and real coin shortfall')
	var before=g.saved.duplicate(true);var progress=C.next_case(g.saved);check(progress.needed==int(C.catalog().cases.crew.price)-10 and 'MAX. 1' in progress.label and g.saved==before,'Result goal matches the actual affordable case and guarantee')
	Save.save_local(g.saved,PATH);var loaded=Save.load_local(PATH);check(C.next_case(loaded)==progress,'Case goals survive actual versioned save/load without a new schema')
	g.saved=original;g.save_game();g.free();DirAccess.remove_absolute(PATH);call_deferred('finish_test')
func finish_test():
	await process_frame;await process_frame;await process_frame
	print('PROGRESS COMPARISON RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)
