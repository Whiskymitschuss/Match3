extends SceneTree
var g
var scenarios=0
var steps=0
var peak_enemies=0
var peak_hazards=0
var peak_shots=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.arena_briefings=['reactor','docks']
	for hero in [0,1]:
		for arena in ['reactor','docks']:
			for quality in ['LOW','MEDIUM','HIGH']:
				g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode='campaign';g.saved.settings.quality=quality;g.start_run();g.wave_number=9;g.begin_wave();g.rng.seed=2307;g.max_hp=100000;g.hp=g.max_hp;g.damage_mult=2;g.weapons[0].level=5;g.weapons[0].spec=g.Specs.choices(g.weapons[0].id)[scenarios%2]
				for i in range(100):
					g.spawn_enemy(['grunt','runner','tank'][i%3]);var e=g.enemies.back();e.pos=(g.player.position+Vector2.from_angle(i*TAU/100)*(180+i*3)).clamp(Vector2(50,50),Vector2(2350,1550));e.hp=1000;e.max_hp=1000
				if arena=='reactor':g.arena_mechanics.charge=3;g.player.position=g.arena_mechanics.terminal;g.move_input=Vector2.ZERO;g.arena_mechanics.update(1.21)
				for step in range(2400):
					g.remaining=44-step/60.0;g.move_input=Vector2.from_angle(step*.013);g._physics_process(1.0/60);steps+=1
					while g.state==g.State.LEVEL_UP:g.apply_upgrade('vital');g.if_more_levels()
					assert(g.state==g.State.COMBAT and g.player.position.is_finite() and is_finite(g.hp))
					peak_enemies=maxi(peak_enemies,g.enemies.size());peak_hazards=maxi(peak_hazards,g.arena_mechanics.hazards.size());peak_shots=maxi(peak_shots,g.shots.size())
					assert(g.enemies.size()<=100 and g.arena_mechanics.hazards.size()<=6 and g.arena_mechanics.cores.size()<=3 and g.shots.size()<=320 and g.loot.size()<=240)
				g.pause_game();var time=g.remaining;g._physics_process(3);assert(g.remaining==time);g.resume();g.cleanup();assert(g.arena_mechanics.hazards.is_empty() and g.arena_mechanics.cores.is_empty());scenarios+=1
				print('ARENA SOAK ',hero,' ',arena,' ',quality,' complete')
	print('ARENA SOAK PASS scenarios=',scenarios,' simulation_steps=',steps,' simulated_seconds=',steps/60.0,' peak_enemies=',peak_enemies,' arena_hazards=',peak_hazards,' projectile_pool=',peak_shots)
	g.saved=original;g.save_game();g.free();await process_frame;quit()
