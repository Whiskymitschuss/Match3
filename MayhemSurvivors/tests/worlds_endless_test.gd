extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,text:String):
	if ok:passed+=1;print('PASS ',text)
	else:failed+=1;push_error('FAIL '+text)
func setup(arena:String,mode:String='campaign',wave:int=1):
	g.test_mode=true;g.run_mode=mode;g.selected=1;g.arena_id=arena;g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	check(g.Arenas.IDS.size()==10,'Four complete arena definitions')
	for arena in g.Arenas.IDS:
		check(g.saved.arena_records.has(arena) and g.saved.endless_records.has(arena),'Both statistics modes include '+arena)
		check(ResourceLoader.exists('res://assets/environments/'+g.Arenas.definition(arena).floor+'.png'),'Real arena art '+arena)
		setup(arena,'campaign',10)
		check(g.enemies.size()==1 and g.enemies[0].kind=='boss','Campaign boss actually spawns '+arena)
		g.damage_enemy(g.enemies[0],1000000);check(g.state==g.State.VICTORY,'Campaign win '+arena)
		for wave in [10,20,30]:
			setup(arena,'endless',wave);var boss=g.enemies[0];var hp=boss.max_hp
			g.max_hp=100;g.hp=100;g.refresh_hud();check(g.hud.text.contains('HP 100 / 100') and g.hud.text.contains('WELLE %d / ENDLOS' % wave),'Endless HUD preserves max HP '+arena+str(wave))
			check(g.rules.boss_wave() and hp>1000,'Recurring actual boss '+arena+str(wave))
			g.damage_enemy(boss,1000000000)
			check(g.state==g.State.SHOP and not g.result_recorded,'Boss kill continues into shop '+arena+str(wave))
			g.encounters.rewards.clear();g.next_shop_wave();g.begin_wave()
			check(g.wave_number==wave+1 and not g.rules.boss_wave() and g.remaining==60,'Next endless wave after boss '+arena+str(wave))
			g.ravox.allowed();check(g.ravox.spawned.size()<=1,'Endless quota storage bounded '+arena+str(wave))
	setup('docks','endless',31);g.kills=150;g.run_time=180;var games=g.saved.games;g.finish(false)
	check(g.saved.endless_records.docks.highest_wave==31 and g.saved.endless_records.docks.kills==150,'Endless score beyond ten retained')
	check(g.saved.games==games,'Endless does not pollute campaign denominator')
	var runs=g.saved.endless_records.docks.runs;g.finish(false);check(g.saved.endless_records.docks.runs==runs,'Endless results recorded once')
	var path='user://worlds_test.json';Save.save_local(g.saved,path);var restored=Save.load_local(path)
	check(restored.endless_records.docks.highest_wave==31,'Endless score reloads without clamping to ten')
	var old=g.default_save();old.erase('endless_records');old.arena_records.erase('docks');old.arena_records.erase('foundry');Save.save_local(old,path);restored=Save.load_local(path)
	check(restored.endless_records.docks.runs==0 and restored.arena_records.foundry.games==0,'Old saves gain empty profiles without invented progress')
	setup('scrapyard');var previous={}
	for wave in range(1,10):
		g.wave_number=wave;var d=g.rules.scale_stats(g.WaveBalance.stats(g.enemy_data.grunt,g.rules.current_wave(),wave))
		if not previous.is_empty():check(d.hp>previous.hp and d.speed>previous.speed and d.damage>previous.damage,'Difficulty rises wave '+str(wave))
		previous=d
	g.wave_number=9;g.player.velocity=Vector2(0,200);var sample={'kind':'grunt','pos':g.player.position-Vector2(150,0)}
	check(g.rules.direction(sample).y>0,'Later enemies anticipate movement')
	sample.kind='boss';check(g.rules.direction(sample)==Vector2.RIGHT,'Telegraphed boss chase is not altered by agility')
	g.wave_number=100000;var values=g.rules.scale_stats({'hp':100.0,'speed':100.0,'damage':10.0});check(values.speed<=180 and is_finite(values.hp),'Endless speed bounded and stats finite')
	g.level=999;check(g.required_xp()>0 and g.required_xp()<=1000000000,'Long-run XP formula safe')
	g.xp=2000000000;g.state=g.State.LEVEL_UP;g.if_more_levels();check(g.state==g.State.COMBAT,'Level cap never traps pending upgrades')
	for arena in ['docks','foundry']:
		setup(arena,'campaign',6);g.arena_hazards.clock=0;g.arena_hazards.update(.01)
		check(not g.arena_hazards.items.is_empty(),'New arena hazard is real '+arena)
		var hazard=g.arena_hazards.items[0];check(hazard.warm>=1.6,'Full readable hazard warning '+arena)
	setup('docks','endless',20);g.remaining=.001;g._physics_process(.01);check(g.state==g.State.GAME_OVER,'Endless boss timeout loses correctly')
	setup('docks','endless',1001);g.remaining=.001;g._physics_process(.01);check(g.state==g.State.SHOP,'High-number normal wave safely reaches shop')
	var motion=g.menu_motion;motion.reset();motion.apply(Vector2.ZERO,.1);var offset=motion.apply(Vector2(100,-100),1)
	check(offset.length()<=.7 and offset.is_finite(),'Tilt filtering bounded')
	motion.reset();check(motion.filtered==Vector2.ZERO and not motion.calibrated,'Tilt can recalibrate')
	# Real guided training completion using the same public actions as touch controls.
	g.main_menu();var campaign_games=g.saved.games;var original_mode=g.run_mode;g.tutorial.start();var t=g.tutorial
	check(t.active and t.step==0 and t.frozen(),'Tutorial intro appears and freezes training')
	var finger=InputEventScreenTouch.new();finger.index=5;finger.pressed=true;finger.position=g.ui_root.get_global_transform()*Vector2(550,680);g._input(finger)
	check(g.stick_id==-1,'Coach touch never stolen by joystick')
	finger.pressed=false;g._input(finger)
	t.next();g.player.position+=Vector2(130,0);t._process(0);check(t.done,'Actual movement satisfies lesson')
	t.next();g.damage_enemy(g.enemies[0],100);t._process(0);check(t.done,'Real auto-combat kill tracked')
	t.next();g.loot[0].pos=g.player.position;g.update_loot(.01);t._process(0);check(t.done,'Real XP pickup tracked')
	t.next();g.apply_upgrade('damage');g.if_more_levels();t._process(0);check(t.done and g.state==g.State.COMBAT,'Actual level choice completes lesson')
	t.next();g.hero_ability.activate();t._process(0);check(t.done,'Actual ability tracked')
	t.next();var enemy=g.enemies[0];g.ravox.velocity(enemy,Vector2.LEFT,.01);g.ravox.velocity(enemy,Vector2.LEFT,2);g.player.position+=Vector2(0,220);g.update_enemies(1);t._process(0);check(t.done,'Actual telegraph dodge completes lesson')
	t.next();g.buy_offer(0);t._process(0);check(t.done,'Actual shop purchase tracked')
	t.next();g.reroll_shop();t._process(0);check(t.done,'Actual reroll tracked')
	t.next();g.run_items.upgrade('blaster');t._process(0);check(t.done,'Actual workshop upgrade tracked')
	t.next();g.next_shop_wave();g.begin_wave();g.pause_game();t._process(0);g.resume();t._process(0);check(t.done,'Actual pause and resume tracked')
	t.next();t.next();t.next();check(not t.active and g.saved.settings.tutorial_complete and g.saved.games==campaign_games and g.run_mode==original_mode,'Completed training saves only completion and restores mode')
	g.tutorial.start();g.tutorial.stop(false);check(not g.tutorial.active,'Tutorial cancellation safe')
	g.saved=original;g.save_game();g.queue_free();await process_frame;DirAccess.remove_absolute(path)
	print('WORLDS ENDLESS RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
