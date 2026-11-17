extends SceneTree
var g
var steps=0
var peak=0
var visited={}
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720)
	await process_frame;await process_frame;g.update_safe_area()
	for hero in range(6):
		for arena in g.Arenas.IDS:
			for difficulty in g.Difficulty.IDS:
				g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;g.saved.settings.quality=['LOW','MEDIUM','HIGH'][hero%3]
				g.selected=hero;g.selected_difficulty=difficulty;g.arena_id=arena;g.run_mode='endless';g.start_run();g.wave_number=15;g.begin_wave();g.rng.seed=190
				g.hp=100000;g.max_hp=100000;g.level=10;g.weapons[0].level=3
				var e:Dictionary=g.breaker.actor();e.hp=100000;e.max_hp=100000;e.pos=g.player.position+Vector2(250,0)
				g.camera.reset_smoothing();g.camera.force_update_scroll()
				for i in range(99):g.spawn_enemy('grunt')
				peak=maxi(peak,g.enemies.size())
				for i in range(3600):
					if i==1200:e.hp=e.max_hp*.65
					if i==2400:e.hp=e.max_hp*.35
					if g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
					g.move_input=Vector2.from_angle(i*.008)*.6
					if g.hero_ability.ready_to_use():g.hero_ability.activate()
					g._physics_process(1.0/60);steps+=1;peak=maxi(peak,g.enemies.size());visited[g.breaker.stage]=true
					assert(g.state==g.State.COMBAT or g.state==g.State.LEVEL_UP)
					assert(g.enemies.size()<=100 and g.player.position.is_finite() and is_finite(g.hp) and g.hp>0)
					assert(g.breaker.rings.size()<=2 and g.breaker.cracks.size()<=6 and g.breaker.stagger_left<=.28 and g.breaker.push_velocity.length()<=360.01)
					for enemy in g.enemies:assert(enemy.pos.is_finite() and is_finite(enemy.hp))
				assert(g.breaker.tier==3)
				print('AXEL SOAK ',g.characters[hero].id,' ',arena,' ',difficulty,' rage=',g.breaker.tier)
	assert(visited.has('windup') and visited.has('hammer') and visited.has('dash'))
	print('AXEL SOAK PASS steps=',steps,' peak_enemies=',peak,' all6 heroes/four arenas/three difficulties; artificial HP/phase triggers and pilot; not Android FPS or human balance')
	g.queue_free();await process_frame;quit()
