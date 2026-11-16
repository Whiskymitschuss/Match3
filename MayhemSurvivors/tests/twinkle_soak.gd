extends SceneTree
var g
var steps=0
var peak_enemies=0
var peak_fields=0
var peak_sweeps=0
var victories=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);g.saved=g.default_save();g.saved.wins=1;g.selected=3;g.saved.settings.shop_help_seen=true
	for arena in ['scrapyard','reactor']:
		for quality in ['LOW','MEDIUM','HIGH']:
			g.arena_id=arena;g.saved.settings.quality=quality;g.start_run();g.wave_number=9;g.begin_wave();g.spawn_clock=0;g.remaining=60
			g.hp=100000;g.max_hp=100000;g.weapons[0].level=5;g.weapons[0].spec='chemical_flood';g.damage_mult=1.5;g.rng.seed=12345
			for i in range(3600):
				if g.state==g.State.LEVEL_UP:g.if_more_levels()
				if g.state==g.State.COMBAT:
					g.move_input=Vector2.from_angle(i*.004)*.65
					if g.hero_ability.ready_to_use():g.hero_ability.activate()
					g._physics_process(1.0/60)
				steps+=1;peak_enemies=maxi(peak_enemies,g.enemies.size());peak_fields=maxi(peak_fields,g.twinkle.puddles.size());peak_sweeps=maxi(peak_sweeps,g.twinkle.sweeps.size())
				assert(g.enemies.size()<=100 and g.twinkle.puddles.size()<=5 and g.twinkle.sweeps.size()<=6)
				assert(is_finite(g.hp) and g.player.position.is_finite())
			g.cleanup();g.wave_number=10;g.begin_wave();g.hp=100000;g.max_hp=100000
			for i in range(6000):
				if g.state==g.State.LEVEL_UP:g.if_more_levels();continue
				if g.state!=g.State.COMBAT:break
				if g.hero_ability.ready_to_use():g.hero_ability.activate()
				var target=g.nearest(g.player.position,5000)
				g.move_input=Vector2.ZERO if target==null else (target.pos-g.player.position).normalized()
				g._physics_process(1.0/60);steps+=1
			assert(g.state in [g.State.VICTORY,g.State.GAME_OVER])
			if g.state==g.State.VICTORY:victories+=1
			assert(g.twinkle.puddles.is_empty() and g.twinkle.tornado_left==0)
			print('SOAK ',arena,' ',quality,' boss_result=',g.state,' time=',g.run_time)
	print('TWINKLE SOAK PASS steps=',steps,' peak_enemies=',peak_enemies,' fields=',peak_fields,' sweeps=',peak_sweeps,' boss_victories=',victories,'/6; artificial HP, deterministic pilot, not Android FPS or human balance proof')
	g.queue_free();await process_frame;quit()
