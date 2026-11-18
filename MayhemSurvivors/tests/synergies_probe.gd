extends SceneTree
# Fixed damage opportunity, no incoming damage or enemy AI. Estimated TTK is not human balance.
const CONFIG={2:[2,1.24,.10,.05,0],4:[3,1.60,.30,.10,1],6:[4,1.84,.45,.10,2],8:[5,1.96,.60,.15,2],10:[5,2.20,.70,.15,3]}
var g
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	var result=[];var failed=0
	for hero in range(3):
		var weapon=['hammer','blaster','orbit'][hero]
		for wave in [2,4,6,8,10]:
			var config=CONFIG[wave];var paths=[''] if wave<8 else ['',g.Specs.choices(weapon)[0],g.Specs.choices(weapon)[1]]
			for spec in paths:
				var baseline=0.0
				for enabled in [false,true]:
					g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.run_mode='campaign';g.start_run();g.wave_number=wave;g.begin_wave();g.rng.seed=2503;g.orbit_angle=0
					g.weapons=[{'id':weapon,'level':int(config[0]),'clock':0.0,'spec':spec}];g.damage_mult=config[1];g.attack_mult=1+g.characters[hero].attack_speed_bonus+config[2];g.crit=.05+g.characters[hero].crit_bonus+config[3];g.multishot=int(config[4]);g.dealt=0
					if enabled:g.run_items.add(g.synergies.module_id())
					var boss=g.enemies[0];var hp=boss.hp;boss.hp=100000000;boss.max_hp=boss.hp
					for frame in range(900):
						g.synergies.update(1.0/60);g.hero_ability.update(1.0/60);g.hero_ability.move_dash(1.0/60)
						var radius=g.specialized_combat.orbit_pose(g.weapons[0]).radius if weapon=='orbit' else (95 if weapon=='hammer' else 220)
						boss.pos=g.player.position+Vector2(radius,0);boss.orbit_cd=maxf(0,boss.orbit_cd-1.0/60)
						g.hero_ability.activate();g.orbit_angle+=3.5/60;g.update_weapons(1.0/60);g.update_shots(1.0/60)
						g.vfx.update(1.0/60);g.combat_visuals.update(1.0/60);g.specialized_combat.update(1.0/60);g.hit_feedback.update(1.0/60)
					var dps=g.dealt/15
					if not enabled:baseline=dps
					elif dps<baseline-.01 or dps>baseline*1.8+.01:failed+=1;push_error('FAIL bounded boss throughput '+weapon+' '+spec+' '+str(wave))
					result.append({'hero':g.characters[hero].id,'wave':wave,'spec':spec,'module':enabled,'boss_hp':hp,'damage_15s':g.dealt,'dps':snappedf(dps,.01),'estimated_stationary_ttk':snappedf(hp/maxf(.01,dps),.1),'gain_percent':snappedf((dps/maxf(.01,baseline)-1)*100,.01),'procs':g.synergies.procs})
	var file=FileAccess.open('res://tests/results/v0.25.0-synergies-probe.json',FileAccess.WRITE);file.store_string(JSON.stringify(result,'\t'));file.close()
	print('SYNERGIES PROBE ',('PASS' if failed==0 else 'FAIL'),' scenarios=',result.size(),'; 15 s fixed opportunities each; isolated boss; no incoming damage/AI; not human balance proof')
	g.saved=original;g.save_game();g.free();await process_frame;quit(1 if failed else 0)
