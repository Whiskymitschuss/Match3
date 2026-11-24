extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Backup=preload('res://scripts/progression/profile_backup.gd')
const Files=preload('res://tests/beta_test_files.gd')
const ROOT='user://beta_test_backup'
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT)
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=ROOT;root.add_child(g);g.set_physics_process(false);g.run_session.test_enabled=true;g.saved.settings.master=0
	g.profiles.rename('player_1','René');g.saved.meta.coins=123;g.saved.collection.parts=71;g.saved.settings.quality='LOW';g.saved.settings.shop_help_seen=true
	var text=Backup.encode(g.saved,'René');var decoded=Backup.decode(text)
	check(decoded.error=='' and decoded.name=='René' and decoded.save.meta.coins==123 and decoded.save.collection.parts==71 and decoded.save.settings.quality=='LOW','Portable UTF-8 profile keeps currencies, name and settings')
	check(Backup.decode('not json').error!='','Non-JSON import rejected')
	var broken=JSON.parse_string(text);broken.payload+=' ';check(Backup.decode(JSON.stringify(broken)).error!='','Broken checksum rejected')
	broken=JSON.parse_string(text);broken.version=999;check(Backup.decode(JSON.stringify(broken)).error!='','Unknown backup format version rejected')
	check(Backup.decode('x'.repeat(Backup.MAX_BYTES+1)).error!='','Oversized import rejected')
	var foreign=JSON.stringify({'format':'other-game','version':1});check(Backup.decode(foreign).error!='','Other apps cannot be imported as Mayhem profiles')
	var path=ROOT+'/backup.json';check(Backup.write_file(text,path)==OK and Backup.read_file(path).save.meta.coins==123,'File export really writes a readable portable profile')
	check(Backup.write_file(text,ROOT+'/missing/backup.json')!=OK,'Write error is reported without changing original profile')
	g.start_run(true);g.begin_wave();g.spawn_clock=999;g.hp=61;g.coins=88;g.run_time=31;g.remaining=29;g.pause_game();g.main_menu();g.save_game()
	text=Backup.encode(g.saved,'René');decoded=Backup.decode(text)
	check(decoded.error=='' and not decoded.save.active_run.is_empty(),'Portable backup includes a suspended exact run')
	var before=Save.load_local(g.active_save_path());var count=g.profiles.index.profiles.size();var id=g.profiles.import_new(decoded.name,decoded.save)
	check(id!='' and g.profiles.index.profiles.size()==count+1 and g.profiles.active_name()=='René','Import creates additional profile without changing current selection')
	var imported=Save.load_local(g.profiles.path_for(id));check(imported.meta.coins==123 and imported.active_run.owner==id and imported.active_run.run_id==before.active_run.run_id,'Imported checkpoint is rebound to its new local player')
	check(Save.load_local(g.profiles.path_for('player_1'))==before,'Import never overwrites or merges original player')
	check(g.switch_profile(id) and g.run_session.resume_saved() and g.state==g.State.PAUSED and g.hp==61 and g.coins==88 and g.remaining==29,'Imported run really resumes with exact combat state')
	g.main_menu();var name=g.profiles.active_name();check(name=='René (2)','Duplicate import name gets an independent unambiguous suffix')
	g.profile_transfer.pending=Backup.decode(text);check(g.profile_transfer.confirm_import(),'Real confirmation imports and activates a new local player')
	check(g.profiles.active_name()=='René (3)' and g.saved.meta.coins==123 and g.run_session.pending(),'Real transfer flow retains pending run and permanent progress')
	g.profile_transfer.preview_file(path);check(g.profile_transfer.pending.error=='' and g.profiles.active_name()=='René (3)','Selecting a file only previews it until confirmation')
	g.profile_transfer.pending={};var original=g.saved.duplicate(true);g.profile_transfer.preview_file(ROOT+'/missing.json');check(g.saved==original and g.profile_transfer.pending.is_empty(),'Unreadable file cannot mutate any player')
	g.profiles.create('Vier');g.profiles.create('Fünf');count=g.profiles.index.profiles.size();check(g.profiles.import_new('Sechs',decoded.save)=='' and g.profiles.index.profiles.size()==count,'Full profile capacity refuses import without overwriting a slot')
	g.start_run(true);g.begin_wave();g.pause_game();g.profile_transfer.pending=decoded
	check(not g.profile_transfer.confirm_import(),'Import is blocked during an active paused run')
	g.run_session.live=false;g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('PROFILE BACKUP RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
