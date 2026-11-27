extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const PATH='user://tactics_test.json'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.02
func tool():return g.arena_mechanics.worlds
func start(arena:String,wave:int=3,hero:int=0,mode:String='campaign'):
	g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode=mode;g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0;g.armor=0;g.hurt_clock=0;g.hp=1000;g.max_hp=1000
func ready():g.remaining=49.9;g.arena_mechanics.update(.01)
func activate():
	ready()
	if tool().definition().mode=='relay':
		for node in tool().nodes:g.player.position=node;g.arena_mechanics.update(.01)
	else:g.player.position=tool().nodes[0];g.move_input=Vector2.ZERO;g.arena_mechanics.update(1.01)
func dummy(at:Vector2,hp:float=1) -> Dictionary:
	g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=at;e.hp=hp;e.max_hp=hp;e.speed=0;return e
func hit_point(h:Dictionary) -> Vector2:
	if h.shape=='beam':return (h.a+h.b)*.5
	return h.at+Vector2((float(h.inner)+float(h.radius))*.5 if h.shape=='ring' else 0,0)
func control(value:String):
	for node in g.ui_root.get_children():
		if node is Button and node.text==value:return node
	return null
func tap(b:Button):
	if b==null:check(false,'Expected actual arena help button');return
	await process_frame;await process_frame
	var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
	if native_touch:
		at=root.get_final_transform()*at
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=7;e.position=at;e.pressed=down;Input.parse_input_event(e);await process_frame
	else:
		var motion=InputEventMouseMotion.new();motion.position=at;root.push_input(motion,true);await process_frame
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=at;e.global_position=at;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true);await process_frame
	await process_frame;await process_frame
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.world_map.save_path=PATH
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for arena in tool().IDS:
		for hero in [0,5,11]:
			for quality in ['LOW','MEDIUM','HIGH']:
				start(arena,3,hero);g.saved.settings.quality=quality
				check(g.arena_mechanics.normal_wave() and tool().stage=='waiting' and tool().hazards.is_empty(),'Optional waiting tool '+arena+' '+str(hero)+' '+quality)
				g.remaining=50.1;g.arena_mechanics.update(.5);check(tool().stage=='waiting','No event before ten seconds')
				ready();check(tool().stage=='ready','Equipment becomes available on actual wave clock')
				if tool().definition().mode!='relay':
					g.player.position=tool().nodes[0];g.move_input=Vector2.RIGHT;g.arena_mechanics.update(2);check(tool().stage=='ready','Passing equipment never accidentally activates it')
				activate();check(tool().stage=='windup' and not tool().hazards.is_empty() and tool().hazards.all(func(h):return h.age==0),'Freshly announced geometry gets its complete warning')
				var h=tool().hazards[0];var at=hit_point(h);var a=dummy(at);var b=dummy(at+Vector2(12,0));var far=dummy(Vector2(50,1500),10000)
				g.player.position=Vector2(60,60);var coins=g.coins;var seed=g.rng.state;var reward=a.coin_reward+b.coin_reward
				g.arena_mechanics.update(1.99);check(a.hp==1 and b.hp==1 and g.coins==coins,'No early environmental hit')
				g.arena_mechanics.update(.02);check(not g.enemies.has(a) and not g.enemies.has(b) and far.hp==10000,'Real collision defeats only in-area targets')
				g.arena_mechanics.update(2);var bonus=g.arena_mechanics.bonus(arena)
				check(tool().stage=='complete' and g.arena_mechanics.total_coins==bonus and wallet_and_drops()==coins+reward+bonus,'Actual normal loot and one exact maneuver reward')
				check(g.rng.state==seed and g.arena_mechanics.arena_kills==2,'No combat RNG draws, duplicated deaths or artificial kills')
				g.arena_mechanics.update(50);tool().activate();check(g.arena_mechanics.total_coins==bonus and g.arena_mechanics.maneuvers==1,'No repeat farming or reactivation')
				g.cleanup();check(tool().hazards.is_empty() and tool().nodes.is_empty() and tool().warmth_left==0,'Wave cleanup releases all tool state')
	# Different movement and control consequences are gameplay, not recolored warnings.
	start('gardens');ready();var at:Vector2=tool().nodes[0]
	g.united.enemies.circle(at,80,3,1,10);var boss_field={'kind':'boss'};g.united.enemies.circle(at,80,3,1,10,boss_field)
	activate();g.arena_mechanics.update(2.01);check(g.united.enemies.hazards.size()==1 and g.united.enemies.hazards[0].owner==boss_field,'Filter cleans hostile circles but preserves boss geometry');check(g.hp==1000,'Cleaning pulse cannot hurt its player')
	start('frost');activate();at=tool().nodes[0];var a=dummy(at,10000);g.arena_mechanics.update(2.01)
	check(tool().warmth_left==4 and tool().protects_slow() and a.ability_slow==.5 and a.ability_slow_time==2,'Heat creates real bounded protection and enemy slow')
	g.united.enemies.slow_time=2;g.move_input=Vector2.RIGHT;var before:Vector2=g.player.position;g._physics_process(.1)
	check(g.player.position!=before and near(g.player.velocity.length(),g.speed),'Player keeps full analog speed inside warmth')
	g.player.position=at+Vector2(400,0);before=g.player.position;g._physics_process(.1);check(g.player.position!=before and near(g.player.velocity.length(),g.speed*.6),'Outside heat the same frost status slows actual movement')
	g.arena_mechanics.update(5);check(not tool().protects_slow(),'Warmth expires and never becomes permanent immunity')
	start('storm');ready();at=tool().nodes[0];a=dummy(at+Vector2(300,0),10000);activate();var h=tool().hazards[0];var endpoint:Vector2=h.b
	a.pos=at+Vector2(-300,0);g.player.position=Vector2(50,50);g.arena_mechanics.update(1);check(h.b==endpoint,'Lightning aim is locked instead of tracking after warning')
	a.pos=hit_point(h);g.arena_mechanics.update(1.01);check(a.steel_stun==1.0,'Lightning actually interrupts and stuns normal survivors')
	start('crystal');ready();g.player.position=tool().nodes[2];g.arena_mechanics.update(1);check(tool().step==0,'Relay enforces its announced order')
	for pos in tool().nodes:g.player.position=pos;g.arena_mechanics.update(.01)
	check(tool().step==3 and tool().hazards.size()==2,'Ordered movement creates two announced diagonal beams')
	start('carnival');activate();check(tool().hazards.map(func(x):return snappedf(x.warm,.1))==[2.0,2.6,3.2],'Bomb cascade has three distinct complete fuse times')
	g.player.position=Vector2(40,40);g.arena_mechanics.update(10);check(g.arena_mechanics.total_coins==0,'Empty bomb cascades cannot pay a bonus')
	start('void');activate();h=tool().hazards[0];at=h.at;a=dummy(at+Vector2(300,0),10000);var elite=dummy(at+Vector2(-300,0),10000);elite.elite='armored'
	var elite_at:Vector2=elite.pos;g.arena_mechanics.update(1.5);check(near(a.pos.distance_to(at),255) and elite.pos==elite_at,'Gravity uses elapsed overlap and elites resist forced movement')
	check(not tool().contains(h,at,27) and tool().contains(h,at+Vector2(170,0),27) and not tool().contains(h,at+Vector2(350,0),27),'Annulus geometry has real safe inner and outer space')
	for arena in tool().IDS:
		start(arena);activate();h=tool().hazards[0];var age=h.age;var state=tool().stage
		for paused in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
			g.state=paused;g.arena_mechanics.update(20);check(h.age==age and tool().stage==state,'Full tool simulation freezes in '+str(paused)+' '+arena)
		g.state=g.State.COMBAT;g.player.position=hit_point(h);var hp=g.hp;g.arena_mechanics.update(2.01)
		check(g.hp==hp if h.friendly else g.hp<hp,'Friendly and hostile areas have distinct actual player collision '+arena)
		start(arena);ready();g.remaining=5;g.player.position=tool().nodes[0];g.arena_mechanics.update(2);check(tool().stage=='expired' and tool().hazards.is_empty(),'Late-wave inputs cannot leave invisible attacks')
		start(arena,10);var boss=g.enemies[0];var wallet=g.coins;var max_hp=boss.max_hp;boss.pos=g.player.position+Vector2(180,0)
		var warm=g.arena_mechanics.boss_zones(boss,g.player.position);check(warm>=2 and tool().hazards.size()<=3 and tool().hazards.all(func(x):return x.owner==boss and not x.friendly),'Each final boss has its own bounded announced geometry '+arena)
		h=tool().hazards[0];boss.pos=hit_point(h);h.owner_start=boss.pos;g.player.position=Vector2(45,45);var old_hp=boss.hp
		g.arena_mechanics.update(.5);g.arena_mechanics.remove_owner(boss);check(tool().hazards.is_empty() and boss.hp==old_hp,'Removing owner cancels pending effects '+arena)
		g.arena_mechanics.boss_zones(boss,boss.pos);var count=tool().hazards.size();boss.pos=hit_point(tool().hazards[0])
		for item in tool().hazards:item.owner_start=boss.pos
		g.arena_mechanics.update(10);check(old_hp>boss.hp and old_hp-boss.hp<=max_hp*.005*count+.01 and g.coins==wallet and g.arena_mechanics.total_coins==0,'Environmental boss damage is capped; no boss maneuver bonus '+arena)
		# Player death resolves first and cannot yield posthumous rewards.
		start(arena);activate();h=tool().hazards[0]
		if not h.friendly:
			g.hp=1;g.player.position=hit_point(h);a=dummy(g.player.position);g.arena_mechanics.update(10)
			check(g.state==g.State.GAME_OVER and g.arena_mechanics.total_coins==0 and tool().hazards.is_empty(),'Lethal mistake cannot award bonus after game over '+arena)
		start(arena,13,0,'endless');check(g.arena_mechanics.normal_wave() and tool().stage=='waiting','Endless reuses one bounded tool per normal wave '+arena)
		start(arena,1);check(not g.arena_mechanics.normal_wave() and tool().nodes.is_empty(),'First wave has no extra arena workload '+arena)
	# Readable boss phase/cadence feedback and exact ray count without new attack speed.
	start('storm',10);var director=g.united.bosses;var boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,0);director.stage='chase';director.clock=0;director.update(.01)
	check(director.stage=='windup' and '1.8' in director.hint(),'Actual boss attack exposes remaining windup')
	var clock=director.clock;g.state=g.State.PAUSED;director.update(10);check(director.clock==clock,'Boss countdown pauses with gameplay');g.state=g.State.COMBAT;director.update(clock+.01)
	for i in range(5):director.update(.23)
	check('ANGRIFFSFENSTER' in director.hint(),'Recovery window is visible and uses actual cooldown')
	# First-use lessons, pause tips and save/load use the production UI.
	for arena in tool().IDS:
		start(arena);g.state=g.State.WAVE_PREPARATION;g.saved.settings.arena_briefings.erase(arena);g.test_mode=false;check(g.arena_coach.offer(),'First-use coach available '+arena)
		await tap(control('VERSTANDEN'));check(g.saved.settings.arena_briefings.has(arena),'Native confirmation saves one-time lesson '+arena)
		g.test_mode=true;g.begin_wave();g.pause_game();g.test_mode=false;await tap(control('ARENA-TIPPS'));await tap(control('VERSTANDEN'));check(g.state==g.State.PAUSED and control('FORTSETZEN')!=null,'Native arena tips return to paused run '+arena);g.test_mode=true
	Save.save_local(g.saved,PATH);var loaded=Save.load_local(PATH);check(tool().IDS.all(func(id):return loaded.settings.arena_briefings.has(id)),'All six new coach confirmations survive loading')
	g.saved=original;g.save_game();var refs=[weakref(tool())];g.free();DirAccess.remove_absolute(PATH);call_deferred('lifetime',refs)
func lifetime(refs:Array):
	await process_frame;await process_frame;await process_frame
	check(refs.all(func(r):return r.get_ref()==null),'World tool manager has no surviving reference cycle')
	print('TACTICS RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)

func wallet_and_drops() -> int:
	var value=int(g.coins)
	for packet in g.loot:value+=int(packet.get('coin',0))
	return value
