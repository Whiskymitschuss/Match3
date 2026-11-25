extends SceneTree
var g
var scenarios=0
var frames=0
var failed=0
func _initialize():call_deferred('run')
func require(ok:bool,label:String):
	if not ok:failed+=1;push_error('FAIL '+label)
func settle():
	while g.state==g.State.LEVEL_UP:g.apply_upgrade('vital');g.if_more_levels()
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	for hero in range(g.characters.size()):
		for mode in ['campaign','endless']:
			for quality in ['LOW','MEDIUM','HIGH']:
				g.main_menu();g.selected=hero;g.arena_id=g.united.R.ARENAS[scenarios%10];g.run_mode=mode;g.start_run();g.hp=100000;g.max_hp=g.hp;g.saved.settings.quality=quality;var count=10 if mode=='campaign' else 20
				for wave in range(1,count+1):
					g.wave_number=wave;g.begin_wave();g.spawn_clock=999
					if hero<3 and wave==1:g.run_items.add(g.synergies.module_id())
					if wave==1:
						g.spawn_enemy('grunt');g.enemies.back().pos=g.player.position+Vector2(80,0);g.enemies.back().hp=10000
					for step in range(30):
						g.hero_ability.activate();g._physics_process(1.0/60);frames+=1;settle()
					g.hero_ability.dash.clear();g.united.heroes.invulnerability=0;g.equipped_spell.invulnerability=0;g.hurt_clock=0;g.hurt(2)
					if g.rules.boss_wave():
						var actor=g.enemies.filter(func(e):return e.kind in ['boss','champion','breaker_axel'])[0];g.damage_enemy(actor,1000000000)
					else:g.remaining=0;g._physics_process(1.0/60);frames+=1
					settle();require(g.recap.rows.size()==wave,'Exactly one receipt per finished wave')
					if g.state==g.State.SHOP:g.next_shop_wave()
				if mode=='endless':g.begin_wave();g.hp=1;g.hurt_clock=0;g.hurt(1000000);count+=1
				var report=g.recap.snapshot();require(report.waves.size()==count and report.waves.slice(0,10 if mode=='campaign' else 20).all(func(row):return row.outcome=='cleared') and (mode=='campaign' or report.waves.back().outcome=='defeat'),'All controlled completions captured')
				require(absf(report.totals.seconds-g.run_time)<.01 and absf(report.totals.damage-g.dealt)<.01 and report.totals.kills==g.kills and report.totals.coins==g.earned and report.totals.abilities==g.run_abilities,'Totals match actual game counters')
				require(g.saved.recent_runs[0].analysis==report and g.saved.recent_runs.size()<=20,'Bounded immutable history matches result')
				g.cleanup();require(g.recap.snapshot()==report,'Cleanup does not erase final receipt');scenarios+=1
		print('RECAP SOAK HERO ',g.united.R.HEROES[hero],' / campaign,endless / all qualities complete')
	print('RECAP SOAK ',('PASS' if failed==0 else 'FAIL'),' scenarios=',scenarios,' simulation_frames=',frames,' simulated_seconds=',frames/60.0,'; controlled wave/boss completions, not a human balance test')
	g.saved=original;g.save_game();g.free();await process_frame;quit(1 if failed else 0)
