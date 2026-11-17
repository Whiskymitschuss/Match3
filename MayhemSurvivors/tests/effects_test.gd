extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,message:String):
	if ok:passed+=1;print('PASS ',message)
	else:failed+=1;push_error('FAIL '+message)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=Save.defaults();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	g.start_run();g.begin_wave()
	g.crit=0
	g.spawn_enemy('grunt')
	var enemy=g.enemies[0]
	enemy.pos=g.player.position+Vector2(100,0)
	var pos=enemy.pos
	var health=enemy.hp
	var state=g.rng.state
	g.vfx.enemy_hit(enemy,false)
	check(g.vfx.particles.any(func(p):return p.active and p.blood),'Organic hit emits cartoon droplets')
	check(enemy.pos==pos and enemy.hp==health and g.rng.state==state,'Visual hit never changes position, health or gameplay RNG')
	g.vfx.enemy_hit(enemy,true)
	check(g.vfx.events.any(func(e):return e.kind=='critical') and g.vfx.stains.size()==1,'Critical hit adds starburst and splat')
	g.vfx.clear()
	g.damage_enemy(enemy,10000)
	check(g.kills==1 and g.coins==2 and g.loot.size()==1,'Actual enemy death connects splatter without duplicate rewards')
	check(g.vfx.events.any(func(e):return e.kind=='coin' and e.amount==2),'Coin feedback shows the actual earned reward without legacy death rings')
	check(g.vfx.stains.size()==1 and g.vfx.events.any(func(e):return e.kind=='poof'),'Death paints ground stain and comic poof')
	var decals=g.vfx.stains.size()
	g.damage_enemy(enemy,10000)
	check(g.vfx.stains.size()==decals and g.kills==1,'Repeated death cannot duplicate splatter/rewards')
	var particle=g.vfx.particles.filter(func(p):return p.active)[0]
	var life=particle.life
	var stain_life=g.vfx.stains[0].life
	g.pause_game();g._physics_process(1)
	check(particle.life==life and g.vfx.stains[0].life==stain_life,'Pause freezes particles and ground decals')
	g.resume();g.level_up();g._physics_process(1)
	check(particle.life==life and g.vfx.stains[0].life==stain_life,'Level-up freezes all new effects')
	g.change_state(g.State.COMBAT);g.open_shop();g._physics_process(1)
	check(particle.life==life and g.vfx.stains[0].life==stain_life,'Shop freezes all new effects')
	g.vfx.update(8)
	check(g.vfx.particles.all(func(p):return not p.active) and g.vfx.stains.is_empty() and g.vfx.events.is_empty(),'Expired particles, stains and event slots are released')
	g.start_run();g.begin_wave()
	var seed=g.rng.state
	for quality in ['LOW','MEDIUM','HIGH']:
		g.saved.settings.quality=quality
		g.vfx.clear()
		for i in range(400):
			g.vfx.particle(Vector2.ZERO,Vector2.ONE,Color.WHITE)
			g.vfx.stain(Vector2.ZERO,Color.WHITE,30)
			g.vfx.event('critical',Vector2.ZERO,Color.WHITE)
		var caps=g.vfx.limits()
		check(g.vfx.particles.size()==caps.particles,quality+' particle pool cap respected')
		check(g.vfx.stains.size()==caps.stains and g.vfx.events.size()==caps.events,quality+' decal and event caps respected')
		g.vfx.update(1)
		var old=g.vfx.particles[0]
		g.vfx.particle(Vector2(5,5),Vector2.ZERO,Color.RED,'drop',7,true)
		check(is_same(old,g.vfx.particles[0]) and old.active and old.blood,quality+' expired dictionary slot is reused')
	check(g.rng.state==seed,'Thousands of cosmetic spawns leave gameplay RNG untouched')
	g.saved.settings.quality='HIGH'
	g.vfx.clear()
	for i in range(250):g.vfx.particle(Vector2.ZERO,Vector2.ZERO,Color.WHITE)
	for i in range(75):g.vfx.stain(Vector2.ZERO,Color.WHITE,20);g.vfx.event('charge',Vector2.ZERO,Color.WHITE)
	g.saved.settings.quality='LOW'
	g.vfx.apply_settings()
	check(g.vfx.particles.size()==80 and g.vfx.stains.size()==18 and g.vfx.events.size()==8,'Quality downgrade trims existing backlogs immediately')
	g.vfx.clear()
	g.saved.settings.splatter=true
	g.vfx.stain(Vector2.ZERO,Color.GREEN,30,true)
	g.vfx.stain(Vector2.ONE,Color.BLACK,30,false)
	g.vfx.particle(Vector2.ZERO,Vector2.ZERO,Color.GREEN,'drop',4,true)
	g.vfx.particle(Vector2.ZERO,Vector2.ZERO,Color.YELLOW,'spark',4,false)
	g.saved.settings.splatter=false
	g.vfx.apply_settings()
	check(g.vfx.stains.size()==1 and not g.vfx.stains[0].blood,'Splatter OFF removes stains immediately but preserves blast scorch')
	check(g.vfx.particles.filter(func(p):return p.active).all(func(p):return not p.blood),'Splatter OFF removes active blood particles')
	g.vfx.stain(Vector2.ZERO,Color.GREEN,30)
	g.vfx.particle(Vector2.ZERO,Vector2.ZERO,Color.GREEN,'drop',4,true)
	check(g.vfx.stains.size()==1 and g.vfx.particles.filter(func(p):return p.active).size()==1,'Splatter OFF prevents new blood while sparks remain')
	g.selected=1;g.start_run();g.begin_wave()
	g.vfx.clear()
	g.combat_visuals.attack('blaster',Vector2.RIGHT,1)
	check(g.vfx.events.any(func(e):return e.kind=='muzzle'),'Actual gun attack emits muzzle flash')
	g.combat_visuals.impact(Vector2.ZERO,'orbit')
	check(g.vfx.events.any(func(e):return e.kind=='slash'),'Blade contact emits slash effect')
	g.combat_visuals.beam(Vector2.ZERO,Vector2(200,0))
	check(g.vfx.events.any(func(e):return e.kind=='electric'),'Lightning attack emits electrical branches')
	g.combat_visuals.attack('hammer',Vector2.RIGHT,1)
	check(g.vfx.events.any(func(e):return e.kind=='crack') and g.vfx.events.any(func(e):return e.kind=='sweep'),'Hammer attack emits ground cracks and swing arc')
	g.selected=0;g.start_run();g.begin_wave()
	g.hero_ability.activate()
	check(g.vfx.events.any(func(e):return e.kind=='crack'),'Bruiser ability emits shockwave ground effect')
	g.selected=1;g.start_run();g.begin_wave()
	g.hero_ability.activate();g.hero_ability.update(.7)
	check(g.vfx.events.any(func(e):return e.kind=='explosion'),'Sparky fuse expiry emits electrical explosion')
	g.selected=2;g.start_run();g.begin_wave()
	g.hero_ability.activate()
	check(g.vfx.particles.any(func(p):return p.active and p.kind=='wisp'),'Shade ability emits violet wisps')
	g.vfx.clear()
	g.saved.wins=1
	g.arena_id='reactor';g.start_run();g.begin_wave()
	g.spawn_enemy('boss')
	g.saved.settings.splatter=true
	g.vfx.enemy_hit(g.enemies[0],true)
	check(g.vfx.particles.filter(func(p):return p.active).all(func(p):return not p.blood),'Mechanical reactor guardian emits sparks instead of blood')
	g.vfx.clear()
	g.arena_hazards.bomb(Vector2(100,100),90,1.5)
	g.arena_hazards.update(1.51)
	check(g.vfx.events.any(func(e):return e.kind=='explosion'),'Reactor bomb emits explosion only at actual hazard activation')
	var events=g.vfx.events.size()
	g.arena_hazards.update(.01)
	check(g.vfx.events.size()==events,'Hazard activation event is not repeated every frame')
	g.cleanup()
	check(g.vfx.stains.is_empty() and g.vfx.events.is_empty() and g.vfx.particles.all(func(p):return not p.active),'Cleanup clears effects on wave change and run end')
	var path='user://v051-splatter-test.json'
	g.saved.settings.splatter=false
	Save.save_local(g.saved,path)
	var loaded=Save.load_local(path)
	check(not loaded.settings.splatter,'Splatter preference survives real disk roundtrip')
	loaded.settings.erase('splatter');Save.save_local(loaded,path)
	loaded=Save.load_local(path)
	check(loaded.settings.splatter,'Existing schema-3 save receives enabled default')
	loaded.settings.splatter='invalid';Save.save_local(loaded,path)
	check(Save.load_local(path).settings.splatter,'Malformed setting is safely defaulted')
	DirAccess.remove_absolute(path)
	g.main_menu();g.settings(g.main_menu)
	check(g.ui_root.get_children().any(func(c):return c is Button and c.text.begins_with('CARTOON-SPLATTER:')),'Splatter setting exposed in real touch menu')
	g.queue_free()
	await process_frame
	print('EFFECTS RESULT ',passed,' passed, ',failed,' failed')
	quit(0 if failed==0 else 1)
