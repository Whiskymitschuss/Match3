extends SceneTree
const Save = preload('res://scripts/autoload/save_manager.gd')
const Records = preload('res://scripts/progression/run_records.gd')
var passed=0
var failed=0
func check(ok: bool, label: String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func _initialize():call_deferred('run')
func run():
	var path='user://records_migration_test.json'
	for target in [path,path+'.tmp',Save.sidecar(path,'v1.backup'),Save.sidecar(path,'corrupt')]:
		if FileAccess.file_exists(target):DirAccess.remove_absolute(target)
	var legacy={'version':1,'unlocked':['bruiser','sparky','shade'],'highest_wave':9,'games':15,'wins':4,'kills':3120,'time':8400.0,'settings':{'master':.55,'music':.25,'sfx':.7,'quality':'MEDIUM'}}
	check(Save.save_local(legacy,path)==OK,'Write real schema-1 fixture')
	var saved=Save.load_local(path)
	check(saved.version==3 and saved.games==15 and saved.wins==4,'Migrate schema-1 totals into schema 3')
	check(saved.kills==3120 and saved.highest_wave==9 and saved.time==8400,'Migration preserves kills, wave and time')
	check(is_equal_approx(saved.settings.master,.55) and saved.settings.quality=='MEDIUM','Migration preserves settings')
	check(FileAccess.file_exists(Save.sidecar(path,'v1.backup')),'Migration creates original schema-1 backup')
	var backup=JSON.parse_string(FileAccess.get_file_as_string(Save.sidecar(path,'v1.backup')))
	check(backup.version==1 and backup.games==15,'Backup preserves original file contents')
	check(saved.records.bruiser.games==0 and saved.records.sparky.games==0 and saved.recent_runs.is_empty(),'No invented attribution of legacy runs to heroes')
	var run={'character':'sparky','won':false,'wave':4,'time':230.5,'kills':90,'level':9,'damage':5250.0,'coins':110,'weapons':[{'id':'blaster','level':3,'clock':.2}]}
	var improvements=Records.add_run(saved,run)
	check(saved.records.sparky.games==1 and saved.records.bruiser.games==0,'Record updates only selected character')
	check(saved.records.sparky.kills==90 and saved.records.sparky.coins==110,'Character totals recorded')
	check(saved.records.sparky.best_wave==4 and saved.records.sparky.best_level==9 and saved.records.sparky.best_damage==5250,'Personal bests recorded')
	check(improvements.has('best_wave') and improvements.has('best_kills'),'Result can announce a genuine new best')
	check(saved.games==15 and saved.kills==3120,'Record helper does not duplicate global counters')
	check(saved.recent_runs[0].weapons[0].size()==2 and not saved.recent_runs[0].weapons[0].has('clock'),'History excludes active weapon simulation state')
	run.kills=2
	run.level=2
	run.damage=20
	run.wave=2
	Records.add_run(saved,run)
	check(saved.records.sparky.best_kills==90 and saved.records.sparky.best_level==9,'Worse later run does not overwrite bests')
	run.won=true
	run.wave=10
	run.time=610
	Records.add_run(saved,run)
	check(saved.records.sparky.fastest_victory==610 and saved.records.sparky.wins==1,'First victory records its actual duration')
	run.time=580
	Records.add_run(saved,run)
	check(saved.records.sparky.fastest_victory==580,'Faster victory improves time')
	run.time=620
	Records.add_run(saved,run)
	check(saved.records.sparky.fastest_victory==580 and saved.records.sparky.longest_run==620,'Slower victory preserves fastest and updates longest')
	for i in range(30):
		run.kills=i
		Records.add_run(saved,run)
	check(saved.recent_runs.size()==20 and saved.recent_runs[0].kills==29,'History is bounded and newest first')
	check(Save.save_local(saved,path)==OK,'Write schema-2 record file')
	var loaded=Save.load_local(path)
	check(loaded.records.sparky.best_kills==90 and loaded.recent_runs.size()==20,'Schema-2 personal records survive disk roundtrip')
	check(loaded.games==15 and loaded.settings.quality=='MEDIUM','Roundtrip preserves legacy global data')
	loaded.records={'sparky':{'games':3,'wins':99,'best_wave':99,'best_level':'bad','time':-20}}
	loaded.recent_runs=[{'character':'unknown','won':true},'invalid',{'character':'shade','level':-4,'weapons':[{'id':'bad','level':100}]}]
	Save.save_local(loaded,path)
	loaded=Save.load_local(path)
	check(loaded.records.sparky.wins==3 and loaded.records.sparky.best_wave==10 and loaded.records.sparky.best_level==0,'Corrupt nested record fields are clamped/defaulted')
	check(loaded.recent_runs.size()==1 and loaded.recent_runs[0].character=='shade' and loaded.recent_runs[0].weapons.is_empty(),'Malformed history entries cannot break stats UI')
	check(loaded.games==15,'Partial record corruption does not erase valid global totals')
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=Save.defaults()
	g.selected=2
	g.start_run()
	g.begin_wave()
	g.run_time=300
	g.kills=75
	g.level=12
	g.wave_number=6
	g.finish(false)
	check(g.saved.records.shade.games==1 and g.saved.recent_runs.size()==1,'Actual game result connects to per-character records')
	g.finish(false)
	check(g.saved.games==1 and g.saved.records.shade.games==1 and g.saved.recent_runs.size()==1,'Repeated finish cannot duplicate records or history')
	g.main_menu()
	g.statistics(2)
	check(g.state==g.State.MAIN_MENU,'Stats view preserves menu state')
	g.recent_runs_screen(2,99)
	check(g.state==g.State.MAIN_MENU,'Filtered history safely clamps page index')
	g.queue_free()
	await process_frame
	for target in [path,path+'.tmp',Save.sidecar(path,'v1.backup'),Save.sidecar(path,'corrupt')]:
		if FileAccess.file_exists(target):DirAccess.remove_absolute(target)
	print('RUN RECORDS RESULT ',passed,' passed, ',failed,' failed')
	quit(0 if failed==0 else 1)
