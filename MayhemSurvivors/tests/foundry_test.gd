extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const PATH='user://foundry_test.json'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.03
func start(hero:int=0,wave:int=3,mode:String='campaign',arena:String='foundry'):
	g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode=mode;g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0;g.armor=0
func enemy(at:Vector2,hp:float=1,kind:String='grunt') -> Dictionary:
	g.spawn_enemy(kind);var e=g.enemies.back();e.pos=at;e.hp=hp;e.max_hp=hp;e.speed=0;return e
func fire(index:int=0,target:float=.7) -> Dictionary:
	var v:Dictionary=g.arena_mechanics.valves.stations[index];var d=g.arena_mechanics.data.foundry
	g.player.position=v.pos;g.move_input=Vector2.ZERO;v.age=float(d.cycle)*target-float(d.hold)
	g.arena_mechanics.update(.79);check(not v.used,'Valve requires full hold')
	g.arena_mechanics.update(.02);check(v.used and not g.arena_mechanics.hazards.is_empty(),'Real proximity hold releases one directional burst')
	return g.arena_mechanics.hazards.back()
func control(text:String):
	var nodes=g.ui_root.get_children().filter(func(n):return n is Button and n.text==text)
	return null if nodes.is_empty() else nodes[0]
func tap(b:Button):
	if not b:check(false,'Expected real GUI control');return
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
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.world_map.save_path=PATH
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for hero in [0,1,5]:
		for quality in ['LOW','MEDIUM','HIGH']:
			start(hero);g.saved.settings.quality=quality;var m=g.arena_mechanics;var valves=m.valves
			check(valves.stations.size()==2 and m.hazards.is_empty(),'Exactly two optional valves; no automatic steam '+str(hero)+' '+quality)
			var v=valves.stations[0];g.player.position=v.pos;g.move_input=Vector2.RIGHT;m.update(2)
			check(not v.used and v.held==0,'Moving through never releases the valve')
			var h=fire();var a=enemy(h.rect.get_center());var b=enemy(h.rect.get_center()+h.direction*35,1000);var far=enemy(h.rect.end+Vector2(100,100),1000)
			var old:Vector2=b.pos;var hp=g.hp;var wallet=g.coins;var loot=g.loot.size();var reward=int(a.coin_reward);var seed=g.rng.state;g.crit=.75
			m.update(1.59);check(a.hp==1 and b.pos==old and g.hp==hp,'Full 1.6 second telegraph; no early damage or push')
			m.update(.02)
			check(not g.enemies.has(a) and near(b.hp,1000-h.enemy_damage) and far.hp==1000,'Directional footprint damages only enemies inside')
			check(b.pos.is_equal_approx(old+h.direction*170) and g.hp==hp,'Surviving enemy pushed along arrow; operator remains safe')
			check(m.total_coins==28 and g.coins==wallet+reward+28 and g.loot.size()==loot+1,'Sweet pressure grants exact bounded bonus plus ordinary XP/coins')
			check(g.rng.state==seed,'Environmental steam has no critical RNG draw')
			var count=m.hazards.size();valves.release(v);check(m.hazards.size()==count,'Used handwheel cannot spawn another burst')
			m.update(3);check(m.maneuvers==1 and m.total_coins==28 and m.hazards.is_empty(),'One damage and bonus resolution per handwheel')
			h=fire(1);a=enemy(h.rect.get_center());m.update(1.61);check(m.total_coins==56 and valves.used()==2,'Second distinct valve has the only other wave bonus')
			g.cleanup();check(m.valves.stations.is_empty() and m.hazards.is_empty() and m.total_coins==56,'Wave cleanup retains only receipt')
			g.start_run();check(m.total_coins==0 and m.maneuvers==0,'Restart resets all foundry receipts');m=null;valves=null
	for pressure in [.15,.7,.95]:
		start();var h=fire(0,pressure);enemy(h.rect.get_center());g.arena_mechanics.update(1.61)
		check(h.sweet==(pressure==.7) and g.arena_mechanics.total_coins==(28 if pressure==.7 else 0),'Pressure snapshot controls bonus '+str(pressure))
		check(near(h.enemy_damage,200*(.5+.5*h.pressure)),'Pressure-based damage derives from data '+str(pressure))
	start();var v=g.arena_mechanics.valves.stations[0];v.age=11.9;g.arena_mechanics.update(.2)
	check(g.arena_mechanics.valves.pressure(v)<.02 and not v.used,'Pressure cycles safely without an automatic release')
	start();var h=fire();g.arena_mechanics.update(1.61);check(g.arena_mechanics.total_coins==0,'Sweet pressure without a kill gives no bonus')
	for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
		start();h=fire();v=g.arena_mechanics.valves.stations[1];var age=v.age;g.state=state;g.arena_mechanics.update(8);g._physics_process(8)
		check(h.age==0 and v.age==age and g.hp==g.max_hp,'Valve clocks, warning and collision frozen '+str(state))
		g.arena_mechanics.valves.release(v);check(not v.used and g.arena_mechanics.hazards.size()==1,'Release API rejects paused or shop use '+str(state))
	start();h=fire();g.player.position=h.rect.get_center();var hp=g.hp;g.arena_mechanics.update(1.59);check(g.hp==hp,'Player has full warning inside steam')
	g.arena_mechanics.update(.02);check(g.hp==hp-10,'Player entering jet takes actual damage')
	g.arena_mechanics.update(5);check(g.hp==hp-10,'Lingering steam art cannot deal duplicate damage')
	start();h=fire();g.player.position=h.rect.get_center();g.hp=1;var a=enemy(g.player.position);g.arena_mechanics.update(5)
	check(g.state==g.State.GAME_OVER and g.arena_mechanics.hazards.is_empty() and a.hp==1 and g.arena_mechanics.total_coins==0,'Death stops pending kills and posthumous rewards')
	g.start_run();check(g.state==g.State.WAVE_PREPARATION,'Restart remains usable after steam death')
	start();g.remaining=3;v=g.arena_mechanics.valves.stations[0];g.player.position=v.pos;g.move_input=Vector2.ZERO;g.arena_mechanics.update(2)
	g.arena_mechanics.valves.release(v);check(not v.used and g.arena_mechanics.hazards.is_empty(),'Late window and public action reject unfinished activation')
	for at in [Vector2(45,45),Vector2(2355,45),Vector2(45,1555),Vector2(2355,1555)]:
		start();g.player.position=at;g.arena_mechanics.valves.clear();g.arena_mechanics.valves.begin_wave()
		for valve in g.arena_mechanics.valves.stations:
			var rect=g.arena_mechanics.valves.rect(valve.pos,valve.direction)
			check(valve.pos.distance_to(at)>65 and rect.has_area() and not rect.grow(27).has_point(valve.pos),'Valid valve/jet geometry at arena edge '+str(at))
	# Actual final-boss attack, caps, warning ownership and phase transition.
	start(0,10);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,0);var max_hp=boss.max_hp
	g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01)
	check(g.arena_mechanics.hazards.size()==2 and g.arena_mechanics.hazards.all(func(x):return x.kind=='steam') and g.united.bosses.clock==2,'Ofenkönig casts real crossing steam lanes with full warning')
	var health=boss.hp;var before:Vector2=boss.pos;g.player.position-=Vector2(100,100);g.arena_mechanics.update(1.99);check(boss.hp==health,'Boss is not damaged before its own warning expires')
	g.arena_mechanics.update(.02);check(boss.hp<health and health-boss.hp<=max_hp*.01+.01 and boss.pos==before,'Environmental boss damage capped and no boss knockback')
	check(g.arena_mechanics.total_coins==0 and g.arena_mechanics.valves.stations.is_empty(),'Boss pattern grants no handwheel bonus')
	g.damage_enemy(boss,1000000000);check(g.state==g.State.VICTORY and g.arena_mechanics.hazards.is_empty(),'Final kill clears owned steam warnings and reaches victory')
	start(0,10);boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,0);g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01);boss.hp=boss.max_hp*.3;g.united.bosses.update(.1)
	check(g.arena_mechanics.hazards.size()==2 and g.united.bosses.stage=='windup','Phase threshold preserves the announced steam attack')
	boss.pos+=Vector2(12,0);g.arena_mechanics.update(4);check(g.arena_mechanics.hazards.is_empty() and g.hp==g.max_hp,'Displaced owner cancels steam before collision')
	for mode in ['campaign','endless','tutorial']:
		start(0,13,mode);check(g.arena_mechanics.valves.stations.size()==(0 if mode=='tutorial' else 2),'Recurring foundry rules in '+mode)
	for wave in [1,2,4,6,8,10]:
		start(0,wave);check(g.arena_mechanics.valves.stations.is_empty(),'No normal valve stations in starter/boss wave '+str(wave))
	start();g.arena_hazards.clock=0;g.arena_hazards.update(.01);check(not g.arena_hazards.items.is_empty(),'Existing hot floor lanes remain active')
	g.saved.settings.arena_briefings=['foundry','reactor','foundry','invalid'];Save.save_local(g.saved,PATH);var loaded=Save.load_local(PATH)
	check(loaded.settings.arena_briefings==['reactor','foundry'],'Help loader preserves foundry and sanitizes duplicates')
	g.main_menu();g.character_select();g.start_run();g.wave_number=3;g.saved.settings.arena_briefings=[];g.saved.settings.reduced_motion=true;g.saved.settings.master=0;g.test_mode=false;g.prepare_wave();await process_frame
	check(control('VERSTANDEN')!=null and g.state==g.State.WAVE_PREPARATION,'Kicksy appears before first foundry encounter')
	await tap(control('VERSTANDEN'));check(g.saved.settings.arena_briefings.has('foundry') and control('LOS GEHT’S')!=null,'Actual coach touch saves acknowledgement and returns to briefing')
	g.begin_wave();g.pause_game();await tap(control('ARENA-TIPPS'));check(g.state==g.State.PAUSED and control('VERSTANDEN')!=null,'Foundry help reopens while simulation stays paused')
	await tap(control('VERSTANDEN'));check(g.state==g.State.PAUSED and control('FORTSETZEN')!=null,'Actual help return preserves usable pause menu');g.test_mode=true
	for id in ['valve_turn','valve_ready','steam_warning','steam_hiss']:
		var sound=load('res://assets/audio/'+id+'.wav');check(sound is AudioStreamWAV and sound.get_length()>.1,'Imported original foundry sound '+id)
	g.saved=original;g.save_game();var weak_arena=weakref(g.arena_mechanics);var weak_valves=weakref(g.arena_mechanics.valves);g.free();await process_frame;await process_frame;await process_frame
	check(weak_arena.get_ref()==null and weak_valves.get_ref()==null,'Both managers release without a reference cycle')
	DirAccess.remove_absolute(PATH);print('FOUNDRY RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)
