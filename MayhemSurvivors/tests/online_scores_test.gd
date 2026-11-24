extends SceneTree
const S=preload('res://scripts/progression/online_scores.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const Backup=preload('res://scripts/progression/profile_backup.gd')
const Files=preload('res://tests/beta_test_files.gd')
const ROOT='user://beta_test_online'
var g
var passed=0
var failed=0
class FakeBridge extends RefCounted:
	var calls=[]
	func authenticate(interactive:bool,token:String):calls.append(['auth',interactive,token])
	func submit_score(board:String,score:int,run:String,player:String,token:String):calls.append(['score',board,score,run,player,token])
	func show_board(board:String,player:String,token:String):calls.append(['show',board,player,token])
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func reply(kind:String,extra:Dictionary={}):
	var payload=extra.duplicate(true);payload.token=g.play_games.request;g.play_games.receive(kind,JSON.stringify(payload))
func id(n:int) -> String:return '%032x' % n
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT)
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=ROOT;root.add_child(g);g.set_physics_process(false);g.run_session.test_enabled=true;g.saved.settings.master=0
	check(not g.play_games.ready() and not g.saved.online_scores.enabled,'Fresh offline game does not initialize or publish to Google')
	g.play_games.connect_player();check(g.play_games.request=='','An unconfigured service cannot attempt a fake connection')
	var driver=FakeBridge.new();g.play_games.test_plugin=driver
	# Explicit fake transport only; these are not deployed Google project IDs.
	var campaign='campaign:scrapyard:normal';var endless='endless:scrapyard:normal'
	g.play_games.config={'provider':'google_play','project_id':'1234567890','boards':{campaign:'CgkITestCampaign',endless:'CgkITestEndless'}}
	check(g.play_games.ready() and driver.calls.is_empty(),'Configured adapter still waits for explicit user action')
	g.play_games.connect_player();check(driver.calls.size()==1 and driver.calls[0][0]=='auth' and not g.saved.online_scores.enabled,'Connect really calls the adapter but does not pre-grant consent')
	g.play_games.receive('authenticated',JSON.stringify({'token':'stale','player':'google_a','name':'Player'}))
	check(not g.saved.online_scores.enabled,'Stale authentication callback cannot enable any profile')
	reply('authenticated',{'player':'google_a','name':'Play Name'})
	check(g.saved.online_scores.enabled and g.saved.online_scores.player_id=='google_a' and g.profiles.active_name()=='Spieler 1','Authentication binds only the active local profile and preserves its name')
	check(Save.load_local(g.active_save_path()).online_scores.player_id=='google_a','Explicit account binding is actually saved')
	g.start_run(true);g.begin_wave();g.run_time=341.123;g.run_waves=10;var run_id=g.run_session.run_id
	check(g.saved.online_scores.ticket.run==run_id,'New eligible run receives its own board/account ticket')
	g.finish(true)
	check(g.saved.online_scores.outbox.size()==1 and g.saved.online_scores.outbox[0].score==341123,'Actual victory queues millisecond score in its arena/difficulty category')
	g.play_games.tick();check(driver.calls.back()[0]=='score' and driver.calls.back()[1]=='CgkITestCampaign' and driver.calls.back()[2]==341123 and driver.calls.back()[4]=='google_a','Queued result really calls the score adapter with the configured board ID')
	reply('score_saved')
	check(g.saved.online_scores.outbox.is_empty() and g.saved.online_scores.sent.has(run_id),'Acknowledged result is removed and deduplicated')
	S.begin(g.saved,run_id,'campaign','scrapyard','normal','bruiser',g.play_games.boards())
	check(not S.finish(g.saved,run_id,'campaign','scrapyard','normal','bruiser',true,341,10),'Same finished run cannot be queued twice')
	g.main_menu();g.start_run(true);g.begin_wave();g.run_time=350;g.finish(false)
	check(g.saved.online_scores.outbox.is_empty(),'Campaign defeat never submits a victory time')
	S.begin(g.saved,id(3),'endless','scrapyard','normal','bruiser',g.play_games.boards())
	check(S.finish(g.saved,id(3),'endless','scrapyard','normal','bruiser',false,700,13) and g.saved.online_scores.outbox[0].score==13,'Endless submits completed waves independently of campaign timing')
	g.play_games.tick();var pending=g.saved.online_scores.outbox.duplicate(true);reply('unavailable')
	check(g.saved.online_scores.outbox==pending and g.play_games.connected=='','Network failure retains the result and permits fully offline play')
	g.main_menu();g.play_games.connect_player();reply('authenticated',{'player':'google_b','name':'Other'})
	check(g.saved.online_scores.player_id=='google_a' and g.play_games.connected=='','Different Google account cannot receive another account’s pending scores')
	g.play_games.connect_player();reply('authenticated',{'player':'google_a','name':'Play Name'})
	g.play_games.tick()
	var old_root=g.profiles.root;var blocked=ROOT+'/blocked';var file=FileAccess.open(blocked,FileAccess.WRITE);file.store_string('fixture');file.close();g.profiles.root=blocked+'/'
	reply('score_saved')
	check(g.saved.online_scores.outbox==pending and g.save_error!='','Failed acknowledgement save retains the outbox for safe best-score retry')
	g.profiles.root=old_root;g.play_games.tick();g.play_games.deadline=Time.get_ticks_msec()-1;g.play_games.tick()
	check(g.play_games.request=='' and g.saved.online_scores.outbox==pending,'Timeout clears the request without losing queued results')
	g.play_games.connect_player();var token=g.play_games.request;var other=g.profiles.create('Zweiter');g.switch_profile(other)
	g.play_games.receive('authenticated',JSON.stringify({'token':token,'player':'google_a','name':'Play Name'}))
	check(not g.saved.online_scores.enabled and g.saved.online_scores.player_id=='','Profile switch invalidates callbacks from the former player')
	g.switch_profile('player_1');check(g.saved.online_scores.outbox==pending,'Switching back retains only the original player’s outbox')
	g.play_games.connect_player();reply('authenticated',{'player':'google_a','name':'Play Name'})
	g.play_games.show_board(campaign);check(driver.calls.back()[0]=='show' and driver.calls.back()[1]=='CgkITestCampaign','Leaderboard button really requests the native leaderboard')
	reply('dialog_opened');g.play_games.cancel()
	g.start_run(true);g.begin_wave();g.pause_game();g.main_menu();var cp=g.saved.active_run.duplicate(true)
	var decoded=Backup.decode(Backup.encode(g.saved,'Testspieler'))
	check(decoded.error=='' and decoded.save.active_run.payload==cp.payload and decoded.save.active_run.run_id==cp.run_id and decoded.save.active_run.sha256==cp.sha256 and decoded.save.online_scores==S.defaults(),'Portable export keeps the run but removes online binding, tickets and submission queue')
	var imported=g.profiles.import_new('Import',g.saved)
	check(Save.load_local(g.profiles.path_for(imported)).online_scores==S.defaults(),'Direct profile import also cannot clone online consent or ranked eligibility')
	var ticket=g.saved.online_scores.ticket.duplicate(true);g.tutorial.start();g.tutorial.stop(false)
	check(g.saved.online_scores.ticket==ticket and g.saved.active_run==cp,'Tutorial preserves the suspended ranked run and eligibility ticket')
	var before=g.saved.duplicate(true);check(g.practice.start(0,'scrapyard',2,1),'Practice can start while a ranked run is suspended')
	g.begin_wave();g.finish(true);g.practice.leave()
	check(g.saved==before and g.saved.active_run==cp,'Practice cannot consume the suspended ranked ticket or submit a score')
	var fake=g.saved.duplicate(true);fake.online_scores.enabled=true;fake.online_scores.player_id='google_a'
	S.begin(fake,id(4),'campaign','scrapyard','normal','bruiser',g.play_games.boards())
	check(not S.finish(fake,id(4),'campaign','reactor','normal','bruiser',true,340,10),'Arena mismatch rejects ticket instead of posting to another board')
	check(not S.valid_key('campaign:missing:normal') and not S.value_ok(-1,campaign) and not S.value_ok(INF,campaign) and not S.value_ok(1.25,endless),'Invalid categories and non-finite/fractional scores are rejected')
	var malformed=S.clean({'enabled':true,'player_id':'google_a','outbox':[{'run':id(5),'board':campaign,'score':300000,'player':'other'},{'run':id(6),'board':campaign,'score':-2,'player':'google_a'}]})
	check(malformed.outbox.is_empty(),'Save sanitization removes foreign-account and invalid queued scores')
	for n in range(100,130):
		S.begin(fake,id(n),'endless','scrapyard','normal','bruiser',g.play_games.boards());S.finish(fake,id(n),'endless','scrapyard','normal','bruiser',false,700,12)
	check(fake.online_scores.outbox.size()==20,'Offline submission queue has a fixed upper bound')
	g.play_games.disable_profile()
	check(g.saved.online_scores==S.defaults() and Save.load_local(g.active_save_path()).online_scores==S.defaults(),'Switching off publishes nothing further and removes local online binding')
	g.run_session.live=false;g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('ONLINE SCORES RESULT ',passed,' passed, ',failed,' failed; adapter=FAKE (no real Google authentication)');quit(1 if failed else 0)
