extends RefCounted
var game:Node2D
var progressive=true
func _init(g:Node2D):game=g
func boss_wave() -> bool:
	return game.wave_number%10==0 if game.run_mode=='endless' else game.wave_number==10
func current_wave() -> Dictionary:
	var index=9 if boss_wave() else mini(8,game.wave_number-1)
	var d:Dictionary=game.waves[index].duplicate(true)
	if game.run_mode=='endless' and game.wave_number>10:
		var cycle=floori((game.wave_number-1)/10.0)
		d.interval=maxf(.30,float(d.interval)/(1+cycle*.12))
		if boss_wave():d.boss_hp_factor=float(d.get('boss_hp_factor',1))*(1+cycle*.35)
	d.interval=maxf(.24,float(d.interval)*float(preload('res://scripts/gameplay/difficulty.gd').current(game).interval))
	return d
func scale_stats(values:Dictionary,boss:bool=false) -> Dictionary:
	var d=values.duplicate()
	if not progressive or game.run_mode=='tutorial':return d
	if boss:
		if game.run_mode=='endless':d.damage*=1+minf(2,floorf((game.wave_number-1)/10.0)*.1)
		return preload('res://scripts/gameplay/difficulty.gd').stats(game,d,true)
	var step=maxi(0,game.wave_number-1)
	d.hp*=1+step*.025
	d.speed*=1+minf(.8,step*.025)
	d.damage*=1+minf(2,step*.02)
	return preload('res://scripts/gameplay/difficulty.gd').stats(game,d,false)
func direction(e:Dictionary) -> Vector2:
	var target:Vector2=game.player.position
	if progressive and game.run_mode!='tutorial' and e.kind in ['grunt','runner','tank']:
		var anticipation=minf(.30,maxi(0,game.wave_number-1)*.025)
		target+=game.player.velocity*anticipation
		var dir:Vector2=(target-e.pos).normalized()
		if e.kind=='runner':dir=(dir+dir.orthogonal()*sin(game.run_time*2.5+e.pos.x*.013)*minf(.22,maxi(0,game.wave_number-1)*.018)).normalized()
		return dir
	return (target-e.pos).normalized()
