extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const PATH='user://arena_mechanics_test.json'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,message:String):
	if ok:passed+=1;print('PASS ',message)
	else:failed+=1;push_error('FAIL '+message)
func near(a:float,b:float) -> bool:return absf(a-b)<.01
func start(arena:String='reactor',wave:int=3,hero:int=0,mode:String='campaign'):
	g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode=mode;g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0;g.armor=0
func dummy(at:Vector2,health:float=1) -> Dictionary:
	g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=at;e.hp=health;e.max_hp=health;e.speed=0;return e
func charge_with_weapon():
	for i in range(12):
		var e=dummy(g.player.position+Vector2(75 if g.selected==0 else 170,0));g.weapons[0].clock=0;g.update_weapons(.01)
		if g.selected==1:g.update_shots(.3);g.projectile_pool.clear()
		check(not g.enemies.has(e),'Real class attack defeats core donor '+str(g.selected)+' '+str(i))
	check(g.arena_mechanics.cores.size()==3 and g.arena_mechanics.dropped==3,'Twelve weapon kills produce three bounded core drops')
	for core in g.arena_mechanics.cores:core.pos=g.player.position
	g.arena_mechanics.update(.01);check(g.arena_mechanics.charge==3 and g.arena_mechanics.cores.is_empty(),'Actual proximity pickup charges reactor')
func accept():
	g.player.position=g.arena_mechanics.terminal;g.move_input=Vector2.RIGHT;g.arena_mechanics.update(2)
	check(g.arena_mechanics.stage=='collect','Walking through terminal does not activate')
	g.move_input=Vector2.ZERO;g.arena_mechanics.update(1.19);check(g.arena_mechanics.hazards.is_empty(),'Full deliberate hold required')
	g.arena_mechanics.update(.02);check(g.arena_mechanics.stage=='overload' and g.arena_mechanics.hazards.size()==1 and g.arena_mechanics.charge==0,'Intentional hold consumes exactly three cores')
func button(text:String):
	var nodes=g.ui_root.get_children().filter(func(n):return n is Button and n.text==text)
	return null if nodes.is_empty() else nodes[0]
func tap_control(b:Button):
	if b==null:check(false,'Expected usable help control');return
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
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.world_map.save_path=PATH
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for hero in [0,1]:
		for quality in ['LOW','MEDIUM','HIGH']:
			start('reactor',3,hero);g.saved.settings.quality=quality;charge_with_weapon();accept()
			var at=g.arena_mechanics.terminal;var a=dummy(at+Vector2(40,0));var b=dummy(at+Vector2(-40,0));var far=dummy(at+Vector2(450,0),1000)
			var hp=g.hp;var wallet=g.coins;var seed=g.rng.state;var coins=int(a.coin_reward)+int(b.coin_reward)
			g.arena_mechanics.update(2.49);check(g.hp==hp and a.hp==1,'No reactor damage before 2.5 second warning '+str(hero)+' '+quality)
			g.arena_mechanics.update(.02)
			check(near(g.hp,hp-14) and not g.enemies.has(a) and not g.enemies.has(b) and far.hp==1000,'Reactor snapshot hits player and nearby enemies only')
			check(g.rng.state==seed,'Arena damage does not consume critical RNG or inherit class crit')
			check(g.arena_mechanics.total_coins==30 and g.arena_mechanics.arena_kills==2 and g.coins==wallet+coins+30,'Normal kill loot plus exact once-only maneuver bonus')
			for i in range(4):g.arena_mechanics.update(3)
			check(g.coins==wallet+coins+30 and g.arena_mechanics.maneuvers==1 and g.arena_mechanics.hazards.is_empty(),'Reactor cannot repeat damage or farm bonus')
			g.cleanup();check(g.arena_mechanics.cores.is_empty() and g.arena_mechanics.hazards.is_empty() and g.arena_mechanics.total_coins==30,'Wave cleanup retains only run totals')
			g.start_run();check(g.arena_mechanics.total_coins==0 and g.arena_mechanics.arena_kills==0,'New run resets arena receipts')
	for hero in [0,1]:
		start('docks',3,hero);g.remaining=44.1;g.arena_mechanics.update(.01);check(g.arena_mechanics.hazards.is_empty(),'No container before scheduled time')
		g.remaining=44;g.arena_mechanics.update(.01);check(g.arena_mechanics.hazards.size()==2,'One bounded double load announced')
		var h=g.arena_mechanics.hazards[0];var snapshot:Vector2=h.pos;var a=dummy(snapshot+Vector2(35,0));var b=dummy(snapshot-Vector2(35,0));var hp=g.hp;var wallet=g.coins;var coins=int(a.coin_reward)+int(b.coin_reward)
		g.arena_mechanics.update(1.99);check(g.hp==hp and a.hp==1,'No container damage before complete two-second warning')
		g.player.position+=Vector2(0,300);g.arena_mechanics.update(.02)
		check(g.hp==hp and not g.enemies.has(a) and not g.enemies.has(b) and h.pos==snapshot,'Player can dodge fixed landing and lure enemies under container')
		check(g.arena_mechanics.total_coins==24 and g.coins==wallet+coins+24 and g.arena_mechanics.arena_kills==2,'Container pair awards bonus once after two kills')
		g.arena_mechanics.update(4);check(g.arena_mechanics.maneuvers==1 and g.arena_mechanics.total_coins==24,'Spent pair cannot pay repeatedly')
		g.remaining=20;g.arena_mechanics.update(.01);check(g.arena_mechanics.hazards.size()==2 and g.arena_mechanics.drop_index==2,'Second scheduled pair is the wave limit')
		g.arena_mechanics.update(2.1);check(g.hp==hp-12 and g.arena_mechanics.total_coins==24,'Second pair creates actual danger and no empty bonus')
		g.arena_mechanics.update(100);check(g.arena_mechanics.hazards.is_empty() and g.arena_mechanics.drop_index==2,'Long frame cannot create unbounded drops')
	# Shared exact collision geometry, including edges, fast frames, death and pause.
	for arena in ['reactor','docks']:
		for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
			start(arena);g.arena_mechanics.add_hazard('core' if arena=='reactor' else 'container',g.player.position,2)
			g.state=state;var before=g.hp;g.arena_mechanics.update(10);g._physics_process(10)
			check(g.arena_mechanics.hazards[0].age==0 and g.hp==before,'All environmental simulation frozen '+arena+' '+str(state))
		start(arena);g.arena_mechanics.add_hazard('core' if arena=='reactor' else 'container',g.player.position,2);var h=g.arena_mechanics.hazards[0]
		var outside=h.rect.end+Vector2(28,28) if arena=='docks' else h.pos+Vector2(h.radius+28,0)
		check(g.arena_mechanics.contains(h,h.pos,27) and not g.arena_mechanics.contains(h,outside,27),'Warning snapshot and player collision agree '+arena)
		g.arena_mechanics.update(20);check(g.hp<g.max_hp and g.arena_mechanics.hazards.is_empty(),'Long frame resolves exactly one actual impact '+arena)
		start(arena);g.arena_mechanics.add_hazard('core' if arena=='reactor' else 'container',g.player.position,2);g.hp=1;g.arena_mechanics.update(3)
		check(g.state==g.State.GAME_OVER and g.arena_mechanics.total_coins==0 and g.arena_mechanics.hazards.is_empty(),'Lethal mistake clears all pending damage and rewards '+arena)
		g.start_run();check(g.state==g.State.WAVE_PREPARATION,'Safe restart after environmental death '+arena)
	# Boss patterns preserve fixed HP, full windup and cap all damage to bosses.
	for arena in ['reactor','docks']:
		start(arena,10);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,0)
		g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01)
		check(g.united.bosses.stage=='windup' and near(g.united.bosses.clock,2) and g.arena_mechanics.hazards.size()==3,'Actual map boss creates three fully warned arena attacks '+arena)
		var health=boss.hp;boss.hp=boss.max_hp*.3;g.united.bosses.update(.1);check(g.arena_mechanics.hazards.size()==3 and g.united.bosses.stage=='windup','Threshold damage preserves already announced arena pattern '+arena)
		g.damage_enemy(boss,1000000000);check(g.arena_mechanics.hazards.is_empty() and g.state==g.State.VICTORY,'Boss death safely clears owned arena warnings '+arena)
		start(arena,10);boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,0);g.arena_mechanics.add_hazard('core' if arena=='reactor' else 'container',boss.pos,2,boss);g.player.position-=Vector2(220,0);health=boss.hp;g.crit=.75;var seed=g.rng.state
		g.arena_mechanics.update(2.01);check(near(health-boss.hp,boss.max_hp*.005) and g.rng.state==seed,'Environmental boss damage capped at half a percent per impact '+arena)
		check(g.arena_mechanics.total_coins==0,'Boss hazards cannot farm maneuver bonus '+arena)
		start(arena,10);boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,0);g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01);boss.pos+=Vector2(12,0);g.arena_mechanics.update(3)
		check(g.arena_mechanics.hazards.is_empty() and g.hp==g.max_hp,'Displaced boss cancels warning before impact '+arena)
	# No global tuning or tutorial changes; persisted help is defensive and repeatable.
	for mode in ['tutorial','campaign','endless']:
		start('reactor',13,0,mode);check(g.arena_mechanics.normal_wave()==(mode!='tutorial'),'Endless repeats mechanics, tutorial remains isolated '+mode)
	for arena in g.Arenas.IDS:
		start(arena);check(g.arena_mechanics.supported()==(arena in ['reactor','docks']),'Other worlds retain their mechanics '+arena)
	start();g.arena_mechanics.charge=3;g.remaining=6;g.arena_mechanics.update(.01);check(g.arena_mechanics.stage=='expired','No late unreachable reactor activation')
	for corner in [Vector2(45,45),Vector2(2355,45),Vector2(45,1555),Vector2(2355,1555)]:
		start();g.player.position=corner;g.arena_mechanics.begin_wave();check(g.arena_mechanics.terminal.distance_to(corner)>75,'Terminal never auto-activates under idle edge player')
	start();g.saved.settings.arena_briefings=['reactor','reactor','forged',123,'docks'];Save.save_local(g.saved,PATH);var loaded=Save.load_local(PATH)
	check(loaded.settings.arena_briefings==['reactor','docks'],'Help migration sanitizes IDs, types and duplicates')
	for arena in ['reactor','docks']:
		start(arena);g.main_menu();g.character_select();g.start_run();g.wave_number=3;g.saved.settings.arena_briefings=[];g.test_mode=false;g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.prepare_wave();await process_frame
		check(g.state==g.State.WAVE_PREPARATION and g.ui_root.get_children().any(func(n):return n is Label and n.text=='KICKSYS ARENA-TIPP'),'First appearance shows Kicksy and freezes gameplay '+arena)
		await tap_control(button('VERSTANDEN'));check(g.saved.settings.arena_briefings.has(arena) and g.state==g.State.WAVE_PREPARATION and button('LOS GEHT’S')!=null,'Real help touch saves acknowledgement and returns to briefing '+arena)
		g.begin_wave();g.pause_game();await tap_control(button('ARENA-TIPPS'));check(g.state==g.State.PAUSED and button('VERSTANDEN')!=null,'Help can reopen in pause without resuming combat '+arena)
		await tap_control(button('VERSTANDEN'));check(g.state==g.State.PAUSED and button('FORTSETZEN')!=null,'Help returns to pause safely '+arena);g.test_mode=true
	for id in ['core_collect','core_warning','core_blast','container_warning','container_impact']:
		var sound=load('res://assets/audio/'+id+'.wav');check(sound is AudioStreamWAV and sound.get_length()>.1,'Imported original sound '+id)
	g.saved=original;g.save_game();g.free();await process_frame;DirAccess.remove_absolute(PATH)
	print('ARENA MECHANICS RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)
