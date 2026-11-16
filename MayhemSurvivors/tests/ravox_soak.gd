extends SceneTree
var g
var peak=0
var max_count=0
var max_spawned=0
var steps=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();g.saved.wins=1
	for arena in ['scrapyard','reactor']:
		for hero in range(4):
			g.selected=hero;g.arena_id=arena;g.saved.settings.quality=['LOW','MEDIUM','HIGH'][hero%3];g.start_run();g.wave_number=7;g.begin_wave();g.rng.seed=130;g.hp=100000;g.max_hp=100000;g.spawn_clock=0;g.weapons[0].level=4
			for i in range(3600):
				if g.state==g.State.LEVEL_UP:g.if_more_levels()
				if g.state==g.State.COMBAT:
					g.move_input=Vector2.from_angle(i*.004)*.5
					if g.hero_ability.ready_to_use():g.hero_ability.activate()
					g._physics_process(1.0/60)
				steps+=1
				var count=0;var attacks=0
				for e in g.enemies:
					assert(e.pos.is_finite() and is_finite(e.hp))
					if e.kind=='ravox':
						count+=1
						if e.ravox_stage in ['windup','dash']:attacks+=1
				assert(count<=2 and attacks<=1 and g.enemies.size()<=100)
				peak=maxi(peak,g.enemies.size());max_count=maxi(max_count,count);max_spawned=maxi(max_spawned,int(g.ravox.spawned.get(7,0)))
			assert(int(g.ravox.spawned.get(7,0))<=4)
			print('RAVOX SOAK ',arena,' hero=',hero,' spawned=',g.ravox.spawned.get(7,0),' kills=',g.kills)
	print('RAVOX SOAK PASS steps=',steps,' peak_enemies=',peak,' active_ravox=',max_count,' wave_spawns=',max_spawned,'; artificial HP and pilot, no Android FPS claim')
	g.queue_free();await process_frame;quit()
