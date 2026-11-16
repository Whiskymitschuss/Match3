extends SceneTree
const Layout=preload('res://scripts/mobile/display_layout.gd')
const Balance=preload('res://scripts/gameplay/wave_balance.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,text:String):
	if ok:passed+=1;print('PASS ',text)
	else:failed+=1;push_error('FAIL '+text)
func approx(a:float,b:float) -> bool:return absf(a-b)<.001
func touch(index:int,pos:Vector2,down:bool):
	var e=InputEventScreenTouch.new();e.index=index;e.pressed=down;e.position=g.ui_root.get_global_transform()*pos
	root.push_input(e,true)
func run():
	check(ProjectSettings.get_setting('display/window/stretch/aspect')=='expand','Project expands the visible game canvas instead of letterboxing')
	for size in [Vector2(1920,1080),Vector2(2340,1080),Vector2(2560,1080),Vector2(1920,1440),Vector2(3840,1080)]:
		var layout=Layout.calculate(size)
		var bleed:Rect2=layout.bleed
		var start:Vector2=layout.position+bleed.position*layout.scale
		var end:Vector2=layout.position+bleed.end*layout.scale
		check(start.length()<.001 and end.distance_to(size)<.001,'Full-bleed background covers complete viewport '+str(size))
		var safe:Rect2=layout.safe
		var ability=Rect2(Vector2(1510,770)+safe.end-Vector2(1920,1080),Vector2(300,210))
		var pause=Rect2(Vector2(1690,40)+Vector2(safe.end.x-1920,safe.position.y),Vector2(140,100))
		check(safe.encloses(ability) and safe.encloses(pause),'Touch buttons stay inside safe area '+str(size))
		var zoom=Layout.camera_zoom(size)
		check(size.x/zoom<=2400.01 and size.y/zoom<=1600.01,'Camera never exposes outside-arena black background '+str(size))
	for device_safe in [Rect2(100,0,2240,1080),Rect2(0,0,2220,1080),Rect2(100,30,2120,1020)]:
		var layout=Layout.calculate(Vector2(2340,1080),Vector2(2340,1080),device_safe)
		var screen_start:Vector2=layout.position+layout.safe.position*layout.scale
		var screen_end:Vector2=layout.position+layout.safe.end*layout.scale
		check(screen_start.distance_to(device_safe.position)<.001 and screen_end.distance_to(device_safe.end)<.001,'Cutout/system-bar safe area maps correctly '+str(device_safe))
	var fallback=Layout.calculate(Vector2(2340,1080),Vector2(2340,1080),Rect2())
	check(fallback.safe.size.x==2340,'Unavailable Android insets safely use full viewport')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	g.saved=g.default_save();g.saved.wins=1;g.selected=1
	for entry in [Vector2i(1280,591),Vector2i(1280,720),Vector2i(1024,768)]:
		root.size=entry;await process_frame;await process_frame
		g.update_safe_area();g.main_menu()
		var bg=g.ui_root.get_node('FullBleedBackdrop')
		check(bg.position==g.ui_bleed.position and bg.size==g.ui_bleed.size,'Actual menu backdrop fills expanded canvas '+str(entry))
		g.arena_id='reactor';g.start_run();g.begin_wave()
		check(g.ability_button.position==g.ability_rect().position and g.safe_logical.encloses(Rect2(g.pause_button.position,g.pause_button.size)),'Actual HUD anchors adapt '+str(entry))
		touch(0,g.joystick_rest(),true)
		touch(1,g.ability_rect().get_center(),true)
		check(g.stick_id==0 and g.hero_ability.activations==1,'Expanded-layout multitouch activates ability without stealing joystick '+str(entry))
		touch(1,g.ability_rect().get_center(),false);touch(0,g.joystick_rest(),false)
		check(g.stick_id==-1 and g.ability_touch_ids.is_empty(),'Expanded-layout releases reset both touches '+str(entry))
		var click=InputEventMouseButton.new()
		click.button_index=MOUSE_BUTTON_LEFT;click.position=g.ui_root.get_global_transform()*(g.pause_button.position+g.pause_button.size*.5)
		click.pressed=true;root.push_input(click,true)
		click=click.duplicate();click.pressed=false;root.push_input(click,true)
		check(g.state==g.State.PAUSED,'Actual pause GUI button remains clickable outside the reference content width '+str(entry))
		var time=g.run_time;g._physics_process(1)
		check(g.run_time==time,'Pause still stops gameplay after fullscreen resize '+str(entry))
	root.size=Vector2i(1280,720);await process_frame;await process_frame
	g.update_safe_area()
	g.arena_id='reactor';g.start_run();g.begin_wave()
	var cutout=Layout.calculate(Vector2(2340,1080),Vector2(2340,1080),Rect2(100,0,2240,1080))
	g.safe_logical=cutout.safe;g.ui_root.position=cutout.position;g.ui_root.scale=Vector2.ONE*cutout.scale
	touch(0,Vector2(cutout.safe.position.x-50,850),true)
	check(g.stick_id==-1,'Touch inside cutout/unsafe band cannot start joystick')
	touch(0,g.joystick_rest(),true)
	check(g.stick_id==0,'Joystick remains usable inside simulated notched safe area')
	touch(0,g.joystick_rest(),false)
	g.update_safe_area()
	g.start_run()
	var waves=g.waves
	var classic=g.read_data('waves/waves')
	var old_reactor=JSON.parse_string(FileAccess.get_file_as_string('res://tests/fixtures/reactor_waves_v0.6.json'))
	var old_classic=JSON.parse_string(FileAccess.get_file_as_string('res://tests/fixtures/classic_waves_v0.6.json'))
	for i in range(3):
		check(waves[i]==old_reactor[i],'Reactor opening wave '+str(i+1)+' is exactly unchanged from 0.6')
		check(classic[i]==old_classic[i],'Classic opening wave '+str(i+1)+' is exactly unchanged from 0.6')
	for i in range(3):
		var w=waves[i]
		check(not w.has('hp_factor') and not w.has('extra_spawn_every') and w.duration==60,'Opening wave '+str(i+1)+' retains its previous values')
		check(Balance.spawn_count(w,5)==1 and Balance.reward(5,w)==5,'Opening wave '+str(i+1)+' retains spawn count and rewards')
	for i in range(3,10):
		var w=waves[i]
		check(w.hp_factor>1 and w.speed_factor>1 and w.damage_factor>1,'Late wave '+str(i+1)+' strengthens normal enemies')
		check(w.reward_factor>0 and w.reward_factor<=1,'Late-wave extra enemies do not inflate per-enemy rewards '+str(i+1))
		var count=0
		for cycle in range(1,31):count+=Balance.spawn_count(w,cycle)
		check(count>30 and count<=60,'Late-wave reinforcement groups are bounded '+str(i+1))
		check(w.duration==(90 if i==9 else 60),'Wave length unchanged '+str(i+1))
	for i in range(classic.size()):
		var w=classic[i]
		check((Balance.spawn_count(w,5)==1 and not w.has('hp_factor')) if i<3 else (w.hp_factor>1 and Balance.spawn_count(w,int(w.extra_spawn_every))==2 and w.reward_factor<1),'Classic wave '+str(i+1)+' follows requested opening/late-game split')
	g.begin_wave();g.wave_number=4
	g.spawn_enemy('grunt')
	var e=g.enemies.back()
	check(approx(e.max_hp,40*1.27*1.18*1.075) and approx(e.speed,105*1.03*1.075) and approx(e.damage,8*1.06*1.06),'Actual fourth-wave enemy gets all configured modifiers')
	g.crit=0;g.damage_enemy(e,10000)
	check(g.coins==2 and g.loot.back().xp==4,'Actual fourth-wave drops use rounded balanced rewards')
	g.cleanup();g.wave_number=9
	g.spawn_enemy('tank');e=g.enemies.back()
	check(approx(e.max_hp,160*1.72*2*1.2) and approx(e.speed,70*1.14*1.2),'Late tank health and speed scale as configured')
	check(e.coin_reward==3 and e.xp_reward==8,'Late tank rewards are adjusted without discarding drops')
	g.cleanup();g.wave_number=10;g.spawn_enemy('boss');e=g.enemies[0]
	check(e.max_hp==7560 and e.speed==62 and e.damage==18,'Reactor boss lasts longer while movement/contact values stay fair')
	check(e.coin_reward==140 and e.xp_reward==120,'Boss rewards remain unchanged')
	g.cleanup();g.wave_number=4;g.begin_wave();g.weapons=[]
	g.max_hp=100000;g.hp=100000
	for i in range(4):g.spawn_clock=0;g._physics_process(.01)
	check(g.enemies.size()==4,'Four regular fourth-wave spawn cycles create four enemies')
	g.spawn_clock=0;g._physics_process(.01)
	check(g.enemies.size()==6,'Fifth cycle adds the announced reinforcement group')
	g.cleanup()
	for i in range(99):g.spawn_enemy('grunt')
	g.spawn_cycle=4;g.spawn_clock=0;g._physics_process(.01)
	check(g.enemies.size()==100,'Reinforcement group cannot exceed existing 100-enemy cap')
	g.arena_id='scrapyard';g.start_run();g.wave_number=9;g.begin_wave();g.spawn_enemy('tank');e=g.enemies.back()
	check(approx(e.hp,160*1.72*2*1.2) and approx(e.speed,70*1.14*1.2) and approx(e.damage,16*1.26*1.16) and e.coin_reward==3,'Actual classic late wave is also stronger with controlled rewards')
	g.queue_free();await process_frame
	print('DISPLAY BALANCE RESULT ',passed,' passed, ',failed,' failed')
	quit(0 if failed==0 else 1)
