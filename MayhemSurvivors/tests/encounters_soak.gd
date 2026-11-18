extends SceneTree
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	var peaks={'enemies':0,'hazards':0,'shots':0,'rewards':0}
	for arena in ['scrapyard','reactor']:
		for hero in range(3):
			g.selected=hero;g.arena_id=arena;g.saved.settings.quality=['LOW','MEDIUM','HIGH'][hero];g.start_run()
			g.wave_number=8;g.begin_wave();g.remaining=41;g.max_hp=100000;g.hp=100000;g.rng.seed=1000+hero
			g.weapons=[]
			for id in g.allowed_weapon_ids():g.weapons.append({'id':id,'level':5,'clock':0.0,'spec':g.Specs.choices(id)[hero%2]})
			g.spawn_enemy('tank');var elite=g.enemies.back();elite.pos=g.player.position+Vector2(280,0)
			for i in range(99):g.spawn_enemy(['grunt','runner','tank'][i%3])
			for frame in range(3600):
				g.remaining=40;g.move_input=Vector2.from_angle(frame*.005)
				g.camera.reset_smoothing();g.camera.force_update_scroll()
				if g.hero_ability.ready_to_use():g.hero_ability.activate()
				g._physics_process(1.0/60)
				if frame==3300 and g.enemies.has(elite):g.damage_enemy(elite,1000000) # Explicit lifecycle fixture, not a bot balance claim.
				while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
				assert(g.state==g.State.COMBAT and g.enemies.size()<=100 and g.encounters.hazards.size()<=3 and g.encounters.rewards.size()<=1)
				assert(g.shots.size()<=320 and g.loot.size()<=240)
				peaks.enemies=maxi(peaks.enemies,g.enemies.size());peaks.hazards=maxi(peaks.hazards,g.encounters.hazards.size());peaks.shots=maxi(peaks.shots,g.shots.size());peaks.rewards=maxi(peaks.rewards,g.encounters.rewards.size())
			g.cleanup();g.open_shop()
			while not g.encounters.rewards.is_empty():assert(g.encounters.claim(g.encounters.rewards[0].id,'vital'))
			g.wave_number=10;g.begin_wave();g.max_hp=100000;g.hp=100000
			var boss=g.enemies[0];boss.pos=g.player.position+Vector2(280,0);boss.max_hp=500000;boss.hp=boss.max_hp
			for frame in range(3600):
				g.remaining=90;g.move_input=Vector2.from_angle(frame*.004)
				if frame==1200:boss.hp=boss.max_hp*.64
				if frame==2400:boss.hp=boss.max_hp*.29
				g.camera.reset_smoothing();g.camera.force_update_scroll();g._physics_process(1.0/60)
				while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
				assert(g.state==g.State.COMBAT and g.enemies.size()<=100 and g.encounters.hazards.size()<=3 and g.shots.size()<=320)
				assert(g.enemy_roles.count('spitter')<=6 and g.enemy_roles.count('drone')<=2)
				peaks.hazards=maxi(peaks.hazards,g.encounters.hazards.size());peaks.shots=maxi(peaks.shots,g.shots.size())
			assert(g.encounters.boss_tier==3)
			g.finish(true);assert(g.encounters.hazards.is_empty() and g.enemies.is_empty())
			print('ENCOUNTER SOAK PASS ',arena,' ',g.characters[hero].id,' elite+boss 7200 steps / 120 simulated seconds')
	g.queue_free();await process_frame;OS.delay_msec(180);await process_frame
	print('ENCOUNTER SOAK TOTAL 43200 steps / 720 simulated seconds; peaks=',peaks,'; artificial HP/time fixtures, not Android FPS or real run balancing')
	quit()
