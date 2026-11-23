extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const ROOT='user://beta_test_game'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,value:String):
	if ok:passed+=1;print('PASS ',value)
	else:failed+=1;push_error('FAIL '+value)
func boot():
	g=load('res://scenes/boot/main.tscn').instantiate();g.profile_root=ROOT;g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved.settings.master=0;g.saved.settings.reduced_motion=true
func control(name:String):
	for node in g.ui_root.find_children('*','Button',true,false):
		if node is Button and node.text==name:return node
	return null
func profile_button():return g.ui_root.get_node_or_null('ProfileAccess')
func contains(value:String) -> bool:return g.ui_root.get_children().any(func(n):return n is Label and value in n.text)
func tap(b:Button):
	if b==null:check(false,'Expected actual beta control');return
	await process_frame;await process_frame
	var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
	if native_touch:
		at=root.get_final_transform()*at
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=8;e.position=at;e.pressed=down;Input.parse_input_event(e);await process_frame
	else:
		var motion=InputEventMouseMotion.new();motion.position=at;root.push_input(motion,true);await process_frame
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=at;e.global_position=at;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true);await process_frame
	await process_frame;await process_frame
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch');Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT)
	var old=Save.defaults();old.meta.coins=321;old.games=7;old.settings.master=0;Save.save_local(old,ROOT+'/save.json');boot()
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	check(g.saved.games==7 and g.saved.meta.coins==321 and profile_button()!=null,'Boot preserves legacy player and exposes named profile access')
	var alpha=g.profiles.create('Nina');var beta=g.profiles.create('Tom');check(g.switch_profile(alpha) and g.saved.games==0 and g.saved.collection.heroes==['bruiser'],'Production switch loads a genuinely new player')
	g.saved.meta.coins=500;g.saved.settings.master=0;g.saved.settings.quality='LOW';g.saved.collection.heroes.append('sparky');g.saved.collection.levels.blaster=1;g.selected=1;g.saved.world_progress.unlocked.append('reactor');g.arena_id='reactor';g.selected_difficulty='veteran'
	check(g.save_game() and g.switch_profile(beta),'Save then switch between two local players')
	check(g.saved.meta.coins==0 and g.saved.settings.quality=='HIGH' and g.selected==0 and g.arena_id=='scrapyard','Wallet, graphics and character/arena choices are isolated')
	check(g.switch_profile(alpha) and g.saved.meta.coins==500 and g.saved.settings.quality=='LOW' and g.selected==1 and g.arena_id=='reactor' and g.selected_difficulty=='veteran','All individual choices restore together')
	# Every transaction path uses the active profile, including persisted pending receipts.
	g.garage.save_path='';check(g.garage.transact('open','crew'),'Actual crew transaction persists in active player file')
	var active=Save.load_local(g.active_save_path());var untouched=Save.load_local(g.profiles.path_for(beta))
	check(not active.collection.pending.is_empty() and untouched.collection.pending.is_empty() and untouched.collection.heroes==['bruiser'],'Case pending state and fighter unlock cannot leak between players')
	g.garage.reveal();g.handle_back();await process_frame;await process_frame;check(g.saved.collection.pending.is_empty(),'Android back acknowledges a revealed case once and returns safely')
	g.main_menu();g.saved.meta.daily.kills=100000;g.reward_hub.tab='daily';var task=g.reward_hub.data.daily[0];var wallet=g.saved.meta.coins;g.reward_hub.action('claim',task.id)
	check(Save.load_local(g.active_save_path()).meta.coins==wallet+task.coins and Save.load_local(g.profiles.path_for(beta)).meta.coins==0,'Daily task payment persists only for its owner')
	g.main_menu();g.saved.world_progress.cleared=['scrapyard'];check(g.world_map.claim('scrapyard'),'World reward uses active profile persistence')
	check(Save.load_local(g.active_save_path()).world_progress.claimed==['scrapyard'] and Save.load_local(g.profiles.path_for(beta)).world_progress.claimed.is_empty(),'World first-clear claims remain independent')
	g.main_menu();g.arena_id='scrapyard';g.selected_difficulty='normal';g.start_run();g.begin_wave();g.spawn_clock=999;g.remaining=0;g._physics_process(.01)
	var offers=g.offers.duplicate(true);g.handle_back();check(g.ui_root.has_node('LeaveRunOverlay') and g.state==g.State.SHOP,'Back in frozen run opens a confirmation above the unchanged shop');g.handle_back();await process_frame;await process_frame
	check(g.offers==offers and g.state==g.State.SHOP,'Cancelling run exit preserves offers and the frozen simulation');g.finish(false)
	check(Save.load_local(g.active_save_path()).games==1 and Save.load_local(g.profiles.path_for(beta)).games==0 and Save.load_local(g.profiles.path_for('player_1')).games==7,'Real run result and history go to exactly one player')
	g.main_menu();var total=g.saved.meta.coins;g.save_game();g.free();await process_frame;boot()
	check(g.profiles.index.active==alpha and g.saved.meta.coins==total and g.saved.games==1,'Fresh game instance restores the selected player after restart')
	var original_root=g.profiles.root;g.profiles.root=ROOT+'/missing/';var id=g.profiles.index.active
	check(not g.switch_profile(beta) and g.profiles.index.active==id and g.saved.meta.coins==total,'Failed current-save write blocks switching without losing in-memory progress');g.profiles.root=original_root;g.save_game()
	# Native management, naming, system-back and paused read-only settings.
	for size in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;await process_frame;g.update_safe_area();g.main_menu();g.test_mode=false
		await tap(profile_button());check(control('NAME ÄNDERN')!=null,'Native profile header opens usable management '+str(size));await tap(control('NAME ÄNDERN'));var edit=g.ui_root.get_node('ProfileName');edit.text='Nina Beta';await tap(control('SPEICHERN'))
		check(g.profiles.active_name()=='Nina Beta','Native name field persists through actual save action');g.handle_back();await process_frame;await process_frame;check(profile_button()!=null,'Android back returns from profiles to main menu');g.test_mode=true
	g.main_menu();g.test_mode=false;await tap(profile_button());await tap(control('Tom'));await tap(control('PROFIL AKTIVIEREN'));check(g.profiles.index.active==beta and g.saved.games==0,'Native profile activation swaps the actual game data');g.test_mode=true;g.saved.settings.master=0
	g.main_menu();g.start_run();g.begin_wave();g.spawn_clock=999;var at=g.player.position;var timer=g.remaining;g._notification(MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT)
	check(g.state==g.State.PAUSED,'Android interruption pauses gameplay');g._physics_process(5);check(g.player.position==at and g.remaining==timer,'No hidden simulation or incoming time while interrupted')
	check(not g.switch_profile(alpha),'Player switching is blocked during an active run');g.settings_view.show(g.pause_menu,'profile');check(control('SPIELERPROFILE').disabled and control('SICHERUNG LADEN').disabled,'Paused settings expose profile data without allowing mutation')
	g.handle_back();await process_frame;await process_frame;check(control('FORTSETZEN')!=null,'System back leaves paused settings safely');g.handle_back();await process_frame;await process_frame;await process_frame;check(g.state==g.State.COMBAT,'System back resumes through the existing pause route')
	g.hurt_clock=0;g.hurt(100000);g.main_menu();g.beta_view.show(g.main_menu);check(g.beta_view.report().contains('Profil-ID') and not g.beta_view.report().contains('Nina Beta'),'Feedback report contains useful local diagnostics without player names')
	g.test_mode=false;await tap(control('TESTANLEITUNG'));check(g.beta_view.guide,'Native beta help explains installation, restart and run limitations');await tap(control('ZURÜCK'));g.test_mode=true
	g.main_menu();g.saved.meta.coins=88;g.save_game();g.saved.meta.coins=99;g.save_game();g.settings_view.show(g.main_menu,'profile');g.test_mode=false;await tap(control('SICHERUNG LADEN'))
	check(contains('Neuere Fortschritte') or contains('Du lädst den letzten'),'Manual recovery requires a clear confirmation');await tap(control('SICHERUNG LADEN'));check(g.saved.meta.coins==88 and g.profiles.index.active==beta,'Native recovery restores only the confirmed active player');g.test_mode=true
	g.main_menu();await tap(profile_button());var count=g.profiles.index.profiles.size();await tap(control('NEUES PROFIL'));g.ui_root.get_node('ProfileName').text='Mila';await tap(control('ANLEGEN'))
	check(g.profiles.index.profiles.size()==count+1 and g.profiles.active_name()=='Mila' and g.saved.meta.coins==0 and g.saved.collection.heroes==['bruiser'],'Native creation saves and activates one fresh independent player')
	g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.update_music()
	g.main_menu();g.handle_back();check(contains('Bis zur nächsten Runde!') and control('APP BEENDEN')!=null,'Main-menu Android back requires explicit exit confirmation');g.handle_back();await process_frame;await process_frame
	check(profile_button()!=null,'Exit confirmation can be cancelled without closing the app')
	for frozen in [g.State.WAVE_PREPARATION,g.State.LEVEL_UP,g.State.SHOP]:
		g.main_menu();g.start_run()
		if frozen!=g.State.WAVE_PREPARATION:
			g.begin_wave()
			if frozen==g.State.LEVEL_UP:g.xp=20;g.level_up()
			else:g.open_shop()
		var games=g.saved.games;g.test_mode=false;g.confirm_frozen_run_exit();await tap(control('RUN BEENDEN'))
		check(g.state==g.State.MAIN_MENU and g.saved.games==games+1 and Save.load_local(g.active_save_path()).games==games+1,'Native frozen-run exit records one defeat and returns safely '+str(frozen));g.test_mode=true
	g.free();call_deferred('finish_test')
func finish_test():
	await process_frame;await process_frame;await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('BETA PROFILES RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)
