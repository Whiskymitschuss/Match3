extends SceneTree
# Reproducible stationary-target weapon throughput, not human encounter duration.
const R=preload('res://scripts/core/roster.gd')
const CONFIG={2:[2,1.24,.10,.05,0],4:[3,1.60,.30,.10,1],6:[4,1.84,.45,.10,2],8:[5,1.96,.60,.15,2],10:[5,2.20,.70,.15,3]}
var g
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	var result=[]
	for hero in range(11):
		for weapon in R.ALLOWED[R.HEROES[hero]]:
			for wave in [2,4,6,8,10]:
				var config=CONFIG[wave];var paths=[''] if wave<8 else g.Specs.choices(weapon)
				for spec in paths:
					g.main_menu();g.selected=hero;g.arena_id='docks';g.run_mode='campaign';g.start_run();g.wave_number=wave;g.begin_wave();g.rng.seed=212003
					g.weapons=[{'id':weapon,'level':int(config[0]),'clock':0.0,'spec':spec}];g.damage_mult=config[1];g.attack_mult=1+g.characters[hero].attack_speed_bonus+config[2];g.crit=.05+g.characters[hero].crit_bonus+config[3];g.multishot=int(config[4]);g.dealt=0
					var boss=g.enemies[0];var hp=boss.hp;boss.hp=100000000;boss.max_hp=boss.hp;boss.pos=g.player.position+Vector2(95 if weapon=='hammer' else (110 if weapon in ['orbit','mop','tools','lance','flamer'] else 220),0)
					for i in range(900):
						boss.pos=g.player.position+Vector2(95 if weapon=='hammer' else (110 if weapon in ['orbit','mop','tools','lance','flamer'] else 220),0);boss.orbit_cd=maxf(0,boss.orbit_cd-1.0/60)
						g.run_time+=1.0/60;g.orbit_angle+=3.5/60;g.update_weapons(1.0/60);g.update_shots(1.0/60);g.twinkle.update(1.0/60);g.bombs.update(1.0/60);g.steelfist.update(1.0/60);g.united.heroes.update(1.0/60)
					var dps=g.dealt/15.0
					result.append({'hero':R.HEROES[hero],'weapon':weapon,'spec':spec,'wave':wave,'hp':hp,'dps':snappedf(dps,.01),'stationary_ttk':snappedf(hp/maxf(.01,dps),.1)})
	var output='user://boss_balance_probe.json'
	if not OS.get_cmdline_user_args().is_empty():output=OS.get_cmdline_user_args()[0]
	var file=FileAccess.open(output,FileAccess.WRITE);file.store_string(JSON.stringify(result,'\t'));file.close()
	print('BOSS THROUGHPUT PROBE PASS scenarios=',result.size(),' output=',output,'; fixed seed;15s each; no movement or active abilities; not human balance proof')
	g.saved=original;g.save_game();g.free();await process_frame;quit()
