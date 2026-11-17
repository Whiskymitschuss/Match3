extends SceneTree
var g
var steps=0
var peak=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1
	for difficulty in g.Difficulty.IDS:
		for arena in g.Arenas.IDS:
			for spec in ['pressure_breaker','ratchet_rush']:
				g.selected=5;g.selected_difficulty=difficulty;g.run_mode='endless';g.arena_id=arena;g.start_run();g.wave_number=31;g.begin_wave();g.rng.seed=170;g.hp=100000;g.max_hp=100000;g.weapons[0].level=5;g.weapons[0].spec=spec
				for i in range(1800):
					if g.state==g.State.LEVEL_UP:g.if_more_levels()
					if g.state==g.State.COMBAT:
						g.move_input=Vector2.from_angle(i*.004)*.7
						if g.hero_ability.ready_to_use():g.hero_ability.activate()
						g._physics_process(1.0/60)
					steps+=1;peak=maxi(peak,g.enemies.size())
					assert(g.enemies.size()<=100 and g.player.position.is_finite() and is_finite(g.hp) and g.hp<=g.max_hp and g.steelfist.buff_extension<=5.001 and g.steelfist.buff_left<=10.001 and g.steelfist.sweeps.size()<=4 and g.steelfist.pressure.size()<=3)
					for e in g.enemies:assert(e.pos.is_finite() and is_finite(e.hp))
				print('STEELFIST SOAK ',difficulty,' ',arena,' ',spec,' enemies=',g.enemies.size(),' attacks=',g.steelfist.attacks)
	print('STEELFIST SOAK PASS steps=',steps,' peak_enemies=',peak,' four arenas/three tiers/two tool developments/endless31; artificial HP and pilot, no Android FPS claim')
	g.queue_free();await process_frame;quit()
