extends SceneTree
# Production boot and earned progression, isolated from developer/test saves.
const Save=preload('res://scripts/autoload/save_manager.gd')
const Files=preload('res://tests/beta_test_files.gd')
const ROOT='user://beta_test_new_player'
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func boot():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=ROOT;root.add_child(g);g.set_physics_process(false);g.saved.settings.master=0
func pristine(s:Dictionary) -> bool:
	return s.meta.coins==0 and s.meta.earned==0 and s.collection.parts==0 and s.collection.tickets=={'crew':0,'arsenal':0,'style':0} and s.collection.heroes==['bruiser'] and s.collection.levels=={'hammer':1} and s.collection.opened==0 and s.collection.history.is_empty() and s.collection.pending.is_empty() and s.meta.owned.is_empty() and s.world_progress.unlocked==['scrapyard'] and s.world_progress.cleared.is_empty() and s.world_progress.claimed.is_empty() and s.games==0 and s.wins==0 and s.kills==0 and s.highest_wave==0 and s.time==0 and s.recent_runs.is_empty() and s.meta.pass.xp==0 and s.meta.pass.claimed.is_empty()
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT);boot()
	check(pristine(g.saved),'Actual first boot starts with zero earned progress and no free cases')
	check(g.selected==0 and g.arena_id=='scrapyard' and g.selected_difficulty=='normal' and g.run_mode=='campaign','Production first boot selects Bruiser and world one')
	check(not g.saved.settings.onboarding_seen and not g.saved.settings.tutorial_complete,'First player receives tutorial introduction')
	for id in g.Collection.HEROES:check(g.Unlocks.available(g.saved,id)==(id=='bruiser'),'Production fighter lock '+id)
	g.garage.cases()
	for id in ['crew','arsenal','style']:
		var before=g.saved.duplicate(true)
		check(not g.garage.open_case(id) and g.saved==before,'No unearned case transaction '+id)
		check(not g.Collection.case_progress(g.saved,id).ready,'No false free-case prompt '+id)
	g.main_menu();g.play()
	check(g.ui_root.get_children().any(func(n):return n is Button and n.text=='MIT KICKSY ÜBEN'),'First Play opens real Kicksy onboarding')
	g.tutorial.start();g.tutorial.stop(true)
	check(pristine(g.saved) and g.saved.settings.tutorial_complete,'Tutorial completion does not grant heroes, tickets, currency or run statistics')
	check(g.save_game(),'First player persists successfully')
	g.free();await process_frame;boot()
	check(pristine(g.saved) and g.saved.settings.tutorial_complete,'Restart preserves a genuinely zero-progress trained player')
	var other=g.profiles.create('Neustart')
	check(other!='' and g.switch_profile(other) and pristine(g.saved) and not g.saved.settings.tutorial_complete,'Every additional local player also starts from zero')
	g.start_run();g.begin_wave();g.spawn_clock=999
	check(g.weapons.size()==1 and g.weapons[0].id=='hammer' and g.coins==0,'First real run has only base hammer and no carried run coins')
	g.run_waves=3;g.kills=150;g.finish(false)
	check(g.saved.games==1 and g.saved.meta.coins==18 and g.saved.collection.tickets.crew==0,'Only actual completed run earns its calculated studio coins')
	g.main_menu();g.start_run();g.wave_number=10;g.begin_wave();g.crit=0;g.damage_enemy(g.enemies[0],1000000000)
	check(g.state==g.State.VICTORY and g.saved.world_progress.cleared==['scrapyard'] and g.saved.world_progress.unlocked==['scrapyard','reactor'],'First map boss unlocks exactly the next world through real gameplay')
	g.main_menu();check(g.world_map.claim('scrapyard') and g.saved.collection.tickets.crew==1,'First-clear reward earns the first actual crew ticket')
	check(g.garage.transact('open','crew') and g.saved.collection.tickets.crew==0 and g.saved.collection.heroes.size()==2,'Earned ticket unlocks a real second fighter')
	var id=g.saved.collection.pending.id;g.garage.transact('ack','',g.saved.collection.pending.serial);g.main_menu();g.save_game()
	var restored=Save.load_local(g.active_save_path())
	check(restored.collection.heroes.has(id) and restored.world_progress.claimed==['scrapyard'],'Earned fighter and world reward survive reload')
	check(g.switch_profile('player_1') and pristine(g.saved),'Earned progress never leaks into another local player')
	# Existing players keep what they earned or received before this update.
	g.saved.meta.coins=137;g.saved.collection.tickets={'crew':2,'arsenal':3,'style':4};g.save_game();g.free();await process_frame;boot()
	check(g.saved.meta.coins==137 and g.saved.collection.tickets=={'crew':2,'arsenal':3,'style':4},'App update preserves existing wallet and tickets without resetting real players')
	g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('NEW PLAYER RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
