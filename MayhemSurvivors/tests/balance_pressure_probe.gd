extends SceneTree
const B=preload('res://scripts/gameplay/wave_balance.gd')
func _initialize():call_deferred('run')
func rate(w:Dictionary) -> float:return (1.0+(1.0/float(w.extra_spawn_every) if w.has('extra_spawn_every') else 0.0))/float(w.interval)
func run():
	var base=JSON.parse_string(FileAccess.get_file_as_string('res://data/enemies/enemies.json'))
	base.merge(JSON.parse_string(FileAccess.get_file_as_string('res://data/enemies/reactor_roles.json')))
	for arena in ['classic','reactor']:
		var old=JSON.parse_string(FileAccess.get_file_as_string('res://tests/fixtures/'+arena+'_waves_v0.6.json'))
		var now=JSON.parse_string(FileAccess.get_file_as_string('res://data/waves/'+('waves' if arena=='classic' else 'reactor')+'.json'))
		for i in range(10):
			var weights={'grunt':1.0}
			if arena=='reactor':weights={'tank':old[i].tank_weight,'runner':old[i].runner_weight,'spitter':old[i].spitter_weight,'drone':old[i].drone_weight,'grunt':1-old[i].tank_weight-old[i].runner_weight-old[i].spitter_weight-old[i].drone_weight}
			elif i>=2:weights={'tank':.18,'runner':.37,'grunt':.45}
			elif i==1:weights={'runner':.55,'grunt':.45}
			var old_hp=0.0;var hp=0.0;var old_xp=0.0;var xp=0.0;var old_coins=0.0;var coins=0.0
			for kind in weights:
				old_hp+=weights[kind]*B.stats(base[kind],old[i],i+1).hp
				hp+=weights[kind]*B.stats(base[kind],now[i],i+1).hp
				old_xp+=weights[kind]*base[kind].xp;xp+=weights[kind]*B.reward(int(base[kind].xp),now[i])
				old_coins+=weights[kind]*base[kind].coins;coins+=weights[kind]*B.reward(int(base[kind].coins),now[i])
			var ratio=rate(now[i])/rate(old[i])
			print('PRESSURE ',arena,' wave=',i+1,' spawn_x=',snappedf(ratio,.01),' incoming_hp_x=',snappedf(ratio*hp/old_hp,.01),' xp_budget_x=',snappedf(ratio*xp/old_xp,.01),' coin_budget_x=',snappedf(ratio*coins/old_coins,.01))
	print('PRESSURE NOTE theoretical flow before enemy caps and player kills; not difficulty/FPS measurement')
	quit()
