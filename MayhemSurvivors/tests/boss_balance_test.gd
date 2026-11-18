extends SceneTree
const R=preload('res://scripts/core/roster.gd')
const HP={2:600,4:1800,6:3200,8:5500,10:12500}
const LIMIT={2:60,4:65,6:75,8:80,10:90}
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.01
func start(arena:String='scrapyard',wave:int=2,difficulty:String='normal',mode:String='campaign'):
	g.main_menu();g.selected=1;g.arena_id=arena;g.run_mode=mode;g.selected_difficulty=difficulty;g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0;g.armor=0;g.max_hp=100000;g.hp=g.max_hp
func settle():
	while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	# Real spawn scaling, timing, victory and rewards across the entire route and difficulties.
	for rank in range(R.ARENAS.size()):
		for difficulty in ['normal','veteran','mayhem']:
			for wave in [2,4,6,8,10]:
				start(R.ARENAS[rank],wave,difficulty);var boss=g.enemies[0]
				check(near(boss.max_hp,HP[wave]*(1+rank*.08)*g.Difficulty.definition(difficulty).boss_hp),'Fixed boss HP progression '+R.ARENAS[rank]+' '+difficulty+' '+str(wave))
				check(g.remaining==LIMIT[wave],'Time limit preserved '+R.ARENAS[rank]+' '+difficulty+' '+str(wave))
				var base=[10,13,18,17,20][wave/2-1];check(near(boss.damage,base*(1+rank*.035)*g.Difficulty.definition(difficulty).damage),'Contact damage remains fair '+R.ARENAS[rank]+' '+difficulty+' '+str(wave))
				var expected=125 if wave==6 else (150 if wave==10 else int(g.united.bosses.ladder[str(wave)].coins));var reward=g.Difficulty.reward(g,expected);g.damage_enemy(boss,100000000);settle()
				check(g.coins==reward and g.kills==1 and g.state==(g.State.VICTORY if wave==10 else g.State.SHOP),'Stronger boss keeps connected reward and completion '+R.ARENAS[rank]+' '+difficulty+' '+str(wave))
	# Boss adaptation never scales health to the player's weapon power.
	start();var fixed=g.united.bosses.profile().hp;g.damage_mult=100;g.attack_mult=100;g.multishot=4
	check(g.united.bosses.profile().hp==fixed,'No adaptive health or punishment of strong builds')
	# Every boss starts with a useful, fully announced attack.
	for wave in [2,4,6,8,10]:
		start('docks',wave);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(250,0)
		if wave==6:
			g.breaker.update(1.41);check(g.breaker.stage=='windup' and g.breaker.attack=='charge' and near(g.breaker.clock,1.25),'Axel announces the opening charge with full windup')
		else:
			g.united.bosses.update(1.41);check(g.united.bosses.stage=='windup' and g.united.bosses.attack==({2:'fan',4:'charge',8:'zones',10:'charge'}[wave]) and near(g.united.bosses.clock,1.5),'Distinct fully warned opener '+str(wave))
		var hp=g.hp;g._physics_process(.1);check(g.hp==hp,'Opening warning gives movement time '+str(wave))
		for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
			g.state=state;var clock=g.breaker.clock if wave==6 else g.united.bosses.clock;g._physics_process(3);g.breaker.update(3);g.united.bosses.update(3);check(near(clock,g.breaker.clock if wave==6 else g.united.bosses.clock),'New cadence freezes in '+str(state)+' / '+str(wave))
	# Threshold damage cannot erase a previously telegraphed attack.
	start('docks',2);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(250,0);g.united.bosses.clock=0;g.united.bosses.update(.01);boss.hp=boss.max_hp*.3
	g.united.bosses.update(1.0);check(g.united.bosses.stage=='windup' and g.united.bosses.tier==1,'Burst damage does not cancel the fan warning')
	g.united.bosses.update(.51);check(g.shots.filter(func(s):return s.active and s.hostile).size()==7,'Announced fan actually fires before phase transition')
	g.united.bosses.update(.01);check(g.united.bosses.stage=='phase' and g.united.bosses.tier==3,'Pending rage follows the completed attack')
	var amount=boss.hp;g.damage_enemy(boss,10);check(boss.hp<amount,'Phase transition has no hidden invulnerability')
	g.united.enemies.clear();g.united.enemies.circle(g.player.position,90,1.5,.5,10,boss);g.united.bosses.tier=1;g.united.bosses.stage='recovery';g.united.bosses.update(.01)
	check(g.united.enemies.hazards.size()==1,'Phase change preserves already telegraphed hazards')
	start('docks',6);boss=g.enemies[0];boss.pos=g.player.position+Vector2(200,0);g.breaker.begin_attack('hammer',boss);boss.hp=boss.max_hp*.3;g.breaker.update(.1)
	check(g.breaker.stage=='windup' and g.breaker.tier==1,'Axel finishes his announced pattern before rage');g.breaker.stage='recovery';g.breaker.update(.01);check(g.breaker.tier==3 and g.breaker.stage=='phase','Axel transitions after attack completion')
	# Actually hit the player after the fan's full warning, with unchanged damage.
	start('docks',2);boss=g.enemies[0];boss.pos=g.player.position+Vector2(250,0);g.united.bosses.clock=0;g.united.bosses.update(.01);var before=g.hp;g.united.bosses.update(1.49);g.update_shots(.01);check(g.hp==before,'No pre-warning projectile damage');g.united.bosses.update(.02);g.update_shots(1.1);check(g.hp<before,'Opening projectile attack creates actual pressure')
	# Compensation is explicit, limited to affected weapons and boss kinds.
	var weapons=[{'id':'orbit','level':1},{'id':'orbit','level':5,'spec':'wide'},{'id':'orbit','level':5,'spec':'swift'},{'id':'tesla','level':1},{'id':'tesla','level':5,'spec':'thunder_prism'}]
	for i in range(weapons.size()):
		var w=weapons[i];var expected=[2.0,3.4,2.2,1.25,1.25][i]
		for kind in R.BOSS_KINDS:check(near(g.united.bosses.weapon_power(w,{'kind':kind},10),10*expected),'Explicit compensation '+w.id+' '+str(i)+' '+kind)
		for kind in ['grunt','runner','tank']+R.NEW_ENEMIES:check(g.united.bosses.weapon_power(w,{'kind':kind},10)==10,'Normal enemy damage unchanged '+w.id+' '+str(i)+' '+kind)
		g.united.enabled=false;check(g.united.bosses.weapon_power(w,{'kind':'boss'},10)==10,'Historical combat fixture unchanged '+str(i));g.united.enabled=true
	for weapon in g.weapon_data:
		if weapon in ['orbit','tesla']:continue
		check(g.united.bosses.weapon_power({'id':weapon,'level':5},{'kind':'boss'},100)==100,'No hidden boss nerf '+weapon)
	# Real Sprengkern projectile retains its exact direct damage.
	start('docks',10);boss=g.enemies[0];boss.pos=g.player.position+Vector2(200,0);var health=boss.hp;g.weapons=[{'id':'blaster','level':5,'clock':0.0,'spec':'blast'}];g.update_weapons(.01);g.update_shots(.3)
	check(near(health-boss.hp,21.12),'Sprengkern direct hit is unchanged')
	# Endless stacks the existing cycle factor on fixed boss profiles.
	for wave in [12,14,16,18,20,22]:
		start('docks',wave,'normal','endless');var slot=((wave-1)%10)+1;var cycles=floori((wave-1)/10.0);check(near(g.enemies[0].max_hp,HP[slot]*1.16*(1+cycles*.35)),'Endless boss ladder scales coherently '+str(wave))
	# Every map's opener is deterministically tied to its arena pattern.
	for arena in R.ARENAS:
		start(arena,10);boss=g.enemies[0];check(g.united.bosses.attack_order(boss).size()==4,'Map-specific four-attack repertoire '+arena)
	g.saved=original;g.save_game();g.free();await process_frame;print('BOSS BALANCE RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
