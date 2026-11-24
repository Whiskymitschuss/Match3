extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const PATH='user://first_arena_test.json'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,message:String):
	if ok:passed+=1;print('PASS ',message)
	else:failed+=1;push_error('FAIL '+message)
func near(a:float,b:float) -> bool:return absf(a-b)<.01
func labels() -> String:
	var result=''
	for child in g.ui_root.get_children():
		if child is Label:result+=child.text+'\n'
	return result
func button(text:String):
	for child in g.ui_root.get_children():
		if child is Button and child.text==text:return child
	return null
func begin(wave:int=3,arena:String='scrapyard',mode:String='campaign'):
	g.main_menu();g.selected=0;g.arena_id=arena;g.run_mode=mode;g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func accept():
	g.remaining=35;g.scrapyard_salvage.update(.01)
	g.player.position=g.scrapyard_salvage.position;g.move_input=Vector2.ZERO
	g.scrapyard_salvage.update(1.19);check(g.scrapyard_salvage.phase=='offered','Deliberate hold has not completed before 1.2 seconds')
	g.scrapyard_salvage.update(.02)
func settle():
	while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
func tap(at:Vector2):
	var point:Vector2=g.ui_root.get_global_transform_with_canvas()*at
	if native_touch:
		point=root.get_final_transform()*point
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=12;e.position=point;e.pressed=down;Input.parse_input_event(e);await process_frame
	else:
		var motion=InputEventMouseMotion.new();motion.position=point;root.push_input(motion,true);await process_frame
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=point;e.global_position=point;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true);await process_frame
	await process_frame;await process_frame
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();g.world_map.save_path=PATH;g.garage.save_path=PATH
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for id in ['salvage_offer','salvage_start','salvage_complete']:
		var stream=load('res://assets/audio/'+id+'.wav')
		check(stream is AudioStreamWAV and stream.get_length()>.2 and stream.get_length()<1,'Imported original audible short contract cue '+id)
	# New profile welcome and production tutorial, with no unlocked loan fighter.
	g.play();check(button('MIT KICKSY ÜBEN')!=null and labels().contains('Bruiser'),'First Play opens a real two-choice welcome')
	button('MIT KICKSY ÜBEN').pressed.emit();await process_frame;var t=g.tutorial
	check(t.active and g.characters[g.selected].id=='bruiser' and t.training_weapon=='hammer','Production training uses the actually free Bruiser and hammer')
	var saved_before=g.saved.duplicate(true)
	var advance=t.root.get_children().filter(func(n):return n is Button and n.text=='WEITER')[0]
	advance.pressed.emit();advance.pressed.emit();await process_frame
	check(t.step==1 and not t.done,'Queued double tap advances the coach exactly once')
	g.player.position+=Vector2(130,0);t._process(0);check(t.done,'Real movement completes the first lesson')
	t.next();g.update_weapons(.01);t._process(0);check(t.done and g.kills==1,'Actual automatic hammer kills the training enemy')
	t.next();g.loot[0].pos=g.player.position;g.update_loot(.01);t._process(0);check(t.done,'Actual crystal pickup completes XP lesson')
	t.next();g.apply_upgrade('damage');g.if_more_levels();t._process(0);check(t.done and g.level==2,'Real level-up selection completes upgrade lesson')
	t.next();check(t.TEXTS[5].contains('{ability}'),'Ability instruction derives its name from character data');g.hero_ability.activate();t._process(0);check(t.done and g.hero_ability.definition().id=='shockwave','Real Bruiser shockwave completes ability lesson')
	t.next();var e=g.enemies[0];g.ravox.velocity(e,Vector2.LEFT,.01);g.ravox.velocity(e,Vector2.LEFT,2);g.player.position+=Vector2(0,220);g.update_enemies(1);t._process(0);check(t.done,'Real telegraphed charge and dodge complete lesson')
	t.next();check(g.offers[0].id=='hammer' and g.buy_offer(0),'Training shop buys the owned class weapon');t._process(0);check(t.done,'Real purchase is observed by coach')
	t.next();g.reroll_shop();t._process(0);check(t.done and g.rerolls==1,'Actual free reroll completes lesson')
	t.next();g.run_items.upgrade('hammer');t._process(0);check(t.done and g.weapon_level('hammer')==3,'Actual hammer workshop upgrade completes lesson')
	t.next();g.next_shop_wave();g.begin_wave();g.pause_game();t._process(0);g.resume();t._process(0);check(t.done,'Real pause and resume complete lesson')
	t.next();t.next();t.next();check(not t.active and g.saved.settings.tutorial_complete and g.state==g.State.MAIN_MENU,'Training completes and returns safely to menu')
	check(g.saved.games==saved_before.games and g.saved.kills==saved_before.kills and g.saved.meta.coins==saved_before.meta.coins and g.saved.collection.heroes==['bruiser'],'Training awards no run currency, cases, kills or locked fighters')
	check(g.saved.settings.onboarding_seen and Save.load_local().settings.onboarding_seen,'Welcome choice persists through load')
	g.play();check(g.state==g.State.CHARACTER_SELECT,'Returning players go directly to character choice')
	g.main_menu();g.tutorial.start();g.tutorial.stop(false);check(not t.active and g.state==g.State.MAIN_MENU,'Cancel and restart training safely')
	# The event is optional, deterministic, bounded and independent of rendering quality.
	for corner in [Vector2(45,45),Vector2(2355,45),Vector2(45,1555),Vector2(2355,1555)]:
		begin();g.player.position=corner;g.remaining=35;g.scrapyard_salvage.update(.01)
		check(g.scrapyard_salvage.position.distance_to(corner)>g.scrapyard_salvage.RADIUS,'Terminal cannot auto-accept underneath idle corner player '+str(corner))
	for quality in ['LOW','MEDIUM','HIGH']:
		begin();g.saved.settings.quality=quality;g.remaining=36.1;g.scrapyard_salvage.update(.01);check(g.scrapyard_salvage.phase=='idle','No early event '+quality)
		g.remaining=35.9;g.scrapyard_salvage.update(.01);check(g.scrapyard_salvage.phase=='offered' and g.arena_hazards.items.is_empty(),'Optional terminal creates no forced hazards '+quality)
		g.player.position=g.scrapyard_salvage.position;g.move_input=Vector2.RIGHT;g.scrapyard_salvage.update(3);check(g.scrapyard_salvage.phase=='offered','Passing through does not accept '+quality)
		g.move_input=Vector2.ZERO;g.scrapyard_salvage.update(.6);g.player.position+=Vector2(200,0);g.scrapyard_salvage.update(.1);check(g.scrapyard_salvage.held==0,'Leaving circle resets deliberate hold '+quality)
		g.player.position=g.scrapyard_salvage.position;g.scrapyard_salvage.update(1.2);check(g.scrapyard_salvage.phase=='active' and g.arena_hazards.items.size()==3,'Accept creates one three-impact salvo '+quality)
		check(g.arena_hazards.items.all(func(h):return h.warm==1.8 and h.damage==12 and h.salvage),'Exact shared warning and collision data '+quality)
		var hp=g.hp;g.arena_hazards.update(1.79);check(g.hp==hp,'No damage before full 1.8 second warning '+quality)
		g.arena_hazards.update(.02);check(g.hp==hp-12,'Danger creates real damage after warning '+quality)
		g.player.position=Vector2(200,200);g.move_input=Vector2.ZERO
		for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
			g.state=state;var age=g.scrapyard_salvage.age;var held=g.scrapyard_salvage.held;var count=g.coins;g._physics_process(5);g.scrapyard_salvage.update(5)
			check(g.scrapyard_salvage.age==age and g.scrapyard_salvage.held==held and g.coins==count,'Contract freeze '+quality+' '+str(state))
		g.state=g.State.COMBAT
		for step in range(80):
			g.scrapyard_salvage.update(.1);g.player.position=Vector2(2300,1500);g.arena_hazards.update(.1)
		check(g.scrapyard_salvage.phase=='complete' and g.coins==32 and g.earned==32 and g.run_events==1,'Completed contract grants exact one-time Run-Coins '+quality)
		for step in range(10):g.scrapyard_salvage.update(2)
		check(g.coins==32 and g.scrapyard_salvage.completed==1 and g.scrapyard_salvage.total_coins==32,'Repeated update cannot duplicate receipt '+quality)
		g.cleanup();check(g.arena_hazards.items.is_empty() and g.scrapyard_salvage.phase=='idle' and g.scrapyard_salvage.total_coins==32,'Wave cleanup keeps only run receipt '+quality)
		g.wave_number=5;g.begin_wave();accept();g.hp=1;g.hurt_clock=0;g.hurt(100)
		check(g.state==g.State.GAME_OVER and g.scrapyard_salvage.total_coins==32,'Death during contract grants no pending reward '+quality)
		g.start_run();check(g.scrapyard_salvage.completed==0 and g.scrapyard_salvage.total_coins==0,'Restart resets all contract receipts '+quality)
	for mode in ['tutorial','endless']:
		begin(3,'scrapyard',mode);g.remaining=30;g.scrapyard_salvage.update(5);check(g.scrapyard_salvage.phase=='idle','Other modes retain their rules '+mode)
	begin();g.remaining=35;g.scrapyard_salvage.update(.01);g.remaining=9;g.player.position=g.scrapyard_salvage.position;g.move_input=Vector2.ZERO;g.scrapyard_salvage.update(2)
	check(g.scrapyard_salvage.phase=='expired' and g.coins==0 and g.arena_hazards.items.is_empty(),'Late acceptance closes before an impossible contract')
	for wave in [1,2,4,6,8,10]:
		begin(wave);g.remaining=20;g.scrapyard_salvage.update(5);check(g.scrapyard_salvage.phase=='idle','No contract in starter or boss wave '+str(wave))
	preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	for arena in g.Arenas.IDS:
		if arena=='scrapyard':continue
		begin(3,arena);g.remaining=30;g.scrapyard_salvage.update(5);check(g.scrapyard_salvage.phase=='idle','Other arena gameplay unchanged '+arena)
	# Both actual weapon evolutions, connected campaign flow, no forced victory damage.
	for spec in ['quake','crusher']:
		g.saved=g.default_save();g.saved.settings.shop_help_seen=true;begin(1);g.damage_mult=2.2;g.attack_mult=2.0;g.coins=1000
		var timer=g.remaining;g.open_shop();button('HAMMER-PFADE').pressed.emit();await process_frame;check(labels().contains('ERDBEBEN') and labels().contains('DONNERFAUST') and g.remaining==timer,'Both paths visible with frozen simulation '+spec)
		button('HAMMER AUFRÜSTEN').pressed.emit();await process_frame;check(button('ZURÜCK')!=null,'Build preview reaches real workshop '+spec)
		for i in range(4):check(g.run_items.upgrade('hammer'),'Real paid workshop level '+str(i+2)+' '+spec)
		check(g.pending_specialization().id=='hammer' and g.choose_specialization('hammer',spec),'Actual free specialization choice '+spec)
		for wave in range(1,11):
			g.wave_number=wave;g.prepare_wave();g.begin_wave();g.spawn_clock=999
			if wave%2==1:
				g.remaining=.001;g._physics_process(.01)
			else:
				var boss=g.enemies[0];boss.pos=g.player.position+Vector2(95,0);var fired=0;var time_limit=float(g.remaining)
				while g.state==g.State.COMBAT and g.enemies.has(boss) and fired<1200:
					g.update_weapons(.1);g.hero_ability.update(.1)
					if g.hero_ability.ready_to_use():g.hero_ability.activate()
					fired+=1
				settle();check(fired*.1<time_limit,'Real hammer path defeats boss within its maximum timer in stationary reference '+spec+' '+str(wave))
			check(g.state==(g.State.VICTORY if wave==10 else g.State.SHOP),'Connected normal/boss wave transition '+spec+' '+str(wave))
		check(g.saved.games==1 and g.saved.wins==1 and g.saved.world_progress.unlocked.has('reactor'),'Actual campaign clear opens next world '+spec)
		var wallet=g.saved.meta.coins;g.reward_details();var content=labels()
		check(content.contains('STUDIO-COINS') and content.contains('RUN-COINS') and content.contains('WELTABSCHLUSS'),'Three distinct reward purposes shown '+spec)
		button('ZUM ERGEBNIS').pressed.emit();await process_frame;g.reward_details();button('ZUM ERGEBNIS').pressed.emit();await process_frame;g.finish(true)
		check(g.saved.meta.coins==wallet and g.saved.games==1,'Result navigation and repeated finish cannot pay twice '+spec)
		g.reward_details();button('WELTKARTE / BELOHNUNG').pressed.emit();await process_frame;check(g.state==g.State.ARENA_SELECT and g.world_map.claim('scrapyard'),'Details route reaches exact once-only first-clear claim '+spec)
		check(not g.world_map.claim('scrapyard') and Save.load_local(PATH).world_progress.claimed==['scrapyard'],'Claim persists and cannot duplicate '+spec)
		g.character_select();g.start_run();check(g.state==g.State.WAVE_PREPARATION and not g.result_recorded and g.result_details.is_empty(),'New run safely follows result and claim '+spec)
	for args in [['campaign',10,466,true],['campaign',4,120,false],['endless',10000,99999,false],['tutorial',10,1000,true]]:
		var d=g.Collection.reward_breakdown(args[0],args[1],args[2],args[3]);var profile=g.default_save();var value=g.Collection.run_reward(profile,args[0],args[1],args[2],args[3])
		check(d.total==value and d.waves+d.kills+d.victory==value and value<=500,'Reward explanation exactly matches actual payout '+str(args))
	for size in [Vector2i(1280,720),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;g.update_safe_area();begin(2);g.refresh_hud()
		check(g.boss_hud.position.y>=222+g.safe_logical.position.y,'Boss HUD clears player card '+str(size))
		g.pause_game();check(g.ui_root.get_children().all(func(n):return not n is Label or n.mouse_filter==Control.MOUSE_FILTER_IGNORE),'Decorative labels never intercept touch '+str(size));g.resume()
	root.size=Vector2i(1280,720);await process_frame;g.update_safe_area();g.test_mode=false;g.saved.settings.master=0;g.saved.settings.reduced_motion=true
	g.run_session.live=false # This fixture represents a fresh app, without the previous test's live run.
	g.saved=g.default_save();g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.main_menu();await process_frame
	await tap(Vector2(500,710));check(button('MIT KICKSY ÜBEN')!=null,'Actual Play touch opens first-player welcome safely')
	await tap(Vector2(1300,910));check(g.state==g.State.CHARACTER_SELECT and g.saved.settings.onboarding_seen,'Actual screen touch can skip welcome through production GUI')
	g.start_run();g.begin_wave();g.finish(false);g.reward_details();await process_frame
	await tap(Vector2(350,990));check(labels().contains('Run-Coins') and button('NOCHMAL SPIELEN')!=null,'Actual touch returns from reward details to result')
	var receipt=g.saved.meta.coins;await tap(Vector2(350,945));check(labels().contains('STUDIO-COINS') and g.saved.meta.coins==receipt,'Actual touch reopens reward details without duplicate payout')
	g.queue_ui_action(g.show_result);g.queue_ui_action(g.main_menu);await process_frame;await process_frame
	check(g.state==g.State.GAME_OVER and button('NOCHMAL SPIELEN')!=null and g.saved.meta.coins==receipt,'First queued destination wins; stale page action is discarded')
	g.test_mode=true
	g.saved=original;g.save_game();g.free();await process_frame;DirAccess.remove_absolute(PATH)
	print('FIRST ARENA RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)
