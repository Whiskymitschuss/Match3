extends SceneTree
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,text:String):
	if ok:passed+=1;print('PASS ',text)
	else:failed+=1;push_error('FAIL '+text)
func near(a:float,b:float) -> bool:return absf(a-b)<.01
func fresh(arena:String='scrapyard',wave:int=5,hero:int=3):
	g.test_mode=true;g.selected=hero;g.arena_id=arena;g.saved.wins=1;g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll();g.crit=0
func spawn() -> Dictionary:
	g.spawn_enemy('ravox');var e=g.enemies.back();e.pos=g.player.position+Vector2(250,0);e.ravox_clock=0;return e
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	check(g.enemy_data.ravox.hp==140 and g.enemy_data.ravox.speed==220,'Reference base HP and speed')
	check(g.ravox.data.weapon=='ZERMALMER' and near(g.ravox.data.charge_bonus,1.15),'Crushing gauntlets and fifteen percent charge bonus')
	for arena in ['scrapyard','reactor']:
		for wave in range(1,11):
			fresh(arena,wave)
			check((g.ravox.select_kind('grunt',.95)=='ravox')==(wave>=5 and wave<=9),'Spawn schedule '+arena+str(wave))
	fresh();var e=spawn()
	check(e.max_hp>140 and e.speed>=220 and e.ravox_stage=='chase','Actual scaled spawn with initialized behavior')
	check(g.ravox.select_kind('grunt',.89)=='grunt','Unselected spawn roll preserves existing enemy')
	var count=g.enemies.size();g.spawn_enemy('ravox');check(g.enemies.size()==count+1,'Second Ravox allowed')
	check(not g.spawn_enemy('ravox') and g.enemies.size()==2 and g.ravox.select_kind('grunt',.95)=='grunt','Active cap of two falls back to ordinary spawn')
	for i in range(2):
		g.enemies.clear();check(g.spawn_enemy('ravox'),'Remaining wave quota '+str(i))
	g.enemies.clear();check(not g.spawn_enemy('ravox'),'Four-per-wave cap persists after enemies removed')
	g.cleanup();check(not g.spawn_enemy('ravox'),'Combat cleanup does not erase wave quota')
	g.start_run();g.wave_number=5;g.begin_wave();check(g.spawn_enemy('ravox'),'New run resets quota')
	fresh();e=spawn();var before:Vector2=e.pos
	check(g.ravox.velocity(e,Vector2.LEFT*220,5)==Vector2.ZERO and e.ravox_stage=='windup' and e.ravox_clock==1.25,'Long first frame starts full warning without consuming it')
	var target:Vector2=e.ravox_target;var hp:float=g.hp
	g.player.position+=Vector2(0,200);g.ravox.velocity(e,Vector2.LEFT,.6)
	check(e.ravox_target==target and e.pos==before and g.hp==hp,'Aim locked while player dodges')
	g.ravox.velocity(e,Vector2.LEFT,.7);check(e.ravox_stage=='dash','Charge only after full warning')
	g.player.position=Vector2(1200,800);g.hurt_clock=0;g.armor=0
	var damage:float=e.damage*1.15;g.update_enemies(1)
	check(near(hp-g.hp,damage) and e.ravox_stage=='recovery','Swept long-frame charge hits once at exact bonus')
	var hit_hp:float=g.hp;g.ravox.after_move(e,before,e.pos);check(g.hp==hit_hp,'Finished charge never deals duplicate damage')
	fresh();e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);g.ravox.velocity(e,Vector2.LEFT,2)
	g.player.position+=Vector2(0,200);hp=g.hp;g.update_enemies(1);check(g.hp==hp,'Stepping out of telegraph avoids charge')
	fresh();e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);g.ravox.velocity(e,Vector2.LEFT,2)
	e.ability_slow=.1;e.ability_slow_time=2;hp=g.hp;before=e.pos;g.update_enemies(.5)
	check(near(before.distance_to(e.pos),25) and g.hp==hp,'Collision uses actual slowed movement, never predicted full dash')
	fresh();e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);e.pos+=Vector2(0,20);g.ravox.velocity(e,Vector2.LEFT,.1)
	check(e.ravox_stage=='recovery','Knockback displacement cancels windup')
	fresh();e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);g.twinkle.apply_stun(e,1)
	check(e.ravox_stage=='recovery' and e.suds_stun==1,'Actual Twinkle soap cancels charge and stuns')
	fresh('scrapyard',5,0);e=spawn();e.pos=g.player.position+Vector2(150,0);g.ravox.velocity(e,Vector2.LEFT,.01);g.hero_ability.activate()
	check(e.ravox_stage=='recovery','Actual Bruiser shockwave interrupts Ravox')
	fresh();e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);g.hero_ability.activate();g.twinkle.update(.25)
	check(e.ravox_stage=='recovery','Tornado interrupts Ravox before knockback')
	fresh('scrapyard',5,2);e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);g.ravox.velocity(e,Vector2.LEFT,2);hp=g.hp;g.hero_ability.activate();g.update_enemies(1)
	check(g.hp==hp,'Shade invulnerable dash remains respected')
	for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
		fresh();e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);var clock:float=e.ravox_clock;before=e.pos;g.state=state;g._physics_process(2);g.ravox.velocity(e,Vector2.LEFT,2)
		check(e.ravox_clock==clock and e.pos==before,'Warning and motion freeze in '+str(state))
	fresh();e=spawn();e.pos=Vector2(100,100);g.player.position=Vector2(2300,1500);g.camera.reset_smoothing();g.camera.force_update_scroll();e.ravox_clock=0;g.ravox.velocity(e,Vector2.LEFT,2)
	check(e.ravox_stage=='chase','No offscreen warning starts')
	fresh();e=spawn();e.pos=Vector2(150,150);g.player.position=Vector2(400,250);g.camera.reset_smoothing();g.camera.force_update_scroll();g.ravox.velocity(e,Vector2.LEFT,.01);g.player.position=Vector2(2350,1500);g.camera.reset_smoothing();g.camera.force_update_scroll();g.ravox.velocity(e,Vector2.LEFT,2)
	check(e.ravox_stage!='dash','Moving camera away cancels unseen release')
	fresh();e=spawn();var coins=g.coins;var kills=g.kills;g.damage_enemy(e,100000);var reward=g.coins-coins
	g.damage_enemy(e,100000);check(reward>0 and g.kills==kills+1 and g.coins==coins+reward and g.loot.size()==1,'Death rewards exactly once')
	check(g.world_visuals.deaths[0].kind=='ravox','Own death animation keeps correct sprite identity')
	fresh();e=spawn();g.ravox.velocity(e,Vector2.LEFT,.01);g.hp=1;g.hurt_clock=0;g.hurt(100)
	check(g.state==g.State.GAME_OVER and g.enemies.is_empty(),'Death clears active warning and enemy')
	g.start_run();check(g.enemies.is_empty() and g.ravox.spawned.is_empty(),'Restart safe after Ravox encounter')
	g.saved=original;g.save_game();g.queue_free();await process_frame;quit(1 if failed else 0)
	print('RAVOX RESULT ',passed,' passed, ',failed,' failed')
