extends SceneTree
const Specs=preload('res://scripts/weapons/specializations.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const Records=preload('res://scripts/progression/run_records.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,text:String):
	if ok:passed+=1;print('PASS ',text)
	else:failed+=1;push_error('FAIL '+text)
func near(a:float,b:float) -> bool:return absf(a-b)<.001
func setup(weapon:String,spec:String=''):
	g.selected=0 if weapon=='hammer' else (2 if weapon=='orbit' else 1)
	g.start_run()
	g.begin_wave()
	g.crit=0
	g.attack_mult=1
	g.damage_mult=1
	g.weapons=[{'id':weapon,'level':5,'clock':0.0}]
	if not spec.is_empty():g.weapons[0].spec=spec
	g.spawn_clock=100
func enemy(offset:Vector2) -> Dictionary:
	g.spawn_enemy('grunt')
	var e=g.enemies.back()
	e.pos=g.player.position+offset
	e.hp=1000.0
	e.max_hp=1000.0
	return e
func shots() -> Array:
	return g.shots.filter(func(s):return s.active)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=Save.defaults()
	check(Specs.all().size()==10,'Ten unique specialization definitions')
	for weapon in ['hammer','blaster','splitgun','arc','orbit']:
		check(Specs.choices(weapon).size()==2,'Two choices for '+weapon)
		for id in Specs.choices(weapon):check(Specs.icon(id)!=null,'Real icon loads for '+id)
	setup('hammer')
	g.weapons[0].level=4
	g.open_shop()
	g.offers=[{'type':'weapon','id':'hammer','price':30,'name':'HAMMER','description':'Level 5','rarity':'STANDARD'}]
	g.coins=100
	check(g.buy_offer(0) and g.coins==70 and g.weapons[0].level==5,'Real shop purchase reaches level five and charges once')
	check(g.pending_specialization().id=='hammer' and g.state==g.State.SHOP,'Level-five purchase opens choice while simulation remains stopped')
	await process_frame
	await process_frame
	for child in g.ui_root.get_children():
		if child is Label and child.text in [Specs.all().quake.description,Specs.all().crusher.description]:
			check(child.size.x<=760.1,'Choice description fits its touch card')
	var time=g.run_time
	g._physics_process(1)
	check(g.run_time==time and not g.hero_ability.activate(),'Specialization choice freezes combat, timer and ability input')
	g.next_shop_wave()
	check(g.wave_number==1 and g.state==g.State.SHOP,'Cannot bypass pending choice with next-wave action')
	check(not g.choose_specialization('blaster','piercer') and not g.choose_specialization('hammer','piercer'),'Class and weapon mismatches rejected')
	check(g.choose_specialization('hammer','quake') and g.coins==70,'Valid specialization costs no additional coins')
	check(not g.choose_specialization('hammer','crusher') and g.weapons[0].spec=='quake','Chosen path cannot be switched in the same run')
	check(not g.buy_offer(0) and g.coins==70,'Sold level-five offer cannot be bought twice')
	g.next_shop_wave()
	g.begin_wave()
	check(g.weapons[0].spec=='quake' and g.wave_number==2,'Specialization persists across shop and wave transition')
	g.start_run()
	check(not g.weapons[0].has('spec') and g.weapons[0].level==1,'Fresh run resets all weapon evolution')
	setup('hammer','quake')
	var front=enemy(Vector2(100,0))
	var back=enemy(Vector2(-100,0))
	var far=enemy(Vector2(400,0))
	g.update_weapons(.01)
	check(near(front.hp,953.536) and near(back.hp,953.536) and far.hp==1000,'Earthquake deals configured radial damage including behind player')
	check(near(g.weapons[0].clock,1.15/1.24) and g.specialized_combat.fx.size()==1,'Earthquake has longer cooldown and visible wave effect')
	setup('hammer','crusher')
	front=enemy(Vector2(100,0))
	back=enemy(Vector2(-120,0))
	g.update_weapons(.01)
	check(near(front.hp,947.728) and back.hp==1000,'Crusher hits one closest target with configured damage')
	check(near(g.weapons[0].clock,.6/1.24),'Crusher has faster attack cooldown')
	setup('blaster','piercer')
	var victims:Array=[]
	for i in range(4):victims.append(enemy(Vector2(100+i*100,0)))
	g.update_weapons(.01)
	check(shots().size()==1 and shots()[0].hits_left==3,'Piercing projectile starts with three hit budget')
	var bullet=shots()[0]
	bullet.vel=Vector2(1000,0)
	g.update_shots(.3)
	check(near(victims[0].hp,973.6) and near(victims[1].hp,973.6) and near(victims[2].hp,973.6) and victims[3].hp==1000,'Swept piercer hits three distinct enemies in one long frame')
	check(not bullet.active,'Piercer deactivates after third target')
	setup('blaster','piercer')
	front=enemy(Vector2(100,0))
	g.update_weapons(.01)
	bullet=shots()[0]
	bullet.vel=Vector2(1000,0)
	g.update_shots(.07)
	bullet.vel=Vector2.ZERO
	g.update_shots(.1)
	g.update_shots(.1)
	check(near(front.hp,973.6) and bullet.hits_left==2,'Lingering piercer cannot hit same enemy twice')
	g.cleanup()
	check(bullet.hit_enemies.is_empty(),'Cleanup releases projectile target references')
	var recycled=g.projectile_pool.acquire(Vector2.ZERO,Vector2.RIGHT,5,true,100,2)
	check(recycled.spec=='' and recycled.hit_enemies.is_empty() and recycled.splash_power==0 and recycled.hits_left==1,'Reused hostile projectile never inherits piercing or explosive metadata')
	setup('blaster','blast')
	front=enemy(Vector2(100,0))
	back=enemy(Vector2(155,0))
	far=enemy(Vector2(500,0))
	g.update_weapons(.01)
	shots()[0].vel=Vector2(1000,0)
	g.update_shots(.1)
	check(near(front.hp,978.88) and near(back.hp,985.48) and far.hp==1000,'Explosive shot separates direct and nearby splash damage without double hit')
	g.update_shots(.1)
	check(near(front.hp,978.88) and near(back.hp,985.48),'Spent explosive cannot damage twice')
	setup('blaster','blast')
	front=enemy(Vector2(100,0));front.hp=1
	back=enemy(Vector2(155,0));back.hp=1
	g.update_weapons(.01)
	shots()[0].vel=Vector2(1000,0)
	g.update_shots(.1)
	check(g.kills==2 and g.coins==4 and g.loot.size()==2,'Splash deaths award kills, coins and XP exactly once')
	setup('splitgun','precision')
	front=enemy(Vector2(100,0))
	g.update_weapons(.01)
	check(shots().size()==3 and near(shots()[0].damage,18.48),'Precision fan retains three pellets and increases damage')
	check(near(absf(shots()[0].vel.angle()),.035) and shots()[0].life>.9,'Precision fan narrows spread and extends lifetime/range')
	setup('splitgun','storm')
	front=enemy(Vector2(100,0))
	g.multishot=1
	g.update_weapons(.01)
	check(shots().size()==6 and near(shots()[0].damage,10.78),'Storm adds two pellets, combines with multishot and reduces pellet damage')
	check(absf(shots()[0].vel.angle())>.35,'Storm fan is visibly wider')
	setup('arc','conductor')
	victims=[]
	for i in range(5):victims.append(enemy(Vector2(100+i*200,0)))
	g.update_weapons(.01)
	check(victims.all(func(e):return e.hp<1000),'Conductor chains through five separate targets')
	check(near(victims[0].hp,966.34) and victims[4].hp>victims[0].hp,'Conductor applies reduced base power and chain falloff')
	setup('arc','overcharge')
	front=enemy(Vector2(100,0))
	back=enemy(Vector2(200,0))
	g.update_weapons(.01)
	check(near(front.hp,934.66) and back.hp==1000,'Overcharge boosts single target without chain')
	check(near(g.weapons[0].clock,1.5/1.24*.8),'Overcharge reduces attack cooldown')
	for path in ['wide','swift']:
		setup('orbit',path)
		var d=Specs.all()[path]
		g.orbit_angle=0
		front=enemy(Vector2(d.radius,0))
		g.update_weapons(.01)
		check(near(front.hp,1000-22*d.power),path+' blade uses configured power')
		var pose=g.specialized_combat.orbit_pose(g.weapons[0])
		check(pose.radius==d.radius and pose.size==d.size,path+' visual and damage orbit geometry share same pose')
		check(near(front.orbit_cd,.5/1.32*d.hit_cooldown),path+' uses configured per-target hit cooldown')
		g.orbit_angle=1
		check(near(g.specialized_combat.orbit_pose(g.weapons[0]).angle,d.angular),path+' angular speed matches visual orbit')
	setup('hammer','quake')
	front=enemy(Vector2(100,0))
	g.update_weapons(.01)
	var life=g.specialized_combat.fx[0].life
	g.pause_game()
	g._physics_process(1)
	check(g.specialized_combat.fx[0].life==life,'Pause freezes specialization feedback')
	g.resume()
	g.specialized_combat.update(1)
	check(g.specialized_combat.fx.is_empty(),'Expired specialization effects released')
	for i in range(100):g.specialized_combat.ring(Vector2.ZERO,100,Color.WHITE)
	check(g.specialized_combat.fx.size()<=16,'Specialization effect count bounded')
	g.saved.settings.quality='LOW'
	g.specialized_combat.update(0)
	check(g.specialized_combat.fx.size()==8,'LOW trims existing specialization effects immediately')
	for i in range(20):g.specialized_combat.ring(Vector2.ZERO,100,Color.WHITE)
	check(g.specialized_combat.fx.size()==8,'LOW effect limit remains bounded when effects arrive')
	g.saved.settings.quality='HIGH'
	var path='user://v05-history-test.json'
	var saved=Save.defaults()
	Records.add_run(saved,{'character':'sparky','arena':'reactor','weapons':[{'id':'blaster','level':5,'spec':'piercer'},{'id':'splitgun','level':4,'spec':'storm'},{'id':'arc','level':5,'spec':123}]})
	check(saved.recent_runs[0].weapons[0].spec=='piercer' and not saved.recent_runs[0].weapons[1].has('spec') and not saved.recent_runs[0].weapons[2].has('spec'),'History keeps valid level-five path and strips malformed/early path')
	Save.save_local(saved,path)
	saved=Save.load_local(path)
	check(saved.recent_runs[0].weapons[0].spec=='piercer','Specialization history survives actual save and reload')
	DirAccess.remove_absolute(path)
	check(Records.clean_run({'character':'bruiser','weapons':[{'id':'hammer','level':5}]}).weapons[0].size()==2,'Old histories remain compatible without invented choices')
	setup('blaster')
	g.weapons=[{'id':'blaster','level':5,'clock':0.0},{'id':'arc','level':5,'clock':0.0}]
	g.open_shop()
	check(g.choose_specialization('blaster','piercer') and g.pending_specialization().id=='arc','Several pending weapon choices are handled sequentially')
	check(g.choose_specialization('arc','conductor') and g.pending_specialization().is_empty(),'All pending choices return to functional shop')
	g.main_menu()
	g.test_mode=false
	g.character_select();g.arena_select();g.choose_arena('scrapyard');g.begin_wave()
	g.change_state(g.State.SHOP)
	g.weapons=[{'id':'hammer','level':5,'clock':0.0}]
	g.selected=0
	g.show_shop()
	check(g.choose_specialization('hammer','quake') and g.state==g.State.SHOP,'Choice works with production state transition guards')
	g.test_mode=true
	# State-guard coverage is complete; stop test-only audio before fast boss fixtures.
	for voice in g.sfx_players:voice.stop();voice.stream=null
	g.alert_audio.stop();g.alert_audio.stream=null
	for id in Specs.all():
		var weapon=Specs.all()[id].weapon
		for arena in ['scrapyard','reactor']:
			g.arena_id=arena
			g.saved.wins=1
			setup(weapon,id)
			g.wave_number=10
			g.begin_wave()
			g.crit=0
			var boss=g.enemies[0]
			boss.hp=1
			var distance=Specs.all()[id].get('radius',100) if weapon=='orbit' else 100
			boss.pos=g.player.position+Vector2(distance,0)
			g.orbit_angle=0
			g.update_weapons(.01)
			if g.state==g.State.COMBAT:g.update_shots(.15)
			check(g.state==g.State.VICTORY and g.enemies.is_empty() and g.specialized_combat.fx.is_empty(),id+' boss victory cleanup in '+arena)
			check(g.saved.recent_runs[0].weapons[0].get('spec','')==id,id+' result records selected path')
	g.queue_free()
	await process_frame
	OS.delay_msec(80)
	await process_frame
	print('SPECIALIZATIONS RESULT ',passed,' passed, ',failed,' failed')
	quit(0 if failed==0 else 1)
