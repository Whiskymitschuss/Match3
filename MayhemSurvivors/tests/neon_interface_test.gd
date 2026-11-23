extends SceneTree
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,name:String):
	if ok:passed+=1;print('PASS ',name)
	else:failed+=1;push_error('FAIL '+name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	var icons=g.UISkin.Icons
	for id in icons.IDS:check(icons.get_icon(id)!=null and icons.get_icon(id).get_size()==Vector2(128,128),'Finished graphic resource '+id)
	for u in g.upgrades:check(icons.get_icon(u[0])!=null,'Upgrade uses semantic illustration '+u[0])
	for pair in [['SPIELEN','play'],['PAUSE','pause'],['CHARAKTERE','characters'],['EINSTELLUNGEN','settings'],['42 KAUFEN','coins'],['AUFRÜSTEN','upgrade'],['VERWERTEN','salvage'],['REROLL: GRATIS','reroll'],['HILFE','help']]:check(icons.button_id(pair[0])==pair[1],'Action semantic icon '+pair[0])
	for quality in ['LOW','MEDIUM','HIGH']:
		g.saved.settings.quality=quality;g.main_menu();var bg=g.ui_root.get_node('FullBleedBackdrop')
		check(bg.ART.get_width()>1500,'Real full-screen illustrated background '+quality)
		check(bg.motion==(quality!='LOW') and (bg.get_node('BackdropArt').material==null)==(quality=='LOW'),'Animation and blur obey quality '+quality)
		for child in g.ui_root.get_children():
			if child is Button:check(child.icon!=null and child.motion_enabled==(quality!='LOW'),'Actual navigation has icon and quality-aware feedback')
	g.statistics();check(not g.ui_root.get_node('FullBleedBackdrop').is_home,'Statistics uses a readability scrim even while state remains main menu')
	g.saved.settings.quality='HIGH';g.selected=1;g.start_run();g.begin_wave();g.cleanup();g.coins=500;g.open_shop();g.shop_view.finish_help()
	g.offers=[{'type':'upgrade','id':'vital','name':'VITAL BOOST','description':'+20 HP','price':16,'rarity':'STANDARD'}];g.show_shop()
	var texture_found=false
	for child in g.ui_root.get_children():
		if child is TextureRect and child.texture==icons.get_icon('vital'):texture_found=true
	check(texture_found,'Real shop upgrade displays final icon, not a text symbol')
	var before=g.remaining;g._physics_process(.3);check(g.remaining==before,'Presentation does not resume shop combat')
	g.begin_wave();g.xp=g.required_xp();g.level_up();texture_found=false
	for child in g.ui_root.get_children():
		if child is TextureRect and child.texture!=g.UISkin.STUDIO:texture_found=true
	check(texture_found and g.state==g.State.LEVEL_UP,'Upgrade choices use graphic resources while paused')
	# Animate production menus with sound disabled. Assert settled transforms and rapid-navigation cancellation.
	g.main_menu();g.saved.settings.master=0;g.update_music();g.test_mode=false;g.main_menu()
	await process_frame
	var button:Button=null
	for child in g.ui_root.get_children():
		if child is Button and child.text=='SPIELEN':button=child;break
	check(button!=null and button.modulate.a<1,'Production menu reveal starts visibly faded')
	await create_timer(.55).timeout
	check(is_instance_valid(button) and is_equal_approx(button.modulate.a,1) and button.position==Vector2(115,655),'Reveal settles at exact intended touch position')
	g.character_select();g.main_menu();g.character_select()
	await process_frame;await create_timer(.55).timeout
	check(g.state==g.State.CHARACTER_SELECT,'Rapid navigation cancels stale screen animations')
	for child in g.ui_root.get_children():
		if child is Button:check(is_equal_approx(child.modulate.a,1),'No invisible interactive control remains after transition')
	g.test_mode=true;g.start_run();g.begin_wave();g.cleanup();g.open_shop()
	for id in g.run_items.data:g.run_items.add(id)
	g.finish(false);await process_frame;await process_frame
	var bounded=false
	for child in g.ui_root.get_children():
		if child is Label and child.text.begins_with('GEGENSTÄNDE:'):bounded=child.size.x<=1121 and child.get_line_count()>=2
	check(bounded,'Full eight-item result wraps inside its panel without covering hero art')
	g.queue_free();await process_frame;OS.delay_msec(180);await process_frame
	print('NEON INTERFACE RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)
