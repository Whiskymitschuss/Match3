extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
const Backup=preload('res://scripts/progression/profile_backup.gd')
const ROOT='user://beta_test_resume_ui'
var g
var passed=0
var failed=0
var native=false
var capture=false
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func button(label:String):
	for n in g.ui_root.find_children('*','Button',true,false):
		if n is Button and n.text==label:return n
	return null
func tap(label:String):
	await process_frame;await process_frame
	var b=button(label);check(b!=null and not b.disabled,'Actual usable control '+label)
	if b==null:return
	var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
	if native:
		at=root.get_final_transform()*at
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=14;e.position=at;e.pressed=down;Input.parse_input_event(e);await process_frame
	else:
		var motion=InputEventMouseMotion.new();motion.position=at;root.push_input(motion,true);await process_frame
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=at;e.global_position=at;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true);await process_frame
	await process_frame;await process_frame
func frame(name:String):
	if not capture:return
	for i in range(5):await process_frame
	await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png('res://tests/resume_'+name+'.png');print('RESUME UI FRAME ',name)
func boot():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=ROOT;root.add_child(g);g.set_physics_process(false);g.run_session.test_enabled=true;g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.saved.settings.shop_help_seen=true
func run():
	native=OS.get_cmdline_user_args().has('--native-touch');capture=OS.get_cmdline_user_args().has('--capture')
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT);boot();root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area()
	g.start_run(true);g.begin_wave();g.spawn_clock=999;g.coins=49;g.hp=83;g.run_time=15;g.remaining=45
	g.pause_game();g.test_mode=false;await frame('pause_1600');await tap('SICHERN & HAUPTMENÜ')
	check(g.state==g.State.MAIN_MENU and g.run_session.pending() and button('FORTSETZEN')!=null,'Pause saves and returns to a real Continue menu');await frame('home_1600')
	await tap('FORTSETZEN');check(g.state==g.State.PAUSED and g.coins==49 and g.hp==83 and g.remaining==45,'Native Continue restores exact run into pause')
	await tap('FORTSETZEN');check(g.state==g.State.COMBAT,'Second explicit Continue starts combat')
	g.open_shop();g.coins=400;g.rerolls=2;g.save_game();var offers=g.offers.duplicate(true);g.main_menu();g.test_mode=true;g.free();await process_frame;boot();g.test_mode=false
	await tap('FORTSETZEN');check(g.state==g.State.SHOP and g.offers==offers and g.rerolls==2,'Native resumed shop keeps offers and rerolls');await frame('shop_1600')
	g.handle_back();await process_frame;await tap('SICHERN & HAUPTMENÜ');check(g.state==g.State.MAIN_MENU,'Frozen shop can save and leave without surrendering')
	g.run_session.resume_saved();g.next_shop_wave();g.begin_wave();g.xp=60;g.level_up();var choices=g.level_choices.duplicate(true);var xp=g.xp;g.save_game();g.main_menu();g.run_session.resume_saved()
	check(g.state==g.State.LEVEL_UP and g.level_choices==choices and g.xp==xp,'Level choices survive native restore');await frame('level_1600')
	g.main_menu();g.settings_view.show(g.main_menu,'profile');await frame('settings_1600');await tap('EXPORT / IMPORT')
	check(button('SICHERUNG EXPORTIEREN')!=null and button('DATEI IMPORTIEREN')!=null,'Actual settings open both portable-backup actions');await frame('backup_1600')
	var path=ROOT+'/portable.json';check(Backup.write_file(Backup.encode(g.saved,'Testspieler'),path)==OK,'Real portable backup prepared for native confirmation')
	g.profile_transfer.preview_file(path);await frame('preview_1600');var count=g.profiles.index.profiles.size();await tap('ABBRECHEN')
	check(g.profiles.index.profiles.size()==count,'Cancel does not import or alter profile list')
	g.profile_transfer.preview_file(path);await tap('ALS NEUES PROFIL IMPORTIEREN')
	check(g.profiles.index.profiles.size()==count+1 and g.profiles.active_name()=='Testspieler' and g.run_session.pending(),'Actual native import creates and activates an independent resumable profile')
	await tap('ZURÜCK');check(button('SPIELERPROFILE')!=null,'Transfer returns to profile settings safely');await tap('ZURÜCK')
	check(g.state==g.State.MAIN_MENU and button('FORTSETZEN')!=null,'Imported player returns to real Continue menu')
	for size in [Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;await process_frame;g.update_safe_area();g.settings_view.show(g.main_menu,'profile');await frame('settings_'+str(size.x))
		await tap('EXPORT / IMPORT');check(button('SICHERUNG EXPORTIEREN').size.y>=90 and button('DATEI IMPORTIEREN').position.x+button('DATEI IMPORTIEREN').size.x<=1820,'Touch-safe backup layout '+str(size))
		g.profile_transfer.preview_file(path);await frame('preview_'+str(size.x));await tap('ABBRECHEN');await tap('ZURÜCK');await tap('ZURÜCK')
	g.run_session.live=false;g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('RESUME BACKUP UI RESULT ',passed,' passed, ',failed,' failed; native_touch=',native);quit(1 if failed else 0)
