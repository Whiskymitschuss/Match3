extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Haptics=preload('res://scripts/mobile/haptic_feedback.gd')
var g
var passed=0
var failed=0
func check(ok:bool,message:String):
	if ok:passed+=1;print('PASS ',message)
	else:failed+=1;push_error('FAIL '+message)
func _initialize():call_deferred('run')
func setup(hero:int):
	g.selected=hero
	g.start_run()
	g.begin_wave()
	g.crit=0
	g.weapons=[]
	g.spawn_clock=100
	g.hurt_clock=0
func enemy(pos:Vector2,kind:String='grunt') -> Dictionary:
	g.spawn_enemy(kind)
	var e=g.enemies.back()
	e.pos=pos
	e.hp=1000
	e.max_hp=1000
	return e
func touch(index:int,pos:Vector2,down:bool):
	var ev=InputEventScreenTouch.new()
	ev.index=index
	ev.position=g.ui_root.get_global_transform()*pos
	ev.pressed=down
	root.push_input(ev,true)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=Save.defaults()
	check(g.hero_ability.data.size()==5,'All five heroes have data-driven active abilities')
	setup(0)
	var near=enemy(g.player.position+Vector2(130,0))
	var far=enemy(g.player.position+Vector2(500,0))
	var boss=enemy(g.player.position+Vector2(200,0),'boss')
	var boss_pos=boss.pos
	check(g.hero_ability.activate(),'Bruiser activates shockwave')
	check(is_equal_approx(near.hp,947.2) and far.hp==1000,'Shockwave applies melee bonus in radius only')
	check(is_equal_approx(near.pos.x,g.player.position.x+220),'Shockwave knocks normal enemy back by configured distance')
	check(boss.pos==boss_pos and boss.hp<1000,'Boss takes shockwave damage without forced displacement')
	check(g.hero_ability.cooldown==12 and not g.hero_ability.activate(),'Cooldown prevents repeat activation')
	var power=near.hp
	g.hero_ability.update(1)
	check(near.hp==power and g.hero_ability.rings.is_empty(),'Shockwave damage occurs once, visual effect expires')
	g.hero_ability.update(11)
	check(g.hero_ability.ready_to_use(),'Cooldown reaches ready exactly')
	setup(1)
	near=enemy(g.player.position+Vector2(150,0))
	var splash=enemy(g.player.position+Vector2(230,0))
	far=enemy(g.player.position+Vector2(600,0))
	boss=enemy(g.player.position+Vector2(170,0),'boss')
	check(g.hero_ability.activate(),'Sparky activates grenade')
	check(g.hero_ability.grenade.target==near.pos and near.hp==1000,'Grenade locks nearest target and deals no instant damage')
	var locked=g.hero_ability.grenade.target
	near.pos+=Vector2(15,0)
	g.hero_ability.update(.64)
	check(near.hp==1000 and g.hero_ability.grenade.target==locked,'Fuse is respected and target does not track enemy')
	g.hero_ability.update(.02)
	check(near.hp==960 and splash.hp==960 and far.hp==1000,'Grenade explosion damages actual splash area')
	check(g.hero_ability.grenade.is_empty() and near.ability_slow_time==2,'Grenade is consumed once and slows normal enemies')
	check(not boss.has('ability_slow_time') and boss.hp==960,'Boss takes explosion damage but is immune to slow')
	var before=far.pos
	far.ability_slow=.4
	far.ability_slow_time=2
	g.update_enemies(.1)
	check(absf(far.pos.distance_to(before)-4.2)<.001,'Slow multiplies chase movement without altering base speed')
	check(far.speed==105,'Slow preserves enemy base stats')
	g.update_enemies(2)
	check(far.ability_slow_time==0,'Slow expires on combat time')
	g.hero_ability.update(1)
	check(splash.hp==960,'Expired grenade cannot deal duplicate damage')
	setup(1)
	check(g.hero_ability.activate() and g.hero_ability.grenade.target==g.player.position+Vector2(250,0),'No target grenade uses facing fallback')
	setup(2)
	g.move_input=Vector2.RIGHT
	near=enemy(g.player.position+Vector2(150,0))
	far=enemy(g.player.position+Vector2(0,250))
	var start=g.player.position
	var hp=g.hp
	check(g.hero_ability.activate() and g.hero_ability.invulnerable(),'Shade starts invulnerable dash')
	g.hurt(30)
	check(g.hp==hp,'Active dash prevents contact, projectile and hazard damage via shared damage gate')
	g.hero_ability.move_dash(.09)
	check(is_equal_approx(g.player.position.x,start.x+150) and near.hp==974,'Dash moves by elapsed time and hits swept segment')
	g.hero_ability.move_dash(.09)
	check(g.player.position==start+Vector2(300,0) and not g.hero_ability.invulnerable(),'Dash ends at configured distance and removes invulnerability')
	check(near.hp==974 and far.hp==1000,'Dash hits each crossed enemy only once')
	g.hurt(8)
	check(g.hp==hp-8,'Player can take damage immediately after dash')
	setup(2)
	near=enemy(g.player.position+Vector2(150,0))
	g.move_input=Vector2.RIGHT
	g.hero_ability.activate()
	g.hero_ability.move_dash(.5)
	check(near.hp==974,'Long frame dash uses swept collision, preventing tunneling')
	setup(2)
	g.player.position=Vector2(2340,1550)
	g.move_input=Vector2(1,1)
	g.hero_ability.activate()
	g.hero_ability.move_dash(1)
	check(g.player.position==Vector2(2355,1555),'Dash clamps at arena boundaries')
	g.hero_ability.clear()
	g.player.position=Vector2(2355,800)
	g.move_input=Vector2.RIGHT
	check(not g.hero_ability.activate() and g.hero_ability.cooldown==0,'Blocked dash consumes no cooldown')
	g.move_input=Vector2.LEFT
	check(g.hero_ability.activate(),'Moving away from boundary can dash')
	setup(1)
	g.hero_ability.activate()
	var cool=g.hero_ability.cooldown
	var age=g.hero_ability.grenade.age
	g.pause_game()
	g._physics_process(1)
	check(g.hero_ability.cooldown==cool and g.hero_ability.grenade.age==age and not g.hero_ability.activate(),'Pause freezes fuse and cooldown and rejects activation')
	g.resume()
	g.level_up()
	g._physics_process(1)
	check(g.hero_ability.cooldown==cool and g.hero_ability.grenade.age==age and not g.hero_ability.activate(),'Level-up freezes ability simulation')
	g.change_state(g.State.COMBAT)
	g.open_shop()
	g._physics_process(1)
	check(g.hero_ability.cooldown==cool and not g.hero_ability.activate(),'Shop freezes and blocks ability')
	g.start_run()
	check(g.hero_ability.cooldown==0 and g.hero_ability.grenade.is_empty(),'New run clears cooldown and pending grenade')
	g.begin_wave()
	check(g.hero_ability.ready_to_use(),'Each new wave begins ready')
	setup(0)
	await process_frame
	touch(0,g.joystick_rest(),true)
	check(g.stick_id==0,'First touch owns joystick')
	touch(1,g.ability_rect().get_center(),true)
	check(g.hero_ability.activations==1 and g.stick_id==0,'Second simultaneous touch activates ability without stealing joystick')
	touch(1,g.ability_rect().get_center(),true)
	check(g.hero_ability.activations==1,'Held or duplicate ability touch cannot retrigger')
	touch(1,g.ability_rect().get_center(),false)
	check(g.stick_id==0 and g.ability_touch_ids.is_empty(),'Releasing ability finger keeps movement touch intact')
	touch(0,g.joystick_rest(),false)
	check(g.stick_id==-1 and g.move_input==Vector2.ZERO,'Joystick release resets movement independently')
	for factor in [.5,1.2]:
		setup(0)
		g.ui_root.scale=Vector2.ONE*factor
		g.ui_root.position=Vector2(17,23)
		touch(7,g.ability_rect().get_center(),true)
		check(g.hero_ability.activations==1,'Ability touch respects UI transform at scale '+str(factor))
		touch(7,Vector2(900,200),false)
		check(g.ability_touch_ids.is_empty(),'Ability release outside button clears finger ownership')
	g.update_safe_area()
	setup(0)
	touch(0,g.joystick_rest(),true)
	var drag=InputEventScreenDrag.new()
	drag.index=0
	drag.position=g.ui_root.get_global_transform()*g.ability_rect().get_center()
	root.push_input(drag,true)
	check(g.hero_ability.activations==0 and g.stick_id==0,'Dragging joystick onto ability cannot activate it')
	touch(0,g.joystick_rest(),false)
	setup(2)
	g.move_input=Vector2.RIGHT
	g.hero_ability.activate()
	g.pause_game()
	var dash_age=g.hero_ability.dash.age
	g._physics_process(2)
	check(g.hero_ability.dash.age==dash_age,'Dash itself freezes during pause')
	g.resume()
	g._notification(MainLoop.NOTIFICATION_APPLICATION_PAUSED)
	check(g.state==g.State.PAUSED and not g.hero_ability.activate(),'Android lifecycle pauses active ability')
	setup(0)
	g.crit=1
	near=enemy(g.player.position+Vector2(100,0))
	g.damage_enemy(near,10)
	check(g.hit_feedback.numbers.back().text=='20!' and g.hit_feedback.numbers.back().size==40,'Critical damage has larger, explicit gold number')
	g.saved.settings.damage_numbers=false
	var count=g.hit_feedback.numbers.size()
	g.damage_enemy(near,10)
	check(g.hit_feedback.numbers.size()==count and near.hp==960,'Disabling damage numbers preserves actual damage')
	g.saved.settings.damage_numbers=true
	g.saved.settings.quality='HIGH'
	for i in range(100):g.hit_feedback.damage(Vector2.ZERO,10,false)
	check(g.hit_feedback.numbers.size()==64,'High quality bounds number count')
	g.saved.settings.quality='LOW'
	g.hit_feedback.update(0)
	check(g.hit_feedback.numbers.size()==24,'Changing quality reduces existing number backlog immediately')
	for i in range(100):g.hit_feedback.damage(Vector2.ZERO,10,false)
	check(g.hit_feedback.numbers.size()==24,'Low quality bounds number count')
	var life=g.hit_feedback.numbers[0].life
	g.pause_game()
	g._physics_process(1)
	check(g.hit_feedback.numbers[0].life==life,'Hit feedback freezes in pause')
	g.resume()
	g.hit_feedback.update(1)
	check(g.hit_feedback.numbers.is_empty(),'Expired damage numbers are released')
	g.hurt_clock=0
	g.hurt(8)
	check(g.hit_feedback.hurt_flash>0 and g.hit_feedback.numbers.back().text=='-8','Player hit has distinct flash and signed red damage')
	var pulses:Array=[]
	var emit=func(duration:int,amplitude:float):pulses.append([duration,amplitude])
	var h=Haptics.new()
	check(not h.request('OFF','ability',1000,emit) and pulses.is_empty(),'Haptics default OFF emits nothing')
	check(h.request('LOW','ability',1000,emit) and pulses[0][1]==.35,'Low vibration emits configured light pulse')
	check(not h.request('HIGH','hurt',1010,emit),'Pulse throttle prevents noisy vibration bursts')
	check(h.request('HIGH','hurt',1200,emit) and pulses[1][1]==.8,'High vibration emits stronger pulse')
	check(not h.request('HIGH','invalid',1500,emit),'Unknown vibration event rejected')
	var path='user://v04-settings-test.json'
	g.saved.settings.haptics='HIGH'
	g.saved.settings.damage_numbers=false
	Save.save_local(g.saved,path)
	var loaded=Save.load_local(path)
	check(loaded.settings.haptics=='HIGH' and not loaded.settings.damage_numbers,'New settings survive real disk roundtrip')
	loaded.settings.erase('haptics')
	loaded.settings.erase('damage_numbers')
	Save.save_local(loaded,path)
	loaded=Save.load_local(path)
	check(loaded.settings.haptics=='OFF' and loaded.settings.damage_numbers,'Old schema-3 save defaults optional settings safely')
	loaded.settings.haptics='BROKEN'
	loaded.settings.damage_numbers='false'
	Save.save_local(loaded,path)
	loaded=Save.load_local(path)
	check(loaded.settings.haptics=='OFF' and loaded.settings.damage_numbers,'Malformed new settings sanitized')
	DirAccess.remove_absolute(path)
	for arena in ['scrapyard','reactor']:
		g.saved.wins=1
		g.arena_id=arena
		for hero in range(3):
			setup(hero)
			g.wave_number=10
			g.begin_wave()
			boss=g.enemies[0]
			boss.pos=g.player.position+Vector2(80,0)
			boss.hp=1
			g.move_input=Vector2.RIGHT
			g.hero_ability.activate()
			if hero==1:g.hero_ability.update(1)
			if hero==2:g.hero_ability.move_dash(.5)
			check(g.state==g.State.VICTORY and g.enemies.is_empty() and g.hero_ability.grenade.is_empty() and g.hero_ability.dash.is_empty(),arena+' hero %d ability can win boss and clean safely' % hero)
			g.start_run()
			g.begin_wave()
			check(g.hero_ability.ready_to_use(),arena+' hero %d replay ability resets' % hero)
	g.main_menu()
	g.test_mode=false
	# Exercise production transition guards, not only fixture bypass.
	g.character_select()
	g.arena_select()
	g.choose_arena('scrapyard')
	g.begin_wave()
	check(g.state==g.State.COMBAT,'Real state machine permits character-arena-wave flow')
	g.test_mode=true
	g.pause_game()
	g.settings(g.pause_menu)
	check(g.state==g.State.PAUSED,'Settings preserve paused simulation')
	g.queue_free()
	await process_frame
	# Audio mixer releases stopped playback asynchronously.
	OS.delay_msec(180) # Real mixer time, independent of --fixed-fps simulation acceleration.
	await process_frame
	print('ABILITIES RESULT ',passed,' passed, ',failed,' failed')
	quit(0 if failed==0 else 1)
