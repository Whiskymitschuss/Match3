extends SceneTree
const C=preload('res://scripts/progression/collection.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
var g
var original:Dictionary
var passed=0
var failed=0
const PATH='user://case_navigation_0211.json'
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func button(text:String) -> Button:
	for node in g.ui_root.get_children():
		if node is Button and node.text==text:return node
	return null
func heading(text:String) -> bool:
	return g.ui_root.get_children().any(func(node):return node is Label and node.text==text)
func settle():
	await process_frame;await process_frame
func tap(label:String):
	await settle()
	var b=button(label)
	check(b!=null and not b.disabled,'Usable GUI button '+label)
	if b==null:return
	var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
	if native_touch:
		at=root.get_final_transform()*at
		for down in [true,false]:
			var event=InputEventScreenTouch.new();event.index=0;event.position=at;event.pressed=down;Input.parse_input_event(event);await process_frame
	else:
		var motion=InputEventMouseMotion.new();motion.position=at;root.push_input(motion,true);await process_frame
		for down in [true,false]:
			var event=InputEventMouseButton.new();event.position=at;event.global_position=at;event.button_index=MOUSE_BUTTON_LEFT;event.pressed=down;root.push_input(event,true);await process_frame
	await settle()
func fresh(kind:String,duplicate:bool=false,animated:bool=false):
	g.main_menu();g.saved=Save.defaults();g.saved.settings.master=0;g.saved.settings.reduced_motion=not animated;g.saved.collection.seed=18018;g.garage.save_path=PATH
	g.saved.collection.tickets[kind]=1 # Earned-ticket fixture for reveal navigation.
	if duplicate:
		g.saved.collection.heroes=C.HEROES.duplicate()
		for id in C.catalog().items:g.saved.collection.levels[id]=1
	g.garage.cases();check(g.garage.open_case(kind),'Actual case opens '+kind)
func same_rewards(before:Dictionary) -> bool:
	var after=g.saved.duplicate(true);var expected=before.duplicate(true);after.collection.pending.clear();expected.collection.pending.clear()
	return after==expected
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);original=g.saved.duplicate(true)
	root.size=Vector2i(1280,720);await settle();g.update_safe_area();g.saved.settings.master=0;g.test_mode=false
	for kind in ['crew','arsenal','style']:
		for destination in ['ZUM INVENTAR','WEITERE CASES']:
			fresh(kind);await settle();var before=g.saved.duplicate(true);var receipt=g.saved.collection.pending.duplicate(true)
			if native_touch and kind=='crew' and destination=='ZUM INVENTAR' and OS.get_cmdline_user_args().has('--capture'):
				await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png('res://tests/case_navigation_reveal.png')
			await tap(destination)
			if native_touch and kind=='crew' and destination=='ZUM INVENTAR' and OS.get_cmdline_user_args().has('--capture'):
				await RenderingServer.frame_post_draw;root.get_texture().get_image().save_png('res://tests/case_navigation_inventory.png')
			check(heading('MAYHEM GARAGE' if destination=='ZUM INVENTAR' else 'MAYHEM CASES'),'Real GUI leaves reveal: '+kind+' / '+destination)
			check(g.saved.collection.pending.is_empty() and same_rewards(before),'Navigation keeps exact rewards and clears only receipt '+kind)
			var loaded=Save.load_local(PATH);check(loaded.collection.pending.is_empty() and loaded.collection.heroes==before.collection.heroes and loaded.collection.opened==before.collection.opened,'Acknowledgement persists '+kind)
			if destination=='ZUM INVENTAR':
				check(g.garage.slot==('weapon' if receipt.hero else C.catalog().items[receipt.id].slot),'Inventory category matches actual reward '+kind)
				await tap('ZURÜCK');check(heading('DEINE MAYHEM CREW'),'Inventory back button still works '+kind)
			else:await tap('HAUPTMENÜ');check(g.state==g.State.MAIN_MENU,'Cases main menu still works '+kind)
	# Two real GUI taps queued in one frame: the first destination wins.
	fresh('crew');await settle();var double_before=g.saved.duplicate(true)
	for label in ['ZUM INVENTAR','WEITERE CASES']:
		var b=button(label);var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=at;e.global_position=at;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true)
	await settle();check(heading('MAYHEM GARAGE') and same_rewards(double_before),'First queued navigation wins without duplicate reward')
	# Previously saved pending rewards must recover after installing the fix.
	fresh('crew');g.saved=Save.load_local(PATH);var before=g.saved.duplicate(true);g.garage.cases();await tap('ZUM INVENTAR')
	check(heading('MAYHEM GARAGE') and same_rewards(before),'Saved stuck reveal recovers without another draw')
	fresh('crew',true);before=g.saved.duplicate(true);check(g.saved.collection.pending.duplicate,'Duplicate fixture');await tap('ZUM INVENTAR');check(heading('MAYHEM GARAGE') and same_rewards(before),'Duplicate parts preserved exactly')
	# Failed persistence keeps the reward and allows a real retry.
	fresh('style');before=g.saved.duplicate(true);g.garage.save_path='user://missing_case_navigation_0211/state.json';await tap('WEITERE CASES')
	check(g.saved==before and not g.saved.collection.pending.is_empty(),'Failed acknowledgement rolls back and retains reward')
	g.garage.save_path=PATH;await tap('WEITERE CASES');check(heading('MAYHEM CASES') and same_rewards(before),'Real retry works after saving recovers')
	# Production animation and skip route, not a test-mode-only reveal.
	for skip in [false,true]:
		fresh('crew',false,true);await settle();check(not heading('NEUER FIGHTER!'),'Production case animation starts')
		if skip:await tap('ÜBERSPRINGEN')
		else:
			for node in g.ui_root.get_children():
				if node.get_script()==preload('res://scripts/ui/case_opening.gd'):node._process(1.6);break
			await settle()
		before=g.saved.duplicate(true);await tap('ZUM INVENTAR');check(heading('MAYHEM GARAGE') and same_rewards(before),'Animated/skip route leaves reveal '+str(skip))
	# Safe-area-scaled controls remain hittable on wider displays and tablets.
	for dimensions in [Vector2i(2340,1080),Vector2i(1920,1440)]:
		root.size=dimensions;await settle();g.update_safe_area();fresh('arsenal');before=g.saved.duplicate(true);await tap('WEITERE CASES');check(heading('MAYHEM CASES') and same_rewards(before),'Scaled GUI navigation '+str(dimensions))
	g.saved=original;g.test_mode=true;g.save_game();g.free();await process_frame;DirAccess.remove_absolute(PATH)
	print('CASE NAVIGATION RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)
