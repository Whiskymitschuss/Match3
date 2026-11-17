extends SceneTree
var g
var steps=0
var peak=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();g.saved.wins=1;g.selected=1
	for id in g.Difficulty.IDS:
		for arena in g.Arenas.IDS:
			g.selected_difficulty=id;g.run_mode='endless';g.arena_id=arena;g.start_run();g.wave_number=31;g.begin_wave();g.rng.seed=150;g.hp=100000;g.max_hp=100000;g.weapons[0].level=5;g.weapons[0].spec='piercer'
			for i in range(1800):
				if g.state==g.State.LEVEL_UP:g.if_more_levels()
				if g.state==g.State.COMBAT:
					g.move_input=Vector2.from_angle(i*.004)*.6
					if g.hero_ability.ready_to_use():g.hero_ability.activate()
					g._physics_process(1.0/60)
				steps+=1;peak=maxi(peak,g.enemies.size());assert(g.enemies.size()<=100 and g.player.position.is_finite())
				for e in g.enemies:assert(is_finite(e.hp) and e.pos.is_finite() and e.speed<700)
			print('DIFFICULTY SOAK ',id,' ',arena,' enemies=',g.enemies.size())
	print('DIFFICULTY SOAK PASS steps=',steps,' peak_enemies=',peak,' all tiers/four arenas, artificial HP and pilot, no Android FPS claim')
	g.queue_free();await process_frame;quit()
