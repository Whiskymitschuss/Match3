extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
const ROOT='user://beta_test_comfort_ui'
var g
var passed=0
var failed=0
var native=false
var capture=false
func _initialize():
	native=OS.get_cmdline_user_args().has('--native-touch');capture=OS.get_cmdline_user_args().has('--capture');call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func buttons(node:Node,search:String) -> Array:
	var found=[]
	if node is Button and node.text==search:found.append(node)
	for child in node.get_children():found.append_array(buttons(child,search))
	return found
func tap(label:String,index:int=0):
	await process_frame;await process_frame
	var rows=[g.pause_button] if label=='Ⅱ' and is_instance_valid(g.pause_button) else buttons(g.ui_root,label)
	check(rows.size()>index and not rows[index].disabled,'Usable control '+label)
	if rows.size()<=index:return
	var b:Button=rows[index]
	if native:
		await create_timer(.35).timeout
		var at=root.get_final_transform()*(b.get_global_transform_with_canvas()*(b.size*.5))
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=14;e.pressed=down;e.position=at;Input.parse_input_event(e);await process_frame
	else:b.pressed.emit()
	await process_frame;await process_frame
func frame(name:String):
	await create_timer(.35).timeout
	if capture and native:
		await RenderingServer.frame_post_draw;get_root().get_texture().get_image().save_png('res://tests/comfort_'+name+'.png')
func run():
	Files.clear(ROOT);DirAccess.make_dir_recursive_absolute(ROOT)
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=ROOT;root.add_child(g);g.set_physics_process(false);g.run_session.test_enabled=true;g.saved.settings.master=0;g.saved.settings.onboarding_seen=true;g.saved.settings.reduced_motion=true
	get_root().size=Vector2i(1600,900);await process_frame;g.update_safe_area()
	g.start_run(true);g.begin_wave();g.pause_game();g.main_menu();g.test_mode=false;var cp=g.saved.active_run.duplicate(true);var games=g.saved.games
	await tap('EXTRAS');await frame('extras_1600')
	await tap('ÖFFNEN',2);await frame('layout_1600')
	check(g.touch_editor.active,'Actual menu opens editable layout preview')
	var editor=g.touch_editor;var map=editor.projection();var at=editor.field.position+map.offset+Vector2(220,850)*map.scale
	var e=InputEventScreenTouch.new();e.position=g.ui_root.get_global_transform()*at;e.index=4;e.pressed=true;g._input(e)
	var drag=InputEventScreenDrag.new();drag.position=g.ui_root.get_global_transform()*(at+Vector2(45,-20));drag.index=4;g._input(drag)
	e.pressed=false;g._input(e)
	check(editor.draft.joy_x>50 and editor.draft.joy_y<0,'Real touchscreen drag moves and bounds the preview joystick')
	await tap('LINKSHÄNDER: AUS');await tap('ANWENDEN')
	check(g.saved.settings.touch_layout.left_handed and g.saved.active_run==cp,'Layout apply persists handedness without replacing the pending run')
	await tap('ÖFFNEN',1);await tap('AKTUELLES SPEICHERN',0);await frame('presets_1600')
	await tap('ANLEGEN',0);check(not g.saved.loadout_presets.bruiser[0].is_empty(),'Actual preset buttons save and equip a build')
	await tap('AKTUELLES SPEICHERN',0);await tap('ABBRECHEN');check(g.saved.active_run==cp,'Preset overwrite cancellation preserves the pending run')
	await tap('ZURÜCK');await tap('ÖFFNEN',0);await frame('practice_1600')
	await tap('STARTPHASE: 1');await tap('TRAINING STARTEN');await tap('KAMPF STARTEN')
	check(g.practice.active and g.state==g.State.COMBAT,'Real boss preparation and start enter isolated combat')
	# Keep the UI fixture in combat long enough to inspect pause navigation.
	g.weapons[0].clock=99;g.spawn_clock=99
	for i in range(90):g._physics_process(1.0/60.0)
	await frame('practice_hud_1600');await tap('Ⅱ');await tap('SICHERN & HAUPTMENÜ')
	check(not g.practice.active and g.saved.games==games and g.saved.active_run==cp,'Pause navigation leaves practice without rewards or overwriting the real run')
	for viewport in [Vector2i(2400,1080),Vector2i(1440,1080)]:
		get_root().size=viewport;await process_frame;g.update_safe_area();g.extras.show();await tap('ÖFFNEN',2);await frame('layout_'+str(viewport.x))
		for b in g.ui_root.get_children():
			if b is Button:check(g.safe_logical.encloses(Rect2(b.position,b.size)),'Touch editor button fits safe area '+str(viewport))
		await tap('ABBRECHEN');await tap('ÖFFNEN',0);await frame('practice_'+str(viewport.x));await tap('ZURÜCK')
	g.run_session.live=false;g.free();await process_frame;await create_timer(.25).timeout;Files.clear(ROOT)
	print('COMFORT UI RESULT ',passed,' passed, ',failed,' failed; native_touch=',native);quit(1 if failed else 0)
