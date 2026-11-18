extends SceneTree
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(value:bool,text:String):
	if value:passed+=1;print('PASS ',text)
	else:failed+=1;push_error('FAIL '+text)
func near(a:float,b:float) -> bool:return absf(a-b)<.02
func fresh(hero:int=0,arena:String='scrapyard',wave:int=5,mode:String='campaign') -> Dictionary:
	g.breaker.enabled=true;g.selected=hero;g.arena_id=arena;g.run_mode=mode;g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0;g.armor=0
	g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll()
	for w in g.weapons:w.clock=999
	var e:Dictionary=g.breaker.actor()
	if not e.is_empty():e.pos=g.player.position+Vector2(250,0)
	return e
func choose_levels():
	var limit=0
	while g.state==g.State.LEVEL_UP and limit<20:
		var buttons=g.ui_root.get_children().filter(func(n):return n is Button and n.text=='WÄHLEN')
		check(buttons.size()==3,'Three real upgrade choices after boss XP')
		if buttons.is_empty():break
		buttons[0].pressed.emit();limit+=1
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	var original=g.saved.duplicate(true);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for arena in g.Arenas.IDS:
		g.arena_id=arena
		for mode in ['campaign','endless']:
			g.run_mode=mode
			for wave in range(1,21):
				g.wave_number=wave
				check(g.breaker.scheduled()==(wave%10==5),'Axel schedule '+arena+' '+mode+' '+str(wave))
	var e=fresh()
	check(g.state==g.State.COMBAT and g.rules.boss_wave() and not g.rules.final_boss_wave(),'Actual midboss wave starts combat independently of final boss')
	check(g.enemies.size()==1 and e.hp==1500 and e.damage==18 and e.speed==78,'Actual uninflated midboss base stats')
	check(g.remaining==75 and g.rules.current_wave().interval==1.8,'Dedicated seventy-five second boss wave and lighter adds')
	check(not g.spawn_enemy('breaker_axel') and g.enemies.size()==1,'Duplicate boss spawn refused')
	var hp:float=e.hp;g.damage_enemy(e,100);check(near(hp-e.hp,85),'Fifteen percent resistance on actual damage path')
	g.refresh_hud();check(g.boss_hud.text.contains('BREAKER AXEL'),'Own boss HUD identity')
	g.prepare_wave();check(g.ui_root.get_children().any(func(n):return n is Button and n.text=='DER BODEN BEBT – LOS!'),'Own illustrated preparation screen and functional start CTA')
	g.begin_wave();check(g.breaker.actor().size()>0,'Preparation CTA leads to real spawn')
	for arena in g.Arenas.IDS:
		e=fresh(0,arena)
		check(e.max_hp==1500,'Same boss health in '+arena)
		g.spawn_enemy('drone');var drone=g.enemies.back();drone.pos=e.pos;check(g.enemy_roles.damage_factor(e)==1,'Boss immune to drone shielding in '+arena)
	e=fresh();g.breaker.begin_attack('ring',e);var clock:float=g.breaker.clock;var origin:Vector2=g.breaker.origin
	g.player.position+=Vector2(0,160);g.breaker.update(.5)
	check(g.breaker.stage=='windup' and g.breaker.origin==origin and near(g.breaker.clock,clock-.5),'Warning locked while player dodges')
	check(g.breaker.rings.is_empty(),'No damage ring during warning')
	g.breaker.update(.8);check(g.breaker.rings.size()==1 and g.breaker.stage=='recovery','Ring released only after full warning')
	e=fresh();g.breaker.begin_attack('ring',e);g.breaker.update(1.3);hp=g.hp;g.hurt_clock=0;g.breaker.update_hazards(.8)
	check(near(hp-g.hp,19) and g.breaker.push_velocity.length()>0 and g.breaker.stagger_left>0,'Swept radial wave deals damage and control feedback')
	hp=g.hp;g.hurt_clock=0;g.breaker.update_hazards(.1);check(g.hp==hp,'One wave never damages twice')
	e=fresh();g.breaker.begin_attack('ring',e);g.breaker.update(1.3);g.player.position=e.pos+Vector2(500,0);hp=g.hp;g.breaker.update_hazards(3)
	check(g.hp==hp and g.breaker.rings.is_empty(),'Escaping maximum shock radius avoids long-frame damage')
	e=fresh();g.breaker.begin_attack('hammer',e);g.player.position=g.breaker.target;hp=g.hp;g.hurt_clock=0;g.breaker.update(1.3)
	check(near(hp-g.hp,15) and g.breaker.beats==2,'First hammer strike after warning')
	g.player.position+=Vector2(600,0);hp=g.hp
	g.breaker.update(.8);g.breaker.update(.8)
	check(g.hp==hp and g.breaker.stage=='recovery' and g.breaker.cracks.size()==1,'Three hammer beats, dodge and delayed crack')
	g.player.position=g.breaker.cracks[0].a.lerp(g.breaker.cracks[0].b,.6);g.hurt_clock=0
	g.breaker.update_hazards(.5);check(g.hp==hp,'Crack first has a visible safe warning')
	g.breaker.update_hazards(.5);check(g.hp<hp and g.breaker.slow_left>0,'Live crack damages and slows')
	g.breaker.update_hazards(4);check(g.breaker.cracks.is_empty(),'Cracks expire reliably')
	e=fresh();g.breaker.begin_attack('charge',e);var target:Vector2=g.breaker.target;g.breaker.update(1.3)
	check(g.breaker.stage=='dash','Charge starts after warning')
	hp=g.hp;g.hurt_clock=0;g.update_enemies(1)
	check(near(hp-g.hp,24) and g.breaker.stage=='recovery' and e.pos.distance_to(target)<1,'Swept charge collision on actual final movement segment')
	hp=g.hp;g.hurt_clock=0;g.breaker.after_move(e,origin,e.pos);check(g.hp==hp,'Finished charge cannot hit twice')
	e=fresh();g.breaker.begin_attack('charge',e);g.breaker.update(1.3);e.ability_slow=.25;e.ability_slow_time=2;hp=g.hp;var before:Vector2=e.pos;g.update_enemies(.5)
	check(near(before.distance_to(e.pos),55) and g.hp==hp,'Frost changes actual dash distance and collision')
	e=fresh();g.breaker.begin_attack('charge',e);g.breaker.update(1.3);g.player.position+=Vector2(0,250);hp=g.hp;g.update_enemies(1)
	check(g.hp==hp,'Sidestep avoids announced charge')
	e=fresh();e.hp=e.max_hp*.7;g.breaker.update(.01);check(g.breaker.tier==2 and g.breaker.stage=='phase','Phase two at seventy percent')
	e.hp=e.max_hp*.4;g.breaker.update(.01);check(g.breaker.tier==3 and g.breaker.stage=='phase','Rage at forty percent')
	check(near(g.breaker.velocity(e,Vector2.RIGHT,1).length(),0),'Phase transition recovery is stationary')
	g.breaker.begin_attack('hammer',e);g.player.position=Vector2(1200,400);g.breaker.update(1.3)
	check(g.breaker.beats==4 and g.breaker.data.windup==1.25,'Rage has five hammer strikes without shortening warning')
	g.breaker.recover();check(near(g.breaker.velocity(e,Vector2.RIGHT,1).length(),1.28),'Rage movement multiplier')
	e=fresh();g.breaker.tier=2;g.breaker.begin_attack('charge',e);g.breaker.update(1.3);g.player.position+=Vector2(0,250);g.update_enemies(1)
	check(g.breaker.combo,'Phase two charge queues follow-up')
	g.breaker.update(.8);check(g.breaker.stage=='windup' and g.breaker.attack=='ring' and near(g.breaker.clock,1.25),'Combo ring has its own full warning')
	e=fresh(5);g.breaker.begin_attack('hammer',e);e.steel_stun=2;clock=g.breaker.clock;g.breaker.update(.5)
	check(g.breaker.clock==clock,'Steelfist stun freezes boss attack clock')
	g.update_enemies(.5);check(near(e.steel_stun,1.5),'Stun still expires through enemy update')
	e.steel_stun=0;e.pos+=Vector2(0,15);g.breaker.update(.1);check(g.breaker.stage=='recovery','Displacing locked origin cancels attack')
	e=fresh(3);g.twinkle.apply_stun(e,1);check(not e.has('suds_stun'),'Boss resists ordinary soap stun like final bosses')
	e=fresh(0);e.pos=g.player.position+Vector2(120,0);before=e.pos;g.hero_ability.activate();check(e.pos==before,'Bruiser knockback respects tank boss immunity')
	e=fresh(2);g.breaker.begin_attack('charge',e);g.breaker.update(1.3);hp=g.hp;g.hero_ability.activate();g.update_enemies(1)
	check(g.hp==hp and g.breaker.stagger_left==0,'Invulnerable hero gets no damage or crowd control')
	for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
		e=fresh();g.breaker.begin_attack('hammer',e);g.breaker.add_crack(e.pos,g.player.position,9);clock=g.breaker.clock;before=e.pos;g.state=state;g._physics_process(2);g.breaker.update(2)
		check(g.breaker.clock==clock and e.pos==before and g.breaker.cracks[0].age==0,'Boss and hazards freeze in state '+str(state))
	e=fresh();g.breaker.begin_attack('charge',e);e.pos=Vector2(100,100);g.breaker.update(.1)
	check(g.breaker.stage=='recovery','Offscreen or displaced attack release cancelled')
	e=fresh();g.breaker.clock=0;e.pos=Vector2(100,100);g.breaker.update(1)
	check(g.breaker.stage=='chase','No unseen warning starts')
	e=fresh();var coins:int=g.coins;var kills:int=g.kills;var completed:int=g.run_waves;var games:int=g.saved.games
	g.breaker.add_crack(e.pos,g.player.position,9);g.shoot(e.pos,Vector2.LEFT,1,true,100,10);g.damage_enemy(e,100000)
	check(g.coins==coins+125 and g.kills==kills+1 and g.run_waves==completed+1,'Single exact midboss reward and completed wave')
	check(g.state==g.State.LEVEL_UP and g.axel_shop_pending and g.level==2,'Boss XP retained and queued level processed before shop')
	check(g.enemies.is_empty() and g.breaker.cracks.is_empty() and not g.shots.any(func(s):return s.active),'Boss death removes enemies, hazards and projectiles')
	g.damage_enemy(e,100000);check(g.coins==coins+125 and g.kills==kills+1,'Repeated death never grants double loot')
	choose_levels();check(g.state==g.State.SHOP and not g.axel_shop_pending and g.saved.games==games,'After all upgrades shop opens without prematurely ending run')
	g.next_shop_wave();check(g.wave_number==6 and g.state==g.State.WAVE_PREPARATION,'Shop advances to wave six')
	e=fresh();g.remaining=.001;g._physics_process(.02);check(g.state==g.State.GAME_OVER and g.enemies.is_empty(),'Surviving boss time limit is defeat, never automatic success')
	g.start_run();check(g.breaker.cracks.is_empty() and g.breaker.rings.is_empty() and g.breaker.stagger_left==0 and not g.axel_shop_pending,'New run clears every boss state')
	e=fresh(0,'scrapyard',15,'endless');check(near(e.max_hp,2025),'Endless Axel scales at wave fifteen')
	g.damage_enemy(e,100000);choose_levels();check(g.state==g.State.SHOP,'Endless midboss ends in shop')
	g.next_shop_wave();check(g.wave_number==16,'Endless continues after midboss')
	fresh(0,'scrapyard',10);var final_boss=g.enemies[0];check(final_boss.kind=='boss','Original final boss still spawns at ten')
	g.damage_enemy(final_boss,100000);check(g.state==g.State.VICTORY,'Original final boss still awards campaign victory')
	g.run_mode='tutorial';g.wave_number=5;check(not g.breaker.scheduled(),'Tutorial never schedules Axel')
	check(not g.spawn_enemy('breaker_axel'),'Out-of-schedule spawn refused')
	g.run_mode='campaign';g.breaker.enabled=false;check(not g.breaker.scheduled(),'Explicit historical test fixture can retain old schedule')
	check(g.GameStateMachine.permits(g.State.LEVEL_UP,g.State.SHOP),'State machine permits earned shop continuation')
	check(g.breaker.ART.get_width()==1024,'Dedicated nonempty boss texture')
	for cue in ['warning','slam','drill','charge','rage','defeat']:check(g.audio_director.stream('axel_'+cue) is AudioStreamWAV,'Original audio '+cue)
	e=fresh();g.run_difficulty='mayhem';e.damage=float(g.breaker.data.damage)*g.Difficulty.definition('mayhem').damage;e.pos=g.player.position+Vector2(40,0);g.hp=500;g.max_hp=500;hp=g.hp;g.update_enemies(.01)
	check(near(hp-g.hp,e.damage) and g.breaker.push_velocity.length()>0,'Contact scales damage once and knocks back')
	e=fresh();g.hurt_clock=.5;hp=g.hp;g.breaker.hit(20,e.pos);check(g.hp==hp and g.breaker.stagger_left==0,'Damage grace also prevents crowd control')
	e=fresh();g.breaker.stagger_left=.2;g.breaker.slow_left=.8;g.breaker.push_velocity=Vector2(100,0);g.state=g.State.PAUSED;g._physics_process(1)
	check(g.breaker.stagger_left==.2 and g.breaker.slow_left==.8 and g.breaker.push_velocity==Vector2(100,0),'Player control feedback also freezes on pause')
	for i in range(20):g.breaker.add_crack(Vector2.ZERO,Vector2(200,0),1)
	check(g.breaker.cracks.size()==6,'Crack storage has hard gameplay-independent cap')
	var baseline={}
	for quality in ['LOW','MEDIUM','HIGH']:
		e=fresh();g.saved.settings.quality=quality;g.rng.seed=190;g.hp=10000;g.max_hp=10000
		for i in range(300):g.move_input=Vector2.ZERO;g._physics_process(1.0/60)
		var snapshot={'hp':g.hp,'pos':g.player.position,'boss':e.pos,'phase':g.breaker.stage,'clock':g.breaker.clock,'rng':g.rng.state}
		if baseline.is_empty():baseline=snapshot
		else:check(snapshot==baseline,'Graphics quality preserves exact boss simulation '+quality)
	g.saved=original;g.save_game();g.queue_free();await process_frame
	print('BREAKER AXEL RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
