extends SceneTree
var g
var scenarios=0
var steps=0
var peak_enemies=0
var peak_hazards=0
var peak_pool=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.arena_briefings=['foundry']
	for hero in [0,1,5]:
		for quality in ['LOW','MEDIUM','HIGH']:
			g.main_menu();g.selected=hero;g.arena_id='foundry';g.run_mode='campaign';g.saved.settings.quality=quality;g.start_run();g.wave_number=9;g.begin_wave();g.rng.seed=2401;g.max_hp=100000;g.hp=g.max_hp;g.damage_mult=2;g.weapons[0].level=5;g.weapons[0].spec=g.Specs.choices(g.weapons[0].id)[scenarios%2]
			for i in range(100):
				g.spawn_enemy(['grunt','runner','tank'][i%3]);var e=g.enemies.back();e.pos=(g.player.position+Vector2.from_angle(i*TAU/100)*(160+i*3)).clamp(Vector2(50,50),Vector2(2350,1550));e.hp=1000;e.max_hp=1000
			for valve in g.arena_mechanics.valves.stations:g.player.position=valve.pos;g.move_input=Vector2.ZERO;valve.age=7.6;g.arena_mechanics.update(.81)
			for step in range(2400):
				g.remaining=44-step/60.0;g.move_input=Vector2.from_angle(step*.013);g._physics_process(1.0/60);steps+=1
				while g.state==g.State.LEVEL_UP:g.apply_upgrade('vital');g.if_more_levels()
				assert(g.state==g.State.COMBAT and g.player.position.is_finite() and is_finite(g.hp))
				peak_enemies=maxi(peak_enemies,g.enemies.size());peak_hazards=maxi(peak_hazards,g.arena_mechanics.hazards.size());peak_pool=maxi(peak_pool,g.shots.size())
				assert(g.enemies.size()<=100 and g.arena_mechanics.hazards.size()<=6 and g.shots.size()<=320 and g.loot.size()<=240)
			g.wave_number=10;g.begin_wave();var boss=g.enemies[0];boss.pos=g.player.position+Vector2(200,0);g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01)
			for step in range(240):
				g.remaining=80;g._physics_process(1.0/60);steps+=1
				while g.state==g.State.LEVEL_UP:g.apply_upgrade('vital');g.if_more_levels()
				assert(g.state==g.State.COMBAT and g.arena_mechanics.hazards.size()<=6)
			g.pause_game();var timer=g.remaining;g._physics_process(3);assert(g.remaining==timer);g.resume();g.cleanup();g.cleanup();assert(g.arena_mechanics.hazards.is_empty() and g.arena_mechanics.valves.stations.is_empty());scenarios+=1
			print('FOUNDRY SOAK ',hero,' ',quality,' complete')
	print('FOUNDRY SOAK PASS scenarios=',scenarios,' simulation_steps=',steps,' simulated_seconds=',steps/60.0,' peak_enemies=',peak_enemies,' arena_hazards=',peak_hazards,' projectile_pool=',peak_pool)
	g.saved=original;g.save_game();g.free();await process_frame;quit()
