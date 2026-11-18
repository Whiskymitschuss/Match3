extends SceneTree
const R=preload('res://scripts/core/roster.gd')
const Art=preload('res://scripts/expansion/comic_art.gd')
const S=preload('res://scripts/autoload/save_manager.gd')
const C=preload('res://scripts/progression/collection.gd')
const W=preload('res://scripts/progression/world_progress.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(value:bool,what:String):
	if value:passed+=1;print('PASS ',what)
	else:failed+=1;push_error('FAIL '+what)
func start(hero:int=0,arena:String='scrapyard',wave:int=1):
	g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode='campaign';g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0;g.armor=0;g.hurt_clock=0
func dummy(id:String='grunt',offset:Vector2=Vector2(100,0)) -> Dictionary:
	g.spawn_enemy(id);var e:Dictionary=g.enemies.back();e.pos=g.player.position+offset;e.hp=100000;e.max_hp=e.hp;return e
func settle():
	var guard=0
	while g.state==g.State.LEVEL_UP and guard<100:g.apply_upgrade('damage');g.if_more_levels();guard+=1
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	var original=g.saved.duplicate(true);g.saved=S.defaults();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.garage.save_path='user://united_test.json';g.world_map.save_path='user://united_test.json'
	check(g.united.enabled and g.characters.size()==11 and g.Arenas.IDS.size()==10,'Production expansion is enabled; eleven heroes, ten worlds')
	check(g.united.enemies.data.size()==10 and R.NEW_ENEMIES.all(func(id):return g.enemy_definition(id).hp>0),'Ten additional real enemy definitions')
	for id in R.HEROES:
		check(g.hero_ability.data.has(id) and C.ALLOWED[id].has(R.STARTERS[id]),'Hero ability and class weapon connected '+id)
		check(Art.hero(id).size.x>0 and g.saved.records.has(id) and g.saved.hero_styles.has(id),'Art, save and mastery exist '+id)
	for weapon in R.NEW_WEAPONS:
		check(g.Specs.choices(weapon).size()==2 and C.catalog().items.has(weapon),'Blueprint and two evolutions '+weapon)
		for spec in g.Specs.choices(weapon):check(g.Specs.icon(spec)!=null,'Unique development icon '+spec)
	check(C.catalog().items.flame.slot=='deco' and C.catalog().items.flamer.slot=='weapon','Existing flame decoration and new flamethrower have separate persistent ids')
	var fresh=S.defaults();check(fresh.collection.heroes==['bruiser'] and fresh.world_progress.unlocked==['scrapyard'],'Fresh start preserves intended hero/world locks')
	fresh.collection.tickets.crew=100
	for i in range(40):C.open_case(fresh,'crew');C.acknowledge(fresh,int(fresh.collection.pending.serial))
	check(R.HEROES.all(func(id):return fresh.collection.heroes.has(id)),'All eleven heroes obtainable from earned crew cases')
	# All ten maps through all ten actual waves, without legacy boss fixture.
	g.saved=S.defaults();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	for index in range(10):
		var arena:String=R.ARENAS[index]
		check(W.available(g.saved,arena),'Campaign opens world in order '+arena)
		start(index%11,arena)
		for wave in range(1,11):
			g.wave_number=wave;g.prepare_wave();g.begin_wave();g.crit=0;g.spawn_clock=999
			check(g.rules.boss_wave()==(wave%2==0),'Boss schedule '+arena+' '+str(wave))
			if wave%2==0:
				check(g.enemies.size()==1 and g.enemies[0].kind==('boss' if wave==10 else ('breaker_axel' if wave==6 else 'champion')),'Actual scheduled boss '+arena+' '+str(wave))
				var boss=g.enemies[0];check(boss.boss_art==(index+4 if wave==10 else {2:1,4:2,6:0,8:3}[wave]),'Correct unified boss portrait '+arena+' '+str(wave))
				var kills=g.kills;g.damage_enemy(boss,100000000);g.damage_enemy(boss,100000000);settle();check(g.kills==kills+1,'Boss reward cannot duplicate '+arena+' '+str(wave))
			else:g.remaining=.001;g._physics_process(.01)
			if wave<10:
				check(g.state==g.State.SHOP and g.offers.size()==4,'Real boss/normal wave reaches shop '+arena+' '+str(wave));g.next_shop_wave()
			else:check(g.state==g.State.VICTORY and g.saved.world_progress.cleared.has(arena),'Arena final victory recorded '+arena)
		check(W.claim(g.saved,arena) and not W.claim(g.saved,arena),'All first-clear gifts once only '+arena)
	check(g.saved.world_progress.cleared.size()==10 and W.next_world('void')=='','Ten-world campaign has complete end')
	# Every new base weapon and both evolved versions actually attack.
	preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	for hero in range(6,11):
		var weapon:String=g.characters[hero].weapon
		for spec in ['']+g.Specs.choices(weapon):
			start(hero,'scrapyard',3);var target=dummy();var w={'id':weapon,'level':5 if spec!='' else 1,'clock':0.0,'spec':spec};g.weapons=[w];g.update_weapons(.1)
			for t in range(100):g.update_shots(.016);g.united.heroes.update(.016)
			check(target.hp<target.max_hp,'Live weapon damage '+weapon+' '+spec)
			check(w.clock>0 and g.has_projectile_weapon()==(weapon in ['cryo','chakram']),'Cooldown and suitable upgrades '+weapon+' '+spec)
		start(hero,'scrapyard',3);var target=dummy();var hp=g.hp;g.hp=maxf(1,g.hp-10)
		check(g.hero_ability.activate() and g.hero_ability.cooldown>0 and not g.hero_ability.activate(),'Actual active ability and cooldown '+str(hero))
		match hero:
			6:g.united.heroes.update(.2);check(target.hp<target.max_hp and g.united.heroes.fire_clock>0,'Firestorm causes bounded tick damage')
			7:check(target.steel_stun==2 and target.hp<target.max_hp,'Freeze hits and stops normal enemies')
			8:check(g.united.heroes.rate()==1.4 and target.hp<target.max_hp,'Overcharge speeds attacks and chains')
			9:var before=g.hp;g.hurt(30);check(g.hp==before and g.united.heroes.shield==50,'Shield absorbs actual damage')
			10:check(g.united.heroes.decoy_time==4 and g.hero_ability.move_dash(.1),'Decoy and actual phase dash')
		var before=g.united.heroes.fire_clock+g.united.heroes.shield_time+g.united.heroes.overcharge+g.united.heroes.decoy_time;g.pause_game();g._physics_process(2)
		check(is_equal_approx(before,g.united.heroes.fire_clock+g.united.heroes.shield_time+g.united.heroes.overcharge+g.united.heroes.decoy_time),'New skill clocks freeze on pause '+str(hero));g.resume()
	for hero in range(11):
		start(hero,'scrapyard',3);check(g.combat_visuals.hand_positions().size()==2 and g.combat_visuals.shoulder_positions().size()==2,'Exactly two hands on shared rig '+R.HEROES[hero])
	for id in ['united_flame','united_cryo','united_tesla','united_lance','united_chakram','united_warning','united_rage','united_impact','united_pyro','ability_firestorm','ability_absolute_zero','ability_overcharge','ability_bastion','ability_phase_dance']:check(g.audio_director.cache.has(id) and g.audio_director.cache[id].get_length()>0,'Real cached original sound '+id)
	# Each new enemy attacks or protects with real data, bounded simultaneous/total spawning.
	for id in R.NEW_ENEMIES:
		start(0,'scrapyard',9);var e=dummy(id,Vector2(220,0));var hp=g.hp;e.u_clock=0
		var before=e.pos;g.update_enemies(.01);check(e.pos!=before or e.u_stage=='windup','New enemy AI '+id)
		if e.u_stage=='windup':
			check(g.hp==hp,'Enemy windup cannot deal immediate damage '+id);g.united.enemies.release(e)
		for i in range(30):g.spawn_enemy(id)
		check(g.united.enemies.count(id)<=int(g.united.enemies.data[id].cap),'Enemy per-type cap '+id)
		var kills=g.kills;g.damage_enemy(e,100000000);g.damage_enemy(e,100000000);check(g.kills==kills+1,'New enemy death and reward once '+id)
	# Hazard geometry, stun, shield, owner cleanup and warning windows.
	start(0,'scrapyard',3);var at=g.player.position;g.united.enemies.circle(at,100,1.5,.4,10);var hp=g.hp;g.united.update(1.4);check(g.hp==hp,'Visible hazard gives full warning time');g.united.update(.11);check(g.hp<hp,'Hazard deals damage after warning')
	g.united.enemies.clear();g.united.enemies.ring(at,200,0,1.5,10,{})
	var h=g.united.enemies.hazards[0];check(not g.united.enemies.contains(h,at+Vector2(200,0)) and g.united.enemies.contains(h,at+Vector2(-200,0)),'Green ring gap matches collision')
	for i in range(40):g.united.enemies.circle(at,80,2,.4,10)
	check(g.united.enemies.hazards.size()==12,'Danger field count bounded independently of visual quality')
	for wave in [2,4,8,10]:
		start(0,'void',wave);var boss=g.enemies[0];boss.pos=at+Vector2(220,0);g.united.bosses.clock=0;g.united.update(.01)
		check(g.united.bosses.stage=='windup' and g.united.bosses.clock==1.5,'Boss starts full warning '+str(wave))
		boss.hp=boss.max_hp*.3;g.united.update(.01);check(g.united.bosses.stage=='windup' and g.united.bosses.tier==1,'Threshold damage preserves locked boss warning '+str(wave));g.united.bosses.stage='recovery';g.united.update(.01);check(g.united.bosses.tier==3 and g.united.bosses.stage=='phase','Boss rage enters readable transition '+str(wave))
		g.pause_game();var clock=g.united.bosses.clock;g._physics_process(3);check(g.united.bosses.clock==clock,'Boss pause freezes phase '+str(wave));g.resume()
	# Pool metadata must not leak across old and new projectile types.
	start();var shot=g.shoot(at,Vector2.RIGHT,1,false,600,1,'cryo');shot.united=true;shot.united_hits=[{}];shot.active=false
	var reused=g.shoot(at,Vector2.RIGHT,1,false,600,1,'blaster');check(not reused.get('united',false) and not reused.has('united_hits'),'Pooled projectile resets previous weapon hit history')
	# Six new world events actually create danger then reward survival.
	for arena in R.ARENAS.slice(4):
		start(0,arena,3);g.remaining=30;g.arena_events.update(.01);check(not g.united.enemies.hazards.is_empty(),'Arena event is functional '+arena)
		g.arena_events.update(9);check(g.run_events==1,'Arena event survival tracked '+arena)
	# Actual role effects and per-target projectile semantics.
	start(0,'scrapyard',9);var medic=dummy('medic');var patient=dummy('grunt',Vector2(130,0));patient.hp=50000;g.united.enemies.release(medic);check(patient.hp==66000,'Medic restores sixteen percent without exceeding max health')
	var shieldbug=dummy('shieldbug');shieldbug.u_face=shieldbug.pos.direction_to(g.player.position);check(g.united.enemies.factor(shieldbug)==.65,'Shield bug protects its facing');shieldbug.u_face=-shieldbug.u_face;check(g.united.enemies.factor(shieldbug)==1,'Shield bug can be flanked')
	var pyro=dummy('pyro');g.projectile_pool.clear();g.united.enemies.release(pyro);check(g.shots.filter(func(s):return s.active and s.hostile).size()==8,'Pyro launches eight bounded hostile projectiles')
	var summoner=dummy('summoner',Vector2(400,0))
	for i in range(10):g.united.enemies.release(summoner)
	check(summoner.u_spawned==6,'Summoner has a hard lifetime quota')
	var leech=dummy('leech');leech.hp=50000;var before=g.hp;g.hurt_clock=0;g.hurt(10);g.united.enemies.contact(leech,before);check(leech.hp==50007,'Leech heals only actual HP damage')
	start(7,'scrapyard',3);var ice_target=dummy();var ice_weapon={'id':'cryo','level':5,'clock':0.0,'spec':'ice_lance'};g.united.heroes.attack(ice_weapon,.1);var ice_shot=g.shots[0];ice_shot.pos=ice_target.pos;var before_hp=ice_target.hp;g.united.heroes.projectile(ice_shot,ice_target.pos,.01);var once=ice_target.hp;g.united.heroes.projectile(ice_shot,ice_target.pos,.01);check(once<before_hp and ice_target.hp==once,'Piercing ice cannot hit the same enemy twice');check(ice_target.ability_slow_time>1.5,'Frosty passive extends actual slow duration')
	# Quality settings affect presentation only; all new combat draws are RNG-free.
	var powers=[]
	for quality in ['LOW','MEDIUM','HIGH']:g.saved.settings.quality=quality;powers.append(g.united.heroes.power(ice_weapon))
	check(powers[0]==powers[1] and powers[1]==powers[2],'Graphics quality preserves new weapon damage')
	# Full current UI routes render all pages and preserve state.
	g.main_menu()
	for section in ['rules','heroes','enemies','tech']:
		for page in range(11 if section=='heroes' else (33 if section=='enemies' else 1)):g.game_guide.show(section,page)
		check(g.state==g.State.MAIN_MENU,'Guide pages keep valid state '+section)
	for i in range(11):g.character_select(i)
	for i in range(10):g.arena_select(i)
	check(g.ui_root.get_children().filter(func(n):return str(n.name).begins_with('WorldCard_')).size()==10,'All ten world cards connected')
	g.main_menu();g.statistics();g.mastery_screen(1);g.endless_statistics(2);g.difficulty_statistics('normal','campaign',2)
	# Actual old-shaped profile roundtrip retains wallet, unlocks and now adds new defaults.
	var old=S.defaults();old.meta.coins=321;old.collection.parts=91;old.collection.heroes=['bruiser','steelfist'];old.world_progress.cleared=['scrapyard','reactor','docks','foundry'];old.world_progress.unlocked=R.ARENAS.slice(0,4)
	S.save_local(old,'user://united_migration.json');var loaded=S.load_local('user://united_migration.json')
	check(loaded.meta.coins==321 and loaded.collection.parts==91 and loaded.collection.heroes.has('steelfist') and W.available(loaded,'gardens') and not W.available(loaded,'frost'),'Profile migration preserves progress and opens only earned next world')
	check(loaded.records.has('nyx') and loaded.arena_records.has('void') and not loaded.settings.show_fps,'Expanded save defaults survive reload')
	# Boss timeout, death, restart and endless ladder.
	start(0,'void',10);g.remaining=.001;g._physics_process(.02);check(g.state==g.State.GAME_OVER,'Final boss time limit causes defeat')
	start();g.hurt(1000000);check(g.state==g.State.GAME_OVER,'Player death causes defeat');start();check(g.state==g.State.COMBAT and g.hp==g.max_hp,'Restart safely clears previous combat')
	g.run_mode='endless';g.wave_number=12;g.begin_wave();check(g.rules.boss_wave() and g.enemies[0].kind=='champion','Endless repeats boss ladder after wave ten')
	# Full ten-wave transition path with the production state-machine guard enabled.
	g.main_menu();g.saved.settings.master=0;g.test_mode=false;g.character_select(0);g.selected=0;g.run_mode='campaign';g.arena_select(0);check(g.choose_arena('scrapyard') and g.state==g.State.WAVE_PREPARATION,'Production menu-to-run transition')
	for wave in range(1,11):
		g.begin_wave();g.crit=0
		if wave%2==0:g.damage_enemy(g.enemies[0],100000000);settle()
		else:g.remaining=.001;g._physics_process(.01)
		check(g.state==(g.State.VICTORY if wave==10 else g.State.SHOP),'Production guarded wave transition '+str(wave))
		if wave<10:g.next_shop_wave();check(g.state==g.State.WAVE_PREPARATION,'Production guarded shop continuation '+str(wave))
	g.test_mode=true
	g.saved=original;g.save_game();g.free();await process_frame
	print('UNITED RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
