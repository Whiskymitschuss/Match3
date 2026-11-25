extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Checkpoint=preload('res://scripts/progression/run_checkpoint.gd')
const Graph=preload('res://scripts/progression/variant_graph.gd')
const Files=preload('res://tests/beta_test_files.gd')
const ROOT='user://beta_test_resume'
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func boot():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=ROOT;root.add_child(g);g.set_physics_process(false);g.run_session.test_enabled=true;g.saved.settings.master=0
func fresh(hero:int=0,arena:String='scrapyard'):
	g.run_session.live=false;g.saved=Save.defaults();g.saved.settings.master=0;g.saved.settings.shop_help_seen=true;preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	g.main_menu();g.selected=hero;g.arena_id=arena;g.selected_difficulty='normal';g.run_mode='campaign';g.start_run(true);g.begin_wave();g.spawn_clock=999
func reload_run() -> bool:
	if not g.save_game():check(false,'Run really saves: '+g.save_error);return false
	g.free();await process_frame;boot()
	check(g.state==g.State.MAIN_MENU and g.run_session.pending(),'New game instance finds the saved run in its own profile')
	return g.run_session.resume_saved()
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT);boot()
	var graph=Graph.new();var enemy={'pos':Vector2(1,2),'hp':40};var input={'enemies':[enemy],'hazard':{'owner':enemy},'int64':-9223372036854775807,'rect':Rect2(1,2,3,4),'color':Color(.1,.2,.3,.4),'typed':Array(['a','b'],TYPE_STRING,&'',null)}
	var packed=graph.pack(input);var decoded=graph.unpack(JSON.parse_string(JSON.stringify(packed)))
	check(not decoded.is_empty() and is_same(decoded.value.enemies[0],decoded.value.hazard.owner),'JSON graph preserves shared enemy identity')
	check(decoded.value.int64==input.int64 and decoded.value.rect==input.rect and decoded.value.color.is_equal_approx(input.color) and decoded.value.typed.is_typed(),'Graph preserves int64, geometry, colour and typed arrays')
	check(graph.pack({'bad':RefCounted.new()}).is_empty(),'Object loading is never allowed')
	check(graph.unpack({'root':['@',0],'nodes':[{'kind':'a','typed':0,'items':[['@',0]]}]}).is_empty(),'Cyclic corrupt graphs rejected before allocation')
	fresh();g.player.position=Vector2(900,800);g.coins=91;g.hp=73;g.run_time=12.5;g.remaining=41.25
	g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2(180,0);e.hp=777
	g.shoot(g.player.position,Vector2.RIGHT,15,false,200,2,'blaster');g.shots[0].hit_enemies.append(e)
	g.united.enemies.circle(e.pos,70,2,.5,10,e);var state=g.rng.state
	check(await reload_run(),'Actual combat resumes from persisted profile')
	check(g.state==g.State.PAUSED and g.hp==73 and g.coins==91 and g.remaining==41.25 and g.run_time==12.5 and g.player.position==Vector2(900,800),'Restored combat is paused at exact player/time/economy values')
	check(g.rng.state==state and g.enemies.size()==1 and g.enemies[0].hp==777 and is_same(g.shots[0].hit_enemies[0],g.enemies[0]) and is_same(g.united.enemies.hazards[0].owner,g.enemies[0]),'RNG, projectiles and hazard owners keep exact shared identity')
	var timer=g.remaining;g._physics_process(10);check(g.remaining==timer,'Loaded run never simulates before explicit continuation')
	g.resume();g.spawn_clock=999;g._physics_process(.01);check(g.remaining<timer,'Explicit resume continues actual simulation')
	g.open_shop();g.coins=1000;var offers=g.offers.duplicate(true);g.rerolls=3
	check(await reload_run(),'Actual shop resumes after restart')
	check(g.state==g.State.SHOP and g.offers==offers and g.rerolls==3 and g.coins==1000,'Shop keeps exact offers, reroll count and wallet')
	g.begin_wave();g.xp=100;g.level_up();var choices=g.level_choices.duplicate(true);var level=g.level;var xp=g.xp
	check(await reload_run(),'Pending level-up resumes after restart')
	check(g.state==g.State.LEVEL_UP and g.level_choices==choices and g.level==level and g.xp==xp,'Level-up is not rerolled, charged twice or skipped')
	g.run_session.live=false
	for hero in range(15):
		fresh(hero);g.hero_ability.activate();g._physics_process(.1);var checkpoint=Checkpoint.capture(g,g.profiles.index.active,'fixture-run-id-'+str(hero))
		check(not Checkpoint.unpack(checkpoint).is_empty(),'All live character ability state serializes '+g.characters[hero].id)
	for arena in g.Arenas.IDS:
		fresh(0,arena);g.wave_number=3;g.begin_wave();g.arena_mechanics.update(.01)
		var checkpoint=Checkpoint.capture(g,g.profiles.index.active,'fixture-arena-'+arena)
		check(not Checkpoint.unpack(checkpoint).is_empty(),'All arena machinery serializes '+arena)
	fresh();g.wave_number=6;g.begin_wave();g.breaker.stage='windup';g.breaker.clock=.6;g.breaker.beats=2
	check(await reload_run(),'Breaker Axel windup resumes')
	check(g.breaker.stage=='windup' and is_equal_approx(g.breaker.clock,.6) and g.breaker.beats==2 and g.breaker.actor().size()>0,'Boss phase, warnings and attack counters survive')
	g.run_waves=5;g.kills=100;g.finish(false);var coins=g.saved.meta.coins;var games=g.saved.games
	check(g.saved.active_run.is_empty() and Save.load_local(g.active_save_path()).active_run.is_empty(),'Finish atomically clears checkpoint with its rewards')
	g.finish(false);check(g.saved.meta.coins==coins and g.saved.games==games,'Repeated finish never duplicates rewards')
	g.free();await process_frame;boot();check(not g.run_session.pending() and g.saved.games==games and g.saved.meta.coins==coins,'Restart after finish cannot replay completed run')

	# Replay the same simulation segment through a real persisted restart.
	fresh(1);g.weapons[0].level=3;g.hp=90;g.spawn_clock=999;g.camera.reset_smoothing();g.camera.force_update_scroll()
	for i in range(5):
		g.spawn_enemy('grunt');g.enemies.back().pos=g.player.position+Vector2(180+i*30,i*20);g.enemies.back().hp=300;g.enemies.back().max_hp=300
	g._physics_process(.01);g.save_game()
	for i in range(80):g._physics_process(.016)
	var expected=Checkpoint.capture(g,g.profiles.index.active,g.run_session.run_id)
	g.free();await process_frame;boot();g.run_session.resume_saved();g.resume()
	for i in range(80):g._physics_process(.016)
	var actual=Checkpoint.capture(g,g.profiles.index.active,g.run_session.run_id)
	check(actual.payload==expected.payload,'Restored run replays the next combat segment with identical state and RNG')
	# Boundary handling and failed writes keep the current in-memory run.
	var original_root=g.profiles.root;g.profiles.root=ROOT+'/unwritable/missing/'
	g.pause_game();var at=g.player.position
	check(not g.run_session.suspend() and g.state==g.State.PAUSED and g.player.position==at and g.run_session.live,'Failed run save blocks suspension without dropping combat state')
	g.profiles.root=original_root;g.save_game();g.main_menu()
	var original_cp=g.saved.active_run.duplicate(true);var bad=original_cp.duplicate(true);bad.payload+=' '
	check(Checkpoint.unpack(bad).is_empty(),'Damaged checkpoint checksum is rejected')
	bad=original_cp.duplicate(true);bad.ruleset=999;check(Checkpoint.unpack(bad).is_empty(),'Unknown ruleset is rejected without attempting combat')
	bad=original_cp.duplicate(true);bad.owner='player_999';g.saved.active_run=bad
	check(not g.run_session.resume_saved() and g.state==g.State.MAIN_MENU,'Checkpoint from another player cannot be resumed')
	g.saved.active_run=original_cp
	var other=g.profiles.create('Andere');check(g.switch_profile(other) and not g.run_session.pending(),'Another player cannot see the first player’s pending run')
	check(g.switch_profile('player_1') and g.run_session.pending(),'Returning to owner restores its independent pending run')
	# Maximum mobile workload remains bounded and produces a valid checkpoint.
	fresh(1)
	for i in range(100):g.spawn_enemy('grunt')
	for i in range(320):
		g.shoot(g.player.position,Vector2.RIGHT,12,false,200,1,'blaster');g.shots.back().hit_enemies.append(g.enemies[i%100])
	var started=Time.get_ticks_usec();var busy=Checkpoint.capture(g,g.profiles.index.active,g.run_session.run_id);var elapsed=Time.get_ticks_usec()-started
	check(not Checkpoint.unpack(busy).is_empty(),'100 enemies and 320 pooled projectiles produce a valid bounded checkpoint')
	print('CHECKPOINT BENCHMARK ',elapsed,' us / ',busy.payload.to_utf8_buffer().size(),' payload bytes (host only, not Android FPS)')

	check(g.run_session.start_worker(),'Periodic autosave starts a background worker')
	var copied=g.run_session.worker_copy_us;g.run_session.wait_for_worker()
	var disk=Save.load_local(g.active_save_path());var frame=Checkpoint.unpack(disk.active_run)
	check(not frame.is_empty() and frame.core.enemies.size()==100 and frame.shots.size()==320 and is_same(frame.shots[0].hit_enemies[0],frame.core.enemies[0]),'Background deep copy preserves actor identity and writes valid full workload')
	print('AUTOSAVE MAIN COPY ',copied,' us (host only, not Android FPS)')
	check(g.run_session.start_worker(),'Second periodic autosave starts')
	g.run_waves=1;g.finish(false);var paid=g.saved.meta.coins;var recorded=g.saved.games
	await process_frame;await process_frame
	check(Save.load_local(g.active_save_path()).active_run.is_empty() and g.saved.meta.coins==paid and g.saved.games==recorded,'Finish waits for worker and commits final rewards after it; stale checkpoint cannot return')
	fresh();g.save_game();var safe_path=g.active_save_path();var safe=Save.load_local(safe_path);var base_root=g.profiles.root;g.profiles.root=ROOT+'/missing/worker/'
	check(g.run_session.start_worker(),'Write-failure fixture starts background worker')
	g.run_session.wait_for_worker();g.profiles.root=base_root
	check(g.save_error!='' and Save.load_local(safe_path)==safe and g.state==g.State.COMBAT,'Failed background write leaves committed file and running simulation intact')
	g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('RUN RESUME RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
