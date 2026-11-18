extends SceneTree
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,name:String):
	if ok:passed+=1;print('PASS ',name)
	else:failed+=1;push_error('FAIL '+name)
func fresh(arena:String='scrapyard',wave:int=4):
	g.test_mode=true;g.selected=1;g.arena_id=arena;g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.start_run();g.wave_number=wave;g.begin_wave();g.cleanup();g.spawn_clock=999;g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll()
func spawn_elite(arena:String='scrapyard') -> Dictionary:
	fresh(arena);g.remaining=41.9;g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2(280,0);return e
func next_attack():
	g.encounters.recovery=0;g.encounters.boss_lock=false;g.encounters.special_clock=0;g.boss_charging=false;g.boss_phase=0;g.reactor_guardian.clear();g.encounters.hazards.clear();g.encounters.update(.01)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for arena in ['scrapyard','reactor']:
		for wave in range(1,11):
			fresh(arena,wave);g.remaining=30;g.spawn_enemy('grunt')
			check(g.enemies.back().has('elite')==(wave in [4,6,8,9]),'Elite schedule '+arena+' wave '+str(wave))
	var e=spawn_elite()
	check(e.kind=='tank' and e.elite=='ram' and e.max_hp>g.enemy_data.tank.hp,'Real promoted elite uses heavy stats and arena identity')
	check(g.enemies.size()==1,'Promotion replaces one normal enemy without an extra node')
	g.spawn_enemy('grunt');check(not g.enemies.back().has('elite'),'Only one promotion per wave')
	fresh();g.remaining=42.1;g.spawn_enemy('grunt');check(not g.enemies.back().has('elite'),'No elite before eighteen elapsed seconds')
	e=spawn_elite();e.elite_clock=0;var hp=g.hp
	check(g.encounters.movement(e,Vector2.LEFT,.01)==Vector2.ZERO and e.elite_stage=='windup','Ram stops and begins full warning')
	var locked=e.elite_target;check(e.elite_clock==1.2 and g.hp==hp,'Warning begins at full duration without special damage')
	g.player.position+=Vector2(0,180);g.encounters.movement(e,Vector2.LEFT,.6)
	check(e.elite_target==locked and e.pos==e.elite_origin,'Ram target and origin remain locked after player moves')
	g.encounters.movement(e,Vector2.LEFT,.7);check(e.elite_stage=='dash','Ram enters dash only after windup')
	g.player.position=Vector2(1200,800);g.hurt_clock=0
	var ram_from:Vector2=e.pos;g.update_enemies(1);var velocity:Vector2=e.pos-ram_from
	check(g.hp<hp and velocity.length()<=460.1,'Ram swept collision hits once even over a long frame')
	var damaged=g.hp;g.update_enemies(1);check(g.hp==damaged,'Shared hurt cooldown prevents duplicate dash damage')
	e=spawn_elite();e.elite_stage='dash';e.elite_target=g.player.position;e.ability_slow_time=5.0;e.ability_slow=.25;hp=g.hp;g.update_enemies(1)
	check(g.hp==hp and e.pos.distance_to(g.player.position)>e.radius+27,'Slowed ram damages only along actual travelled segment')
	e=spawn_elite();e.elite_clock=0;g.encounters.movement(e,Vector2.LEFT,5)
	check(e.elite_clock==1.2 and e.elite_stage=='windup','Long acquisition frame does not skip telegraph')
	e.pos+=Vector2(0,30);g.encounters.movement(e,Vector2.LEFT,.1)
	check(e.elite_stage=='idle' and e.elite_clock==1.5,'Knockback cancels a locked warning')
	e=spawn_elite();e.pos=Vector2(150,150);g.player.position=Vector2(400,250);g.camera.reset_smoothing();g.camera.force_update_scroll()
	e.elite_clock=0;g.encounters.movement(e,Vector2.LEFT,.01);g.player.position=Vector2(2350,1500);g.camera.reset_smoothing();g.camera.force_update_scroll()
	g.encounters.movement(e,Vector2.LEFT,2);check(not g.encounters.visible(e.pos) and e.elite_stage=='idle','Offscreen elite cannot finish a special attack')
	for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
		e=spawn_elite();e.elite_clock=0;g.encounters.movement(e,Vector2.LEFT,.01);var old_clock=e.elite_clock
		g.state=state;var stopped=g.encounters.movement(e,Vector2.LEFT,1);g.encounters.update(1)
		check(e.elite_clock==old_clock and stopped==Vector2.ZERO,'Elite windup freezes outside combat '+str(state))
	e=spawn_elite();e.pos=g.player.position+Vector2(120,0);e.elite_clock=0;g.encounters.movement(e,Vector2.LEFT,.01)
	g.selected=0;g.hero_ability.activate();g.encounters.movement(e,Vector2.LEFT,.01)
	check(e.elite_stage=='idle' and absf(e.elite_clock-1.49)<.001,'Actual Bruiser shockwave cancels elite windup')
	e=spawn_elite();e.pos=Vector2(35,800);e.elite_origin=e.pos;e.elite_stage='windup';e.elite_clock=1.2;g.player.position=Vector2(140,800);g.selected=0;g.hero_ability.activate()
	check(e.elite_stage=='idle' and e.elite_clock==1.5,'Shockwave interruption works even against arena wall')
	e=spawn_elite('reactor');g.selected=2;g.hero_ability.activate();g.encounters.add_circle(g.player.position,70,0,50);hp=g.hp;g.encounters.update(.01)
	check(g.hp==hp,'Shade dash retains invulnerability against new encounter hazards')
	e=spawn_elite('reactor');e.elite_clock=0;g.encounters.movement(e,Vector2.LEFT,.01)
	check(e.elite=='pulse' and e.elite_stage=='windup','Reactor has its own pulse archetype')
	var ring_origin=e.elite_origin;g.encounters.movement(e,Vector2.LEFT,1.5)
	check(g.encounters.hazards.size()==1,'Pulse creates one bounded ring after warning')
	var h=g.encounters.hazards[0];var safe=ring_origin+Vector2.from_angle(h.angle)*h.radius;var danger=ring_origin+Vector2.from_angle(h.angle+PI)*h.radius
	check(not g.encounters.contains(h,safe) and g.encounters.contains(h,danger),'Visible ring opening and danger arc match hit geometry')
	check(not g.encounters.contains(h,ring_origin) and not g.encounters.contains(h,ring_origin+Vector2(500,0)),'Inner and outer ring zones are safe')
	g.player.position=safe;hp=g.hp;g.encounters.update(.01);check(g.hp==hp,'Standing in actual gap receives no pulse damage')
	g.player.position=danger;g.hurt_clock=0;g.encounters.update(.01);check(g.hp<hp,'Actual closed ring arc applies damage')
	g.damage_enemy(e,100000);check(g.encounters.hazards.is_empty(),'Killing elite cancels its active ring')
	check(g.encounters.elite_kills==1 and g.encounters.rewards.size()==1,'Real death queues exactly one cache')
	g.encounters.removed(e);g.damage_enemy(e,100000);check(g.encounters.rewards.size()==1 and g.encounters.elite_kills==1,'Repeated death cannot duplicate cache or elite count')
	var coins=g.coins;check(coins>=int(g.encounters.data.elite_extra_coins) and g.loot.back().xp>=12,'Elite grants actual extra coins and XP crystal')
	var id=g.encounters.rewards[0].id;g.cleanup();g.open_shop()
	check(g.state==g.State.SHOP and g.encounters.rewards[0].id==id,'Wave cleanup preserves cache for connected shop')
	var wave=g.wave_number;g.next_shop_wave();check(g.wave_number==wave,'Cannot bypass reward by starting next wave')
	check(not g.buy_offer(0) and not g.reroll_shop() and not g.run_items.upgrade('blaster'),'Underlying shop actions blocked while reward is pending')
	coins=g.coins;var earned=g.earned
	check(g.encounters.claim(id,'coins') and g.coins==coins+28 and g.earned==earned+28,'Cache coin choice affects spendable and lifetime run earnings')
	check(not g.encounters.claim(id,'damage') and g.encounters.rewards.is_empty(),'Stale reward callback cannot claim a second option')
	g.next_shop_wave();check(g.wave_number==wave+1,'Reward returns to real market and next wave')
	e=spawn_elite();g.damage_enemy(e,100000);id=g.encounters.rewards[0].id;g.cleanup();g.weapons[0].level=5;g.open_shop()
	g.encounters.claim(id,'damage');check(not g.pending_specialization().is_empty(),'Cache correctly hands off to mandatory weapon evolution')
	check(g.choose_specialization('blaster',g.Specs.choices('blaster')[0]) and g.encounters.rewards.is_empty(),'Evolution returns to market after elite cache')
	for choice in ['damage','vital']:
		e=spawn_elite();g.damage_enemy(e,100000);id=g.encounters.rewards[0].id;g.cleanup();g.open_shop()
		var power=g.damage_mult;var max_hp=g.max_hp;hp=g.hp
		check(g.encounters.claim(id,choice),'Cache choice '+choice)
		check(is_equal_approx(g.damage_mult,power+.05) if choice=='damage' else (g.max_hp==max_hp+10 and g.hp==hp+10),'Choice effect applied '+choice)
		g.run_items.sync();check(g.damage_mult>=power,'Item synchronization retains elite bonus')
	e=spawn_elite();g.damage_enemy(e,100000);id=g.encounters.rewards[0].id;g.start_run()
	check(g.encounters.rewards.is_empty() and g.encounters.elite_kills==0,'Restart resets rewards, encounter count and tier')
	e=spawn_elite();g.damage_enemy(e,100000);g.cleanup();g.open_shop();check(not g.encounters.claim(id,'coins'),'Cache identifiers cannot be reused across runs')
	for index in range(3):
		e=spawn_elite();g.damage_enemy(e,100000);g.cleanup();g.open_shop()
		var choices=[]
		for child in g.ui_root.get_children():
			if child is Button and child.text=='BEUTE SICHERN':choices.append(child)
		var old_damage=g.damage_mult;var old_hp=g.max_hp;var old_coins=g.coins
		choices[index].pressed.emit()
		var correct=(is_equal_approx(g.damage_mult,old_damage+.05) if index==0 else (g.max_hp==old_hp+10 if index==1 else g.coins==old_coins+28))
		var snapshot=[g.damage_mult,g.max_hp,g.coins];choices[index].pressed.emit()
		check(correct and snapshot==[g.damage_mult,g.max_hp,g.coins] and g.encounters.rewards.is_empty(),'Actual cache button chooses correct effect once '+str(index))
	for arena in ['scrapyard','reactor']:
		fresh(arena,10);g.spawn_enemy('boss');var boss=g.enemies.back();boss.pos=g.player.position+Vector2(260,0)
		g.encounters.update(.1);check(g.encounters.boss_tier==1 and not g.encounters.boss_lock,'Opening boss retains base behavior '+arena)
		g.shoot(boss.pos,Vector2.LEFT,10,true,100,2);g.shoot(g.player.position,Vector2.RIGHT,10,false,100,2)
		boss.hp=boss.max_hp*.64;g.encounters.update(4)
		check(g.encounters.boss_tier==2 and g.encounters.boss_lock and g.encounters.recovery==1.25,'Phase two begins with full recovery after long frame '+arena)
		check(g.shots.filter(func(s):return s.active and s.hostile).is_empty() and g.shots.filter(func(s):return s.active and not s.hostile).size()==1,'Transition clears hostile but retains friendly shots '+arena)
		var clock=g.encounters.recovery;g.pause_game();g.encounters.update(2);check(g.encounters.recovery==clock,'Pause freezes new phase '+arena);g.resume()
		g.encounters.update(1.3);g.encounters.update(.01)
		check(g.encounters.hazards.size()==(2 if arena=='reactor' else 3),'Phase two creates arena-specific actual attack '+arena)
		g.encounters.hazards.clear();g.encounters.boss_lock=false;g.encounters.recovery=0;g.encounters.special_clock=0;g.encounters.first_special=false
		if arena=='reactor':g.reactor_guardian.pattern=2;g.reactor_guardian.stage='recovery'
		else:g.boss_phase=2;g.boss_clock=.1;g.boss_charging=false
		g.encounters.update(.01)
		check(g.reactor_guardian.pattern==2 if arena=='reactor' else g.boss_phase==2,'Special preserves existing boss attack cursor '+arena)
		h=g.encounters.hazards[0];check(h.age==0 and h.warm>=1.5,'New boss attack retains full readable warning '+arena)
		g.player.position=Vector2(100,100);g.encounters.update(3)
		check(g.encounters.hazards.is_empty(),'Boss patterns expire after long frames '+arena)
		boss.hp=boss.max_hp*.29;g.encounters.update(.01);check(g.encounters.boss_tier==3,'Phase three threshold '+arena)
		g.encounters.update(1.3);g.encounters.update(.01)
		check(g.encounters.hazards.size()==1 and g.encounters.hazards[0].shape=='ring','Third phase introduces open impulse ring '+arena)
		h=g.encounters.hazards[0];safe=h.origin+Vector2.from_angle(h.angle)*h.radius;check(not g.encounters.contains(h,safe),'Boss ring has real escape opening '+arena)
		boss.hp=boss.max_hp*.8;g.encounters.update(.01);check(g.encounters.boss_tier==3,'Boss does not regress phases '+arena)
		var age=h.age;g.state=g.State.LEVEL_UP;g.encounters.update(1);check(h.age==age,'Level-up freezes new hazards '+arena)
		g.state=g.State.COMBAT;g.damage_enemy(boss,100000)
		check(g.state==g.State.VICTORY and g.encounters.hazards.is_empty() and g.encounters.rewards.is_empty(),'Victory cleans every new combat object '+arena)
		fresh(arena,10);g.spawn_enemy('boss');boss=g.enemies.back();boss.pos=g.player.position+Vector2(260,0);boss.hp=boss.max_hp*.2;g.encounters.update(.01)
		check(g.encounters.boss_tier==3,'Large damage can skip directly to phase three '+arena)
		g.finish(false);check(g.encounters.hazards.is_empty() and not g.encounters.boss_lock,'Loss cleans encounter state '+arena)
	for arena in ['scrapyard','reactor']:
		fresh(arena,10);g.spawn_enemy('boss');var boss=g.enemies.back();boss.pos=g.player.position+Vector2(260,0);boss.hp=boss.max_hp*.2;g.encounters.update(.01)
		g.encounters.add_circle(g.player.position,60,0,100);g.hp=1;g.hurt_clock=0;g.encounters.update(.01)
		check(g.state==g.State.GAME_OVER and g.encounters.hazards.is_empty(),'Lethal new hazard cleans during iteration '+arena)
	check(g.RunRecords.clean_run({'character':'sparky','elite_kills':4}).elite_kills==4,'Run record persists elite kills compatibly')
	g.queue_free();await process_frame;OS.delay_msec(180);await process_frame
	print('ENCOUNTERS RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
