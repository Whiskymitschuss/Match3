extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const Layout=preload('res://scripts/mobile/touch_layout.gd')
const Presets=preload('res://scripts/progression/loadout_presets.gd')
const Backup=preload('res://scripts/progression/profile_backup.gd')
const ROOT='user://beta_test_comfort'
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func touch(at:Vector2,index:int,down:bool):
	var e=InputEventScreenTouch.new();e.position=g.ui_root.get_global_transform()*at;e.index=index;e.pressed=down;g._input(e)
func drag(at:Vector2,index:int):
	var e=InputEventScreenDrag.new();e.position=g.ui_root.get_global_transform()*at;e.index=index;g._input(e)
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT)
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=ROOT;root.add_child(g);g.set_physics_process(false);g.run_session.test_enabled=true;g.saved.settings.master=0
	var d=Layout.defaults();var normal=Layout.geometry(Rect2(0,0,1920,1080),d)
	check(normal.joy==Vector2(220,850) and normal.ability==g.ABILITY_RECT,'Default touch geometry preserves the shipped positions')
	check(Layout.analog(Vector2(10,0),110,.15)==Vector2.ZERO and Layout.analog(Vector2(300,0),110,.15)==Vector2.RIGHT,'Analog input has a real deadzone and bounded maximum')
	var cleaned=Layout.clean({'size':99,'opacity':-1,'deadzone':NAN,'left_handed':'yes','joy_x':9999})
	check(cleaned.size==1.2 and cleaned.opacity==.45 and cleaned.left_handed==false and cleaned.joy_x==120 and is_finite(cleaned.deadzone),'Malformed layout settings are bounded and sanitized')
	for safe in [Rect2(0,0,1920,1080),Rect2(-240,0,2400,1080),Rect2(0,-180,1920,1440),Rect2(80,40,1760,1000)]:
		for left in [false,true]:
			for scale in [.85,1.2]:
				d.left_handed=left;d.size=scale;d.joy_x=120;d.joy_y=-110;d.ability_x=-80;d.ability_y=-110
				var m=Layout.geometry(safe,d)
				check(safe.encloses(m.ability) and safe.encloses(m.spell) and not m.ability.intersects(Rect2(m.joy-Vector2.ONE*m.visual_radius,Vector2.ONE*m.visual_radius*2)),'Safe and separate controls across aspect, cutout, size and handedness')
	g.saved.settings.touch_layout=Layout.defaults();g.saved.settings.touch_layout.left_handed=true;g.saved.settings.touch_layout.dynamic=false
	g.start_run(true);g.begin_wave();var m=g.touch_geometry();touch(m.joy,2,true);drag(m.joy+Vector2(m.radius,0),2)
	check(g.stick_id==2 and g.move_input.is_equal_approx(Vector2.RIGHT),'Actual fixed right-hand joystick drives the player')
	var held=g.stick_id;touch(m.ability.get_center(),3,true)
	check(g.stick_id==held and g.hero_ability.activations==1,'Second finger activates mirrored ability without stealing movement')
	touch(m.ability.get_center(),3,false);touch(m.joy,2,false)
	check(g.stick_id==-1 and g.move_input==Vector2.ZERO,'Multitouch release resets input safely')
	g.pause_game();g.main_menu();var pending=g.saved.active_run.duplicate(true)
	g.touch_editor.show(g.main_menu);g.touch_editor.draft.size=1.15;g.touch_editor.leave()
	check(g.saved.settings.touch_layout.size==1.0,'Cancelling the editor leaves the saved layout unchanged')
	g.touch_editor.show(g.main_menu);g.touch_editor.draft.size=1.15
	check(g.touch_editor.apply() and Save.load_local(g.active_save_path()).settings.touch_layout.size==1.15,'Applying the editor writes the current profile')
	check(g.saved.active_run==pending,'Layout editing preserves the pending combat snapshot')
	check(Presets.store(g.saved,'bruiser',0),'A real owned fighter loadout can be stored')
	var item=''
	for id in g.Collection.catalog().items:
		if g.Collection.catalog().items[id].slot=='head':item=id;break
	g.saved.collection.levels[item]=1;g.saved.collection.loadouts.bruiser.head=item
	check(Presets.store(g.saved,'bruiser',1) and Presets.apply(g.saved,'bruiser',0) and g.saved.collection.loadouts.bruiser.head=='','Applying a different preset replaces every equipment slot')
	check(Presets.apply(g.saved,'bruiser',1) and g.saved.collection.loadouts.bruiser.head==item,'Preset restores the saved owned clothing')
	check(not Presets.store(g.saved,'sparky',0) and not Presets.apply(g.saved,'bruiser',2) and not Presets.store(g.saved,'bruiser',9),'Locked heroes, empty slots and out-of-range presets are rejected')
	g.save_game();var loaded=Save.load_local(g.active_save_path())
	check(loaded.loadout_presets.bruiser.size()==3 and loaded.loadout_presets.bruiser[1].head==item,'Presets survive versioned save/load')
	var portable=Backup.decode(Backup.encode(g.saved,'Testspieler'))
	check(portable.error=='' and portable.save.loadout_presets==g.saved.loadout_presets and is_equal_approx(portable.save.settings.touch_layout.deadzone,g.saved.settings.touch_layout.deadzone) and portable.save.settings.touch_layout.left_handed and not portable.save.active_run.is_empty(),'Portable backups include touch layout, presets and suspended run')
	var snapshot=g.saved.duplicate(true);var old_root=g.profiles.root;var blocked=ROOT+'/blocked';var f=FileAccess.open(blocked,FileAccess.WRITE);f.store_string('fixture');f.close();g.profiles.root=blocked+'/'
	g.presets_view.hero=0
	check(not g.presets_view.transact('store',2) and g.saved==snapshot,'Failed preset write rolls back the slot and current player')
	g.touch_editor.show(g.main_menu);g.touch_editor.draft.size=.9
	check(not g.touch_editor.apply() and g.saved.settings.touch_layout==snapshot.settings.touch_layout,'Failed layout write keeps the last saved controls')
	g.profiles.root=old_root;g.touch_editor.leave();g.save_game()
	var before=g.saved.duplicate(true);var disk=FileAccess.get_file_as_string(g.active_save_path())
	check(not g.practice.start(1,'scrapyard',2,1),'Practice cannot bypass fighter locks')
	check(not g.practice.start(0,'reactor',2,1),'Practice cannot bypass world unlocks')
	for w in [2,4,6,8,10]:
		check(g.practice.start(0,'scrapyard',w,3) and not g.run_session.live,'Each boss rung starts as isolated practice')
		g.begin_wave();var boss=g.enemies.filter(func(e):return e.kind in ['boss','champion','breaker_axel']).front()
		check(g.state==g.State.COMBAT and absf(boss.hp/boss.max_hp-.34)<.001,'Practice uses a real boss with requested rage-phase health')
		g.damage_enemy(boss,10000000)
		check(g.state==g.State.VICTORY and g.practice.ending,'Real boss death opens the training result instead of shop or rewards')
		g.practice.leave()
		check(g.saved==before and FileAccess.get_file_as_string(g.active_save_path())==disk,'Training victory leaves collection, quests, stats and prior checkpoint untouched')
	check(g.practice.start(0,'scrapyard',2,1),'Another practice attempt starts after repeated victories')
	g.begin_wave();g.hp=1;g.hurt(500)
	check(g.state==g.State.GAME_OVER and g.practice.hits==1,'Practice defeat records actual received hits')
	g.main_menu();check(g.saved==before and not g.practice.active,'Leaving a defeated practice restores the real player')
	# Earned-world fixture exercises every map's actual final-boss controller.
	g.saved.world_progress.unlocked=g.Arenas.IDS.duplicate();g.save_game()
	for arena in g.Arenas.IDS:
		check(g.practice.start(0,arena,10,2),'Final-boss practice starts in '+arena)
		g.begin_wave();g._physics_process(1.0/60.0)
		var bosses=g.enemies.filter(func(e):return e.kind=='boss')
		check(bosses.size()==1 and bosses[0].boss_name==g.Arenas.definition(arena).boss_name and g.state==g.State.COMBAT,'Real map boss and arena controller run in '+arena)
		g.finish(false);g.practice.leave()
	check(g.run_session.resume_saved() and g.state==g.State.PAUSED,'Original suspended run still really resumes after training')
	g.main_menu();g.tutorial.start();g.tutorial.step=1;g.tutorial.enter_step()
	check(g.tutorial.root.get_children().any(func(n):return n is Label and n.text.begins_with('Rechts den Joystick')),'Tutorial movement follows the selected handedness')
	g.tutorial.step=5;g.tutorial.enter_step()
	check(g.tutorial.root.get_children().any(func(n):return n is Label and n.text.begins_with('Tippe links unten')),'Tutorial ability instruction follows the mirrored button')
	g.tutorial.stop(false)
	g.run_session.live=false;g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('COMFORT UPDATE RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
