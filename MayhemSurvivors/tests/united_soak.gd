extends SceneTree
const R=preload('res://scripts/core/roster.gd')
var g
var scenarios=0
var frames=0
var peak_enemies=0
var peak_shots=0
var peak_hazards=0
func _initialize():call_deferred('run')
func limits():
	peak_enemies=maxi(peak_enemies,g.enemies.size());peak_shots=maxi(peak_shots,g.shots.size());peak_hazards=maxi(peak_hazards,g.united.enemies.hazards.size())
	assert(g.enemies.size()<=100 and g.shots.size()<=320 and g.loot.size()<=240)
	assert(g.united.enemies.hazards.size()<=12 and g.united.heroes.fire_fields.size()<=6)
	assert(g.arena_mechanics.hazards.size()<=6 and g.arena_mechanics.cores.size()<=3)
	assert(g.player.position.is_finite() and is_finite(g.hp) and is_finite(g.dealt))
	for e in g.enemies:assert(e.pos.is_finite() and is_finite(e.hp) and e.hp>0)
	assert(g.state==g.State.COMBAT)
func advance(count:int):
	for step in range(count):
		g.remaining=80;g.move_input=Vector2.from_angle(frames*.013);g._physics_process(1.0/60);frames+=1
		while g.state==g.State.LEVEL_UP:g.apply_upgrade('vital');g.if_more_levels()
		limits()
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	var started=Time.get_ticks_usec()
	for hero in range(11):
		for arena in R.ARENAS:
			g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode='campaign';g.start_run();g.wave_number=9;g.begin_wave();g.rng.seed=2117+hero;g.max_hp=100000;g.hp=g.max_hp;g.coins=900
			g.weapons[0].level=5;var choices=g.Specs.choices(g.weapons[0].id);g.weapons[0].spec=choices[scenarios%2]
			for kind in ['grunt','runner','tank','ravox','bombling','longshot','hexling']+R.NEW_ENEMIES:
				if not g.spawn_enemy(kind):continue
				var e=g.enemies.back();e.pos=g.player.position+Vector2.from_angle(g.enemies.size()*TAU/17)*220;e.hp=5000;e.max_hp=5000
			g.hero_ability.activate();advance(360)
			g.wave_number=10;g.begin_wave();g.max_hp=100000;g.hp=g.max_hp;var boss=g.enemies[0];boss.pos=g.player.position+Vector2(240,0);boss.hp=boss.max_hp*.3;g.united.bosses.update(.01)
			for pattern in range(4):g.united.bosses.stage='chase';g.united.bosses.pattern=pattern;g.united.bosses.clock=0;g.united.bosses.update(.01);advance(120)
			g.pause_game();var at=g.player.position;var timer=g.remaining;g._physics_process(3);assert(g.player.position==at and g.remaining==timer);g.resume()
			g.cleanup();assert(g.arena_mechanics.hazards.is_empty() and g.arena_mechanics.cores.is_empty())
			g.cleanup();assert(g.enemies.is_empty() and g.united.enemies.hazards.is_empty() and g.united.heroes.fire_fields.is_empty() and g.shots.all(func(s):return not s.active))
			scenarios+=1
		print('UNITED SOAK HERO ',R.HEROES[hero],' / 10 arenas complete')
	print('UNITED SOAK PASS scenarios=',scenarios,' simulation_frames=',frames,' simulated_seconds=',frames/60.0,' peak_enemies=',peak_enemies,' projectile_pool=',peak_shots,' hazards=',peak_hazards,' wall_seconds=',(Time.get_ticks_usec()-started)/1000000.0)
	g.saved=original;g.save_game();g.free();await process_frame;quit()
