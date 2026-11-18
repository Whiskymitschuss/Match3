extends SceneTree
var g
var failed=0
var frames=0
var scenarios=0
var peak_fx=0
var peak_enemies=0
var quality_results={}
func _initialize():call_deferred('run')
func require(ok:bool,label:String):
	if not ok:failed+=1;push_error('FAIL '+label)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	for hero in range(3):
		for spec in ['',g.Specs.choices(['hammer','blaster','orbit'][hero])[0],g.Specs.choices(['hammer','blaster','orbit'][hero])[1]]:
			for quality in ['LOW','MEDIUM','HIGH']:
				g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.start_run();g.wave_number=9;g.begin_wave();g.spawn_clock=999;g.orbit_angle=0;g.rng.seed=2501;g.saved.settings.quality=quality;g.run_items.add(g.synergies.module_id());g.hp=100000;g.max_hp=100000;g.crit=.15
				g.weapons[0].level=5
				if not spec.is_empty():g.weapons[0].spec=spec
				if hero==1:g.weapons.append({'id':'arc','level':5,'clock':0.0,'spec':'conductor'})
				for i in range(100):
					g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+Vector2.from_angle(i*TAU/100)*(75+i%5*12);e.hp=100000;e.max_hp=e.hp;e.speed=0
				for step in range(600):
					g.remaining=80;g.hero_ability.activate();g._physics_process(1.0/60);frames+=1
					while g.state==g.State.LEVEL_UP:g.apply_upgrade('vital');g.if_more_levels()
					peak_fx=maxi(peak_fx,g.synergies.fx.size());peak_enemies=maxi(peak_enemies,g.enemies.size())
					require(g.state==g.State.COMBAT and g.enemies.size()<=100 and g.shots.size()<=320 and g.synergies.fx.size()<=(4 if quality=='LOW' else (8 if quality=='MEDIUM' else 12)),'Combat and object limits')
				var key=str(hero)+spec;var result=[g.dealt,g.synergies.procs,g.kills]
				if quality=='LOW':quality_results[key]=result
				else:require(quality_results[key]==result,'Graphics quality changes no damage or proc counts '+key+' '+quality)
				require(g.synergies.procs>0,'Actual combat triggers module '+key);g.cleanup();require(g.synergies.fx.is_empty() and g.synergies.armed==0,'Cleanup');scenarios+=1
			print('SYNERGIES SOAK ',hero,' ',spec,' qualities identical')
	print('SYNERGIES SOAK ',('PASS' if failed==0 else 'FAIL'),' scenarios=',scenarios,' simulation_frames=',frames,' simulated_seconds=',frames/60.0,' peak_enemies=',peak_enemies,' peak_fx=',peak_fx,' all quality damage/proc counts identical')
	g.saved=original;g.save_game();g.free();await process_frame;quit(1 if failed else 0)
