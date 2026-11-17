extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,msg:String):
	if ok:passed+=1;print('PASS ',msg)
	else:failed+=1;push_error('FAIL '+msg)
func setup():
	g.arena_id='reactor'
	g.start_run();g.begin_wave()
	g.crit=0
	g.weapons=[]
	g.spawn_clock=100
	g.camera.reset_smoothing()
func add(kind:String,offset:Vector2) -> Dictionary:
	g.spawn_enemy(kind)
	var e=g.enemies.back()
	e.pos=g.player.position+offset
	return e
func hostile() -> Array:return g.shots.filter(func(s):return s.active and s.hostile)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.enemy_pack.enabled=false # Isolate original role spawn weights; new 0.16 mix has dedicated coverage.
	g.saved=Save.defaults();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	g.saved.wins=1
	setup()
	await process_frame
	await process_frame
	var spitter=add('spitter',Vector2(250,0))
	check(spitter.hp==55 and spitter.speed==90 and spitter.damage==6,'Spitter has independent data-driven base stats')
	check(spitter.attack_clock==1.5 and spitter.windup==0,'Spawn grants initial grace period')
	check(g.enemy_roles.visible(spitter.pos),'Combat camera includes test spitter')
	spitter.attack_clock=0
	var normal=(g.player.position-spitter.pos).normalized()*spitter.speed
	var velocity=g.enemy_roles.velocity(spitter,normal,.01)
	check(velocity==Vector2.ZERO and spitter.windup==.9 and hostile().is_empty(),'Visible spitter starts full warning without instant projectile')
	var target=spitter.aim
	g.player.position+=Vector2(0,50)
	g.enemy_roles.velocity(spitter,normal,.89)
	check(hostile().is_empty() and spitter.aim==target,'Warning stays locked and lasts configured duration')
	g.enemy_roles.velocity(spitter,normal,.02)
	check(hostile().size()==1 and hostile()[0].enemy_kind=='spitter','Spitter fires exactly one pooled projectile after warning')
	check(hostile()[0].damage==10 and is_equal_approx(hostile()[0].vel.length(),220),'Enemy projectile uses readable configured damage and speed')
	var direction=(target-hostile()[0].pos).normalized()
	check(hostile()[0].vel.normalized().dot(direction)>.999,'Projectile follows announced target instead of player movement')
	check(spitter.attack_clock==2.8 and spitter.windup==0,'Shot returns to cooldown')
	g.player.position=target
	g.hurt_clock=0
	var player_hp=g.hp
	g.update_shots(1.1)
	check(g.hp==player_hp-10 and hostile().is_empty(),'Pooled spitter shot applies actual swept player collision damage once')
	g.update_shots(.1)
	check(g.hp==player_hp-10,'Consumed spitter shot cannot hit a second time')
	var recycled=g.projectile_pool.acquire(Vector2.ZERO,Vector2.RIGHT,1,true,10,1)
	check(recycled.enemy_kind=='','Pool reuse clears enemy shot appearance metadata')
	g.projectile_pool.clear()
	g.enemy_roles.velocity(spitter,normal,.1)
	check(hostile().is_empty(),'Cooldown prevents duplicate shot')
	spitter.pos=g.player.position+Vector2(100,0)
	check(g.enemy_roles.velocity(spitter,Vector2.LEFT*90,.1).x>0,'Spitter retreats gently when approached')
	spitter.pos=g.player.position+Vector2(250,0)
	check(g.enemy_roles.velocity(spitter,Vector2.LEFT*90,.1)==Vector2.ZERO,'Spitter holds its preferred engagement distance')
	spitter.pos=g.player.position+Vector2(600,0)
	check(g.enemy_roles.velocity(spitter,Vector2.LEFT*90,.1).x<0,'Distant spitter approaches rather than camping forever')
	g.projectile_pool.clear()
	spitter.pos=Vector2(-100,-100);spitter.attack_clock=0
	g.enemy_roles.velocity(spitter,normal,1)
	check(spitter.windup==0 and hostile().is_empty(),'Offscreen spitter cannot start an unseen attack')
	spitter.windup=.01;spitter.aim=g.player.position
	g.enemy_roles.velocity(spitter,normal,.02)
	check(hostile().is_empty(),'Spitter leaving view during warning does not fire offscreen')
	setup()
	spitter=add('spitter',Vector2(250,0));spitter.attack_clock=0
	g.enemy_roles.velocity(spitter,Vector2.LEFT*90,10)
	check(spitter.windup==.9 and hostile().is_empty(),'Long frame still starts full warning instead of skipping windup')
	g.damage_enemy(spitter,10000)
	g.update_enemies(1)
	check(hostile().is_empty(),'Killed spitter cannot finish a pending shot')
	setup()
	for i in range(3):
		var e=add('spitter',Vector2(210+i*20,i*30))
		e.attack_clock=0
		g.enemy_roles.velocity(e,Vector2.LEFT*90,.01)
	check(g.enemies.filter(func(e):return e.get('windup',0)>0).size()==2,'At most two spitter warnings overlap')
	var caster=g.enemies[0]
	var windup=caster.windup
	g.pause_game();g._physics_process(1)
	check(caster.windup==windup and hostile().is_empty(),'Pause freezes warning and prevents firing')
	g.resume();g.level_up();g._physics_process(1)
	check(caster.windup==windup,'Level-up freezes new enemy AI')
	g.change_state(g.State.COMBAT);g.open_shop();g._physics_process(1)
	check(caster.windup==windup,'Shop freezes new enemy AI')
	setup()
	var drone=add('drone',Vector2(150,0))
	var grunt=add('grunt',Vector2(200,0))
	var boss=add('boss',Vector2(210,0))
	check(drone.hp==75 and drone.speed==80 and drone.damage==4,'Drone uses its own stats')
	check(is_equal_approx(g.enemy_roles.velocity(drone,Vector2.RIGHT*drone.speed,.1).length(),80),'Drone movement honors configured speed without hidden multipliers')
	check(is_equal_approx(g.enemy_roles.damage_factor(grunt),.7),'Nearby ally receives 30 percent damage reduction')
	check(g.enemy_roles.damage_factor(drone)==1 and g.enemy_roles.damage_factor(boss)==1,'Drones and bosses never receive drone protection')
	var hp=grunt.hp
	g.damage_enemy(grunt,10)
	check(is_equal_approx(grunt.hp,hp-7) and is_equal_approx(g.dealt,7),'Real damage and statistics account for shield reduction')
	var second=add('drone',Vector2(160,0))
	check(is_equal_approx(g.enemy_roles.damage_factor(grunt),.7),'Overlapping drones never stack reduction')
	grunt.pos=g.player.position+Vector2(600,0)
	check(g.enemy_roles.damage_factor(grunt)==1,'Leaving aura immediately removes protection')
	grunt.pos=g.player.position+Vector2(200,0)
	g.damage_enemy(drone,10000)
	check(g.enemy_roles.drones.size()==1 and is_equal_approx(g.enemy_roles.damage_factor(grunt),.7),'Remaining live drone still supplies one shield')
	g.damage_enemy(second,10000)
	check(g.enemy_roles.drones.is_empty() and g.enemy_roles.damage_factor(grunt)==1,'Killing final drone immediately releases all allies')
	hp=grunt.hp
	g.damage_enemy(grunt,10)
	check(is_equal_approx(grunt.hp,hp-10),'Damage returns to full value after drone death')
	setup()
	spitter=add('spitter',Vector2(200,0))
	g.damage_enemy(spitter,10000)
	check(g.kills==1 and g.coins==4 and g.loot[0].xp==8,'Spitter awards correct coins and XP')
	g.damage_enemy(spitter,10000)
	check(g.kills==1 and g.coins==4,'Spitter death/rewards cannot be duplicated')
	drone=add('drone',Vector2(200,0))
	g.damage_enemy(drone,10000)
	check(g.kills==2 and g.coins==9 and g.loot[1].xp==10,'Drone awards configured rewards')
	check(g.vfx.particles.filter(func(p):return p.active and p.get('blood',false)).size()>0,'Organic spitter emits its own cartoon splatter')
	g.vfx.clear();drone=add('drone',Vector2(200,0))
	g.vfx.enemy_hit(drone,true)
	check(g.vfx.particles.filter(func(p):return p.active).all(func(p):return not p.blood),'Mechanical drone emits sparks without blood')
	setup()
	for i in range(6):g.spawn_enemy('spitter')
	check(not g.spawn_enemy('spitter') and g.enemy_roles.count('spitter')==6,'Central spawn API enforces six-spitter cap')
	for i in range(2):g.spawn_enemy('drone')
	check(not g.spawn_enemy('drone') and g.enemy_roles.count('drone')==2,'Central spawn API enforces two-drone cap')
	check(g.enemy_roles.spawn_kind({'tank_weight':0,'runner_weight':0,'spitter_weight':.5,'drone_weight':.5},.1)=='grunt','Capped spitter roll becomes grunt instead of increasing spawn count')
	check(g.enemy_roles.spawn_kind({'tank_weight':0,'runner_weight':0,'spitter_weight':.5,'drone_weight':.5},.8)=='grunt','Capped drone roll becomes grunt')
	setup()
	for i in range(10):
		var wave=g.waves[i]
		var total=wave.tank_weight+wave.runner_weight+wave.spitter_weight+wave.drone_weight
		check(total<=1 and wave.duration==(90 if i==9 else 60),'Valid normalized composition and unchanged duration wave '+str(i+1))
		if i==0:check(wave.spitter_weight==0 and wave.drone_weight==0,'Wave one remains familiar without new enemies')
		if i==1:check(wave.spitter_weight>0 and wave.drone_weight==0,'Spitter introduced from wave two')
		if i==3:check(wave.drone_weight>0,'Shield drone introduced from wave four')
	for entry in [[2,'spitter',.4,.5],[4,'drone',.62,.68]]:
		setup()
		g.wave_number=entry[0]
		var seed=1
		for candidate in range(1,1000):
			g.rng.seed=candidate
			var value=g.rng.randf()
			if value>=entry[2] and value<entry[3]:seed=candidate;break
		g.rng.seed=seed
		g.spawn_clock=0
		g._physics_process(.01)
		check(g.enemies.size()==1 and g.enemies[0].kind==entry[1],'Actual wave spawner produces '+entry[1]+' at its introduction wave')
	for kind in ['spitter','drone']:
		var region=g.world_visuals.region(kind)
		check(Rect2(Vector2.ZERO,g.world_visuals.ROLE_ART.get_size()).encloses(region),kind+' sprite region fits actual generated atlas')
		check(g.world_visuals.dimensions(27,kind).is_finite(),kind+' art dimensions valid')
	setup()
	drone=add('drone',Vector2(100,0))
	g.arena_id='scrapyard'
	grunt=add('grunt',Vector2(150,0))
	check(g.enemy_roles.damage_factor(grunt)==1,'Classic arena cannot inherit reactor shielding')
	g.cleanup()
	check(g.enemy_roles.drones.is_empty() and hostile().is_empty(),'Cleanup removes shields and hostile projectiles')
	g.start_run();g.begin_wave()
	check(g.waves[0].interval==1.5 and g.enemies.is_empty(),'Arena change returns to original classic wave configuration')
	g.arena_id='reactor';g.start_run();g.begin_wave()
	spitter=add('spitter',Vector2(200,0));spitter.windup=.9
	g._notification(MainLoop.NOTIFICATION_APPLICATION_PAUSED)
	g._physics_process(1)
	check(g.state==g.State.PAUSED and spitter.windup==.9,'Android interruption freezes spitter windup')
	g.queue_free()
	await process_frame
	print('REACTOR ROLES RESULT ',passed,' passed, ',failed,' failed')
	quit(0 if failed==0 else 1)
