extends SceneTree
var g
var steps=0
var peak=0
var peak_hazards=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1
	for difficulty in g.Difficulty.IDS:
		for arena in g.Arenas.IDS:
			g.selected_difficulty=difficulty;g.selected=3;g.arena_id=arena;g.run_mode='campaign';g.start_run();g.wave_number=6;g.begin_wave();g.remaining=42;g.rng.seed=160;g.hp=100000;g.max_hp=100000;g.weapons[0].level=5
			for kind in ['bombling','longshot','hexling']:g.spawn_enemy(kind)
			for i in range(1800):
				if g.state==g.State.LEVEL_UP:g.if_more_levels()
				if g.state==g.State.COMBAT:
					g.move_input=Vector2.from_angle(i*.004)*.6
					if g.hero_ability.ready_to_use():g.hero_ability.activate()
					g._physics_process(1.0/60)
				steps+=1;peak=maxi(peak,g.enemies.size());peak_hazards=maxi(peak_hazards,g.arena_hazards.items.size())
				assert(g.enemies.size()<=100 and g.player.position.is_finite() and g.arena_hazards.items.size()<=15)
				for kind in g.enemy_pack.CONFIG:assert(g.enemy_pack.count(kind)<=g.enemy_pack.CONFIG[kind].cap)
				for e in g.enemies:assert(is_finite(e.hp) and e.pos.is_finite())
			assert(g.run_events==1)
			print('LIVE SOAK ',difficulty,' ',arena,' enemies=',g.enemies.size(),' event=',g.run_events)
	print('LIVE SOAK PASS steps=',steps,' peak_enemies=',peak,' peak_hazards=',peak_hazards,' all tiers/four arenas/new pack/events, artificial HP and pilot; no Android FPS claim')
	g.queue_free();await process_frame;quit()
