extends SceneTree
var g
var steps=0
var peak=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.kills=500;g.saved.settings.tutorial_complete=true
	for arena in g.Arenas.IDS:
		for hero in range(5):
			g.selected=hero;g.arena_id=arena;g.run_mode='endless';g.start_run();g.wave_number=31;g.begin_wave();g.remaining=60;g.hp=100000;g.max_hp=100000;g.weapons[0].level=5;g.weapons[0].spec=g.Specs.choices(g.weapons[0].id)[0];g.saved.settings.quality=['LOW','MEDIUM','HIGH'][hero%3];g.rng.seed=140
			for i in range(1800):
				if g.state==g.State.LEVEL_UP:g.if_more_levels()
				if g.state==g.State.COMBAT:
					g.move_input=Vector2.from_angle(i*.005)*.6
					if g.hero_ability.ready_to_use():g.hero_ability.activate()
					g._physics_process(1.0/60)
				steps+=1;peak=maxi(peak,g.enemies.size());assert(g.bombs.pool.filter(func(x):return x.active).size()<=16 and g.bombs.queued.size()<=15 and g.bombs.fields.size()<=4)
				assert(g.enemies.size()<=100 and g.player.position.is_finite() and is_finite(g.hp))
				for e in g.enemies:assert(e.pos.is_finite() and is_finite(e.hp) and e.speed<700)
			print('WORLDS SOAK ',arena,' hero=',hero,' alive=',g.enemies.size(),' time=',g.run_time)
	print('WORLDS SOAK PASS steps=',steps,' peak_enemies=',peak,' four arenas / five heroes / wave31 / artificial HP; not Android FPS or human balance proof')
	g.queue_free();await process_frame;quit()
