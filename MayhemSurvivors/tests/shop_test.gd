extends SceneTree
var g
var passed=0
var failed=0
var previous_save=null
func _initialize():call_deferred('run')
func check(ok:bool,name:String):
	if ok:passed+=1;print('PASS ',name)
	else:failed+=1;push_error('FAIL '+name)
func near(a:float,b:float)->bool:return absf(a-b)<.001
func offer(id:String):
	var d=g.run_items.data[id]
	g.offers=[{'type':'item','id':id,'name':d.name,'description':d.description,'price':int(d.price)+g.wave_number*4,'rarity':d.rarity}]
func run():
	if FileAccess.file_exists('user://save.json'):previous_save=FileAccess.get_file_as_bytes('user://save.json')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.selected=1;g.start_run();g.begin_wave();g.cleanup();g.open_shop()
	check(g.state==g.State.SHOP and not g.saved.settings.shop_help_seen,'First shop opens tutorial without resuming combat')
	for page in range(3):g.shop_view.help_page(page);check(g.state==g.State.SHOP,'Tutorial page '+str(page))
	g.shop_view.finish_help();check(g.saved.settings.shop_help_seen,'Tutorial marked seen')
	g.coins=200;offer('grip');var before=g.coins
	check(g.buy_offer(0) and g.coins==before-26,'Item purchased once at displayed price')
	check(near(g.damage_mult,1.18) and near(g.speed,192),'Item tradeoff and two-piece weapon/item set applied')
	check(not g.buy_offer(0) and not g.run_items.valid('grip'),'Duplicate purchase refused')
	for i in range(10):g.run_items.sync()
	check(near(g.damage_mult,1.18) and near(g.speed,192),'Repeated synchronization never stacks bonuses')
	g.damage_mult+=.12;g.speed*=1.08;g.run_items.sync()
	check(near(g.damage_mult,1.30) and near(g.speed,207.36),'Level upgrades preserved during item synchronization')
	check(g.run_items.add('plate') and g.armor==3,'Third set piece grants armor with item armor')
	check(g.run_items.add('battery') and g.max_hp==80 and near(g.attack_mult,1.23),'Attack boost trades maximum HP')
	check(g.run_items.add('coolant') and near(g.attack_mult,1.31) and near(g.projectile_speed,1.18),'Second set activates attack tempo')
	g.weapons.append({'id':'arc','level':1,'clock':0.0});g.run_items.sync()
	check(near(g.projectile_speed,1.33),'Third flux piece activates projectile bonus')
	var sell=g.run_items.salvage_price(g.weapons.back());before=g.coins
	check(g.run_items.salvage('arc') and g.coins==before+sell and near(g.projectile_speed,1.18),'Salvage refunds coins and removes third-piece bonus')
	check(not g.run_items.salvage('blaster') and g.weapons.size()==1,'Last weapon protected')
	g.coins=0;before=g.weapons[0].level
	check(not g.run_items.upgrade('blaster') and g.weapons[0].level==before,'Unaffordable upgrade refused')
	g.coins=1000
	for i in range(4):check(g.run_items.upgrade('blaster'),'Workbench upgrade '+str(i))
	check(g.weapon_level('blaster')==5 and not g.pending_specialization().is_empty(),'Level five requires specialization')
	check(not g.run_items.upgrade('blaster'),'Maximum level protected')
	var choices=g.Specs.choices('blaster')
	g.choose_specialization('blaster',choices[0])
	check(not g.weapons[0].get('spec','').is_empty(),'Workbench connects to existing evolution system')
	var seen={}
	for i in range(100):
		g.generate_offers()
		for o in g.offers:
			if o.type=='item':seen[o.id]=true
	check(seen.size()==4,'All four remaining valid items occur in generated offers')
	for o in g.offers:check(not (o.type=='item' and g.run_items.owned.has(o.id)),'Owned item omitted from offers')
	var timer=g.remaining;var time=g.run_time
	g._physics_process(1)
	check(g.remaining==timer and g.run_time==time,'Shop and tutorial freeze simulation')
	for tab in ['weapons','items','sets']:g.shop_view.tab=tab;g.show_shop();check(g.state==g.State.SHOP,'Inventory tab '+tab)
	g.shop_view.stats();g.shop_view.weapon_details('blaster');g.shop_view.item_details('grip');check(g.state==g.State.SHOP,'Detail panels retain shop state')
	var record=g.RunRecords.clean_run({'character':'sparky','items':g.run_items.owned})
	check(record.items.size()==4,'Run history retains valid owned items')
	g.SaveManager.save_local(g.saved,'user://shop_test.json')
	check(g.SaveManager.load_local('user://shop_test.json').settings.shop_help_seen,'Tutorial preference survives JSON reload')
	DirAccess.remove_absolute('user://shop_test.json')
	g.next_shop_wave();check(g.wave_number==2 and g.run_items.owned.size()==4,'Items persist between waves')
	g.start_run();check(g.run_items.owned.is_empty() and g.damage_mult==1 and g.speed==200 and g.max_hp==90,'Restart resets all per-run item effects')
	g.crit=.75;check(not g.run_items.valid('lens'),'Crit cap excludes wasted item')
	g.armor=20;check(not g.run_items.valid('plate'),'Armor cap excludes wasted item')
	g.max_hp=30;check(not g.run_items.valid('battery'),'HP floor excludes unsafe tradeoff')
	if previous_save!=null:
		var f=FileAccess.open('user://save.json',FileAccess.WRITE);f.store_buffer(previous_save);f.close()
	else:DirAccess.remove_absolute('user://save.json')
	print('RESULT ',passed,' passed / ',failed,' failed');g.queue_free();await process_frame;quit(1 if failed else 0)
