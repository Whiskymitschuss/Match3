extends SceneTree
var passed=0
var failed=0
func check(ok: bool, label: String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	var expected=[['hammer'],['blaster','splitgun','arc'],['orbit']]
	for hero in range(3):
		g.selected=hero
		g.start_run()
		g.begin_wave()
		check(g.allowed_weapon_ids()==expected[hero],'Character weapon policy '+str(hero))
		check(g.can_equip_weapon(g.weapons[0].id),'Starter always permitted '+str(hero))
		g.open_shop()
		var valid=true
		for sample in range(40):
			g.generate_offers()
			for o in g.offers:
				if o.type=='weapon' and not expected[hero].has(o.id): valid=false
		check(valid,'40 randomized shops contain only class weapons '+str(hero))
		for id in g.weapon_data:
			g.start_run()
			g.begin_wave()
			g.open_shop()
			g.coins=1000
			g.offers=[{'type':'weapon','id':id,'name':g.weapon_data[id].name,'description':'test','price':30,'rarity':'STANDARD'}]
			var before=g.weapons.duplicate(true)
			var result=g.buy_offer(0)
			if expected[hero].has(id):check(result and g.coins==970,'Permitted purchase '+str(hero)+' '+id)
			else:check(not result and g.coins==1000 and g.weapons==before,'Forbidden purchase rejected without mutation '+str(hero)+' '+id)
		g.start_run()
		g.begin_wave()
		check(g.valid_upgrade('projectile')==(hero==1),'Useless projectile upgrade filtered '+str(hero))
		check(g.valid_upgrade('multi')==(hero==1),'Useless multishot upgrade filtered '+str(hero))
		var ids=g.weapon_summary()
		for u in g.upgrades:g.apply_upgrade(u[0])
		check(ids==g.weapon_summary(),'Stat upgrades cannot grant cross-class weapons '+str(hero))
		# Synthetic legacy inventory: even then, the rig provides just one two-hand pose.
		g.weapons=[]
		for id in ['blaster','splitgun','arc','hammer']:g.weapons.append({'id':id,'level':3,'clock':0.0})
		var geometry_ok=true
		for j in range(16):
			g.combat_visuals.rig('blaster').angle=j*TAU/16
			var pose=g.combat_visuals.held_pose()
			var hands=g.combat_visuals.hand_positions()
			if hands.size()!=2 or pose.id!='blaster':geometry_ok=false
			for point in hands:
				if not point.is_finite() or point.distance_to(g.player.position)>110:geometry_ok=false
		check(geometry_ok,'One held weapon and exactly two finite grip points over 16 aim angles '+str(hero))
		g.weapons=[{'id':'orbit','level':1,'clock':0.0}]
		check(g.combat_visuals.held_pose().is_empty() and g.combat_visuals.hand_positions().size()==2,'Orbit weapon adds no extra holding hands '+str(hero))
		g.cleanup()
		check(g.combat_visuals.rigs.is_empty() and g.combat_visuals.fx.is_empty(),'Rig state cleared on restart '+str(hero))
	print('CHARACTER POLICY RESULT ',passed,' passed, ',failed,' failed')
	g.queue_free()
	await process_frame
	quit(0 if failed==0 else 1)
