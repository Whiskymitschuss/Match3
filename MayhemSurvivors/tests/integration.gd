extends SceneTree
var g
var passed = 0
var failed = 0
func check(value: bool, name: String):
	if value: passed+=1; print('PASS ',name)
	else: failed+=1; push_error('FAIL '+name)
func _initialize():
	call_deferred('run')
func run():
	g = load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode = true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved = g.default_save()
	check(g.state==g.State.MAIN_MENU,'Boot -> main menu')
	check(g.GameStateMachine.permits(g.State.COMBAT,g.State.SHOP) and not g.GameStateMachine.permits(g.State.COMBAT,g.State.CHARACTER_SELECT),'Defined state transitions')
	g.character_select()
	check(g.state==g.State.CHARACTER_SELECT and g.characters.size()==4,'Character selection')
	for i in range(4):
		g.selected=i
		g.start_run()
		check(g.hp==g.characters[i].hp and g.speed==g.characters[i].speed and g.weapons[0].id==g.characters[i].weapon,'Character stats '+str(i))
	g.selected=1
	g.start_run()
	g.begin_wave()
	g.move_input=Vector2(1,1).normalized()
	var pos = g.player.position
	g._physics_process(.016)
	check(g.player.velocity.length()<=g.speed+.01 and g.player.position!=pos,'Analog diagonal movement')
	g.player.position=Vector2(2399,1599)
	g._physics_process(.016)
	check(g.player.position.x<=2355 and g.player.position.y<=1555,'Arena limits')
	g.player.position=Vector2(1200,800)
	g.cleanup()
	for kind in ['grunt','runner','tank']:
		g.spawn_enemy(kind)
		var e=g.enemies.back()
		check(e.pos.distance_to(g.player.position)>=450,'Safe spawn '+kind)
		var before=e.pos.distance_to(g.player.position)
		g.update_enemies(.1)
		check(e.pos.distance_to(g.player.position)<before,'Chase AI '+kind)
	g.cleanup()
	g.spawn_enemy('grunt')
	var e=g.enemies[0]
	e.pos=g.player.position+Vector2(100,0)
	g.update_weapons(1)
	check(g.shots.size()>0,'Automatic blaster attack')
	var health=e.hp
	for i in range(15):g.update_shots(.016)
	check(e.hp<health,'Swept projectile hit')
	var coins=g.coins
	g.damage_enemy(e,10000)
	var kills=g.kills
	g.damage_enemy(e,10000)
	check(g.kills==kills and kills==1 and g.coins>coins,'Death once and coin reward once')
	check(g.loot.size()==1,'XP crystal drop')
	g.loot[0].pos=g.player.position
	g.update_loot(.016)
	check(g.xp==5 and g.loot.is_empty(),'XP pickup')
	check(g.required_xp()==20,'XP formula level one')
	g.xp=100
	g.level_up()
	check(g.level==2 and g.state==g.State.LEVEL_UP,'Level up pauses combat')
	var clock=g.run_time
	g._physics_process(1)
	check(g.run_time==clock,'Level-up freezes time')
	var old_level=g.level
	while g.xp>=g.required_xp():g.if_more_levels()
	g.if_more_levels()
	check(g.level>old_level and g.state==g.State.COMBAT,'Multiple queued levels processed sequentially')
	g.apply_upgrade('damage')
	check(is_equal_approx(g.damage_mult,1.12),'Damage upgrade')
	var hp=g.hp
	g.apply_upgrade('vital')
	check(g.hp==hp+20,'Vital upgrade')
	for id in ['rapid','speed','crit','armor','magnet','projectile','multi']:g.apply_upgrade(id)
	check(g.armor==2 and g.multishot==1 and g.attack_mult>1.15 and g.magnet==125 and g.projectile_speed>1,'All passive upgrades')
	g.hp-=30
	g.apply_upgrade('heal')
	check(g.hp==hp+15,'Healing upgrade')
	g.hp=g.max_hp
	check(not g.valid_upgrade('heal'),'Invalid heal filtered')
	g.multishot=4
	check(not g.valid_upgrade('multi'),'Multishot cap')
	g.open_shop()
	check(g.offers.size()==4 and g.state==g.State.SHOP,'Four shop offers')
	g.coins=1000
	coins=g.coins
	var price=g.offers[0].price
	check(g.buy_offer(0) and g.coins==coins-price,'Shop purchase debits exact price')
	check(not g.buy_offer(0),'Duplicate purchase rejected')
	coins=g.coins
	check(g.reroll_shop() and g.coins==coins,'First reroll free')
	check(g.reroll_shop() and g.coins==coins-8,'Second reroll costs eight')
	g.coins=0
	check(not g.reroll_shop() and g.coins==0,'Cannot spend negative coins')
	for id in g.weapon_data:
		g.weapons=[{'id':id,'level':5,'clock':0.0}]
		g.generate_offers()
		var valid=true
		for o in g.offers:
			if o.type=='weapon' and o.id==id:valid=false
		check(valid,'Max weapon excluded '+id)
	for id in g.weapon_data:
		g.selected=3 if id=='mop' else 1
		g.cleanup()
		g.state=g.State.COMBAT
		g.weapons=[{'id':id,'level':1,'clock':0.0}]
		g.spawn_enemy('tank')
		e=g.enemies[0]
		e.pos=g.player.position+Vector2(80,0)
		g.orbit_angle=0
		health=e.hp
		g.update_weapons(.016)
		for i in range(20):g.update_shots(.016)
		check(e.hp<health,'Weapon damage '+id)
	g.start_run()
	g.begin_wave()
	g.pause_game()
	clock=g.remaining
	pos=g.player.position
	g._physics_process(2)
	check(g.remaining==clock and g.player.position==pos and g.state==g.State.PAUSED,'Pause freezes simulation')
	g.resume()
	check(g.state==g.State.COMBAT,'Resume')
	g.cleanup()
	g.shoot(g.player.position,Vector2.RIGHT,10,false,500,1)
	var pool_size=g.shots.size()
	g.cleanup()
	g.shoot(g.player.position,Vector2.RIGHT,10,false,500,1)
	check(g.shots.size()==pool_size,'Projectile pool reuses inactive slot')
	g.cleanup()
	for i in range(2):g.spawn_enemy('tank')
	g.enemies[0].pos=g.player.position+Vector2(25,0)
	g.enemies[1].pos=g.player.position+Vector2(25,0)
	var hp0=g.enemies[0].hp
	var hp1=g.enemies[1].hp
	g.shoot(g.player.position,Vector2.RIGHT,5,false,500,1)
	g.update_shots(.1)
	var affected=int(g.enemies[0].hp<hp0)+int(g.enemies[1].hp<hp1)
	check(affected==1,'Projectile damages only one collider')
	var health_before=g.hp
	g.hurt_clock=0
	g.hurt(10)
	g.hurt(10)
	check(g.hp==health_before-maxf(1,10-g.armor),'Player contact damage cooldown')

	for w in range(1,10):
		g.wave_number=w
		g.begin_wave()
		g.remaining=.001
		g._physics_process(.016)
		check(g.state==g.State.SHOP and g.enemies.is_empty(),'Wave -> shop '+str(w))
	# Synthetic multitouch events use the same mobile input path as Android.
	g.begin_wave()
	var touch=InputEventScreenTouch.new()
	touch.index=3
	touch.position=g.ui_root.get_global_transform()*g.joystick_rest()
	touch.pressed=true
	g._input(touch)
	var drag=InputEventScreenDrag.new()
	drag.index=3
	drag.position=g.ui_root.get_global_transform()*(g.joystick_rest()+Vector2(110,0))
	g._input(drag)
	check(g.stick_id==3 and g.move_input.x>.9,'Touch joystick captures finger and analog drag')
	var extra=InputEventScreenTouch.new()
	extra.index=4
	extra.position=g.ui_root.get_global_transform()*(g.joystick_rest()+Vector2(180,0))
	extra.pressed=true
	g._input(extra)
	check(g.stick_id==3,'Second finger does not steal joystick')
	touch.pressed=false
	g._input(touch)
	check(g.stick_id==-1 and g.move_input==Vector2.ZERO,'Touch release resets joystick')
	g._notification(Node.NOTIFICATION_APPLICATION_PAUSED)
	check(g.state==g.State.PAUSED,'Android interruption pauses')
	g.resume()
	g.cleanup()
	for i in range(100):g.spawn_enemy('grunt')
	g.hp=1
	g.hurt_clock=0
	g.enemies[0].pos=g.player.position
	g.update_enemies(.016)
	check(g.state==g.State.GAME_OVER and g.enemies.is_empty(),'Death during enemy iteration cleans safely')
	g.start_run()
	g.wave_number=10
	g.begin_wave()
	check(g.enemies.size()==1 and g.enemies[0].hp==6000,'Strengthened classic boss spawn')
	var boss_pos=g.enemies[0].pos
	g.update_enemies(.016)
	check(g.enemies[0].pos.distance_to(boss_pos)<2,'Boss starts without unannounced dash')
	g.boss_clock=0
	g.update_enemies(.016)
	check(g.boss_phase==1 and g.boss_warning!='','Boss telegraph')
	g.boss_clock=0
	g.update_enemies(.016)
	var count=0
	for s in g.shots:
		if s.active and s.hostile:count+=1
	check(count==18,'Boss radial attack')
	g.boss_clock=0
	g.update_enemies(.016)
	check(g.boss_phase==3 and g.boss_target==g.player.position,'Boss charge warning locks target')
	g.damage_enemy(g.enemies[0],100000)
	check(g.state==g.State.VICTORY and g.saved.wins==1,'Boss death -> victory')
	var games=g.saved.games
	g.finish(true)
	check(g.saved.games==games,'Result recorded once')
	g.start_run()
	g.begin_wave()
	g.hurt_clock=0
	g.hurt(10000)
	check(g.state==g.State.GAME_OVER,'Lethal damage -> game over')
	g.start_run()
	check(g.level==1 and g.kills==0 and g.enemies.is_empty() and not g.result_recorded,'Clean restart')
	g.wave_number=10
	g.begin_wave()
	g.remaining=.001
	g._physics_process(.016)
	check(g.state==g.State.GAME_OVER,'Boss timeout -> game over')
	g.saved.highest_wave=8
	g.save_game()
	g.saved=g.default_save()
	g.load_save()
	check(g.saved.highest_wave==8,'Save and load roundtrip')
	var f=FileAccess.open('user://save.json',FileAccess.WRITE)
	f.store_string('{corrupt')
	f.close()
	g.load_save()
	check(g.saved.games==0 and FileAccess.file_exists('user://save.corrupt.json'),'Corrupt save fallback and backup')
	g.save_game()
	print('RESULT ',passed,' passed, ',failed,' failed')
	g.music.stop()
	await create_timer(.25).timeout
	g.queue_free()
	await process_frame
	quit(1 if failed else 0)
