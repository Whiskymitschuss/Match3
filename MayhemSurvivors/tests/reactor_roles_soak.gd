extends SceneTree
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	g.saved=g.default_save();g.saved.wins=1
	var peaks={'spitter':0,'drone':0,'shots':0}
	for hero in range(3):
		g.selected=hero;g.arena_id='reactor';g.saved.settings.quality=['LOW','MEDIUM','HIGH'][hero]
		g.start_run();g.wave_number=9;g.begin_wave()
		g.max_hp=100000;g.hp=100000;g.rng.seed=600+hero
		g.weapons=[]
		for id in g.allowed_weapon_ids():g.weapons.append({'id':id,'level':5,'clock':0.0,'spec':g.Specs.choices(id)[hero%2]})
		for i in range(6):g.spawn_enemy('spitter');g.enemies.back().pos=g.player.position+Vector2.from_angle(i*TAU/6)*300
		for i in range(2):g.spawn_enemy('drone');g.enemies.back().pos=g.player.position+Vector2(180,i*150)
		for i in range(92):g.spawn_enemy(['grunt','runner','tank'][i%3])
		for frame in range(3600):
			g.remaining=60;g.move_input=Vector2.from_angle(frame*.007)
			if g.hero_ability.ready_to_use():g.hero_ability.activate()
			g.camera.reset_smoothing()
			g.camera.force_update_scroll()
			g._physics_process(1.0/60)
			while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
			assert(g.state==g.State.COMBAT and g.enemies.size()<=100)
			var spitters=g.enemy_roles.count('spitter');var drones=g.enemy_roles.count('drone')
			assert(spitters<=6 and drones<=2 and g.enemy_roles.drones.size()<=2)
			assert(g.enemies.filter(func(e):return e.kind=='spitter' and e.get('windup',0)>0).size()<=2)
			assert(g.shots.size()<=320 and g.loot.size()<=240)
			assert(g.vfx.particles.size()<=g.vfx.limits().particles)
			peaks.spitter=maxi(peaks.spitter,spitters);peaks.drone=maxi(peaks.drone,drones);peaks.shots=maxi(peaks.shots,g.shots.filter(func(s):return s.active and s.hostile).size())
		print('ROLES SOAK PASS ',g.characters[hero].id,' 3600 steps / 60 simulated seconds, kills=',g.kills)
		g.cleanup()
		assert(g.enemy_roles.drones.is_empty())
	g.queue_free();await process_frame
	print('ROLES SOAK TOTAL 10800 steps / 180 simulated seconds; peaks=',peaks)
	quit()
