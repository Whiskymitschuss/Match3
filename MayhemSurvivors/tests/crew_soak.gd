extends SceneTree
var g
var failed=0
var frames=0
var scenarios=0
var peak_shots=0
var peak_particles=0
var baseline={}
func _initialize():call_deferred('run')
func require(ok:bool,label:String):
	if not ok:failed+=1;push_error('FAIL '+label)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	for hero in range(11,15):
		for quality in ['LOW','MEDIUM','HIGH']:
			g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.run_mode='campaign';g.start_run();g.wave_number=9;g.begin_wave();g.rng.seed=2619;g.orbit_angle=0;g.spawn_clock=999;g.hp=100000;g.max_hp=g.hp;g.saved.settings.quality=quality;g.weapons[0].level=5;g.weapons[0].spec=g.Specs.choices(g.weapons[0].id)[0]
			for i in range(100):
				g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2.from_angle(i*TAU/100)*(80+(i%5)*10);e.hp=100000;e.max_hp=e.hp;e.speed=0
			for step in range(600):
				g.remaining=80;g.hero_ability.activate();g._physics_process(1.0/60);frames+=1
				peak_shots=maxi(peak_shots,g.shots.size());peak_particles=maxi(peak_particles,g.vfx.particles.size())
				require(g.state==g.State.COMBAT and g.enemies.size()<=100 and g.shots.size()<=320 and g.vfx.particles.size()<=g.vfx.limits().particles and g.vfx.events.size()<=g.vfx.limits().events,'New crew shares bounded combat and effect budgets')
			var result=[g.dealt,g.kills,g.coins,g.hp]
			if quality=='LOW':baseline[hero]=result
			else:require(result==baseline[hero],'Quality does not change new fighter combat '+str(hero)+' '+quality)
			require(g.dealt>0,'Real new-class attack damage');g.cleanup();require(g.crew.cloud.is_empty() and g.crew.drone_left==0 and g.crew.shield==0 and g.shots.all(func(s):return not s.active),'Cleanup clears all new class combat objects');scenarios+=1
		print('CREW SOAK ',g.characters[hero].name,' quality results identical')
	print('CREW SOAK ',('PASS' if failed==0 else 'FAIL'),' scenarios=',scenarios,' simulation_frames=',frames,' simulated_seconds=',frames/60.0,' enemies=100 peak_projectile_pool=',peak_shots,' peak_particles=',peak_particles)
	g.saved=original;g.save_game();g.free();await process_frame;quit(1 if failed else 0)
