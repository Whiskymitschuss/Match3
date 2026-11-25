extends SceneTree
# Controlled simulation with large HP reserves; not evidence of human difficulty or FPS.
var g
var frames=0
var scenarios=0
var failed=0
var peak_hazards=0
var peak_shots=0
func _initialize():call_deferred('run')
func require(ok:bool,label:String):
	if not ok:failed+=1;push_error('FAIL '+label)
func start(hero:int,arena:String,wave:int,quality:String):
	g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode='campaign';g.saved.settings.quality=quality;g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.orbit_angle=0;g.rng.seed=2703;g.hp=100000;g.max_hp=g.hp;g.crit=0
	g.weapons[0].level=5;g.weapons[0].spec=g.Specs.choices(g.weapons[0].id)[0]
func advance():
	for step in range(600):
		g.remaining=40;g._physics_process(1.0/60);frames+=1
		peak_hazards=maxi(peak_hazards,g.arena_mechanics.worlds.hazards.size());peak_shots=maxi(peak_shots,g.shots.size())
		require(g.state==g.State.COMBAT and g.enemies.size()<=100 and g.shots.size()<=320 and g.arena_mechanics.worlds.hazards.size()<=6,'Bounded arena and combat simulation')
		require(g.vfx.particles.size()<=g.vfx.limits().particles and g.player.position.is_finite() and is_finite(g.dealt),'Finite positions and bounded visual effects')
		if step==240:
			g.pause_game();var receipt=g.recap.current.duplicate(true);var hazards=g.arena_mechanics.worlds.hazards.duplicate(true);g._physics_process(5)
			require(g.recap.current==receipt and g.arena_mechanics.worlds.hazards==hazards,'Pause freezes active hazards and analysis');g.resume()
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	for hero in [0,5,11]:
		for arena in g.arena_mechanics.worlds.IDS:
			var baseline=[]
			for quality in ['LOW','MEDIUM','HIGH']:
				start(hero,arena,9,quality);g.remaining=49;g.arena_mechanics.update(.01);var world=g.arena_mechanics.worlds
				if world.definition().mode=='relay':
					for at in world.nodes:g.player.position=at;g.arena_mechanics.update(.01)
				else:g.player.position=world.nodes[0];g.arena_mechanics.update(1.01)
				for i in range(100):
					g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=world.nodes.back()+Vector2.from_angle(i*TAU/100)*(90+i%5*20);e.hp=1000000;e.max_hp=e.hp;e.speed=0
				g.hero_ability.activate();advance();var result=[g.dealt,g.hp,g.kills,g.coins]
				start(hero,arena,10,quality);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,0);boss.hp=1000000;boss.max_hp=boss.hp
				g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.hero_ability.activate();advance();result.append_array([g.dealt,g.hp,g.kills,g.coins])
				if quality=='LOW':baseline=result
				else:require(result==baseline,'Quality retains identical gameplay '+arena+' '+str(hero)+' '+quality)
				g.cleanup();g.cleanup();require(world.hazards.is_empty() and world.nodes.is_empty() and world.warmth_left==0 and g.shots.all(func(s):return not s.active),'Repeated cleanup releases active gameplay objects');scenarios+=1
			print('TACTICS SOAK ',arena,' hero=',hero,' qualities identical')
	print('TACTICS SOAK ',('PASS' if failed==0 else 'FAIL'),' scenarios=',scenarios,' simulation_frames=',frames,' simulated_seconds=',frames/60.0,' enemies=100 peak_hazards=',peak_hazards,' peak_projectile_pool=',peak_shots,'; controlled simulation, not human balance')
	g.saved=original;g.save_game();g.free();await process_frame;quit(1 if failed else 0)
