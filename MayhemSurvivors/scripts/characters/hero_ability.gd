extends RefCounted
# Active abilities advance only in COMBAT. Idle abilities consume no gameplay RNG.
var game:Node2D
var data:Dictionary
var cooldown=0.0
var grenade:Dictionary={}
var dash:Dictionary={}
var rings:Array=[]
var afterimages:Array=[]
var activations=0
func _init(g:Node2D):
	game=g
	data=game.read_data('abilities/abilities')
func definition() -> Dictionary:return data[game.characters[game.selected].id]
func clear():
	cooldown=0
	grenade.clear()
	dash.clear()
	rings.clear()
	afterimages.clear()
	activations=0
func ready_to_use() -> bool:
	return game.state==game.State.COMBAT and cooldown<=0 and grenade.is_empty() and dash.is_empty()
func activate() -> bool:
	if not ready_to_use():return false
	var d=definition()
	if d.id=='shadow_step':
		var direction:Vector2=game.move_input.normalized() if game.move_input.length_squared()>.01 else Vector2(game.facing,0)
		var target=(game.player.position+direction*d.distance).clamp(Vector2(45,45),Vector2(2355,1555))
		if target.distance_to(game.player.position)<5:return false
		dash={'from':game.player.position,'target':target,'age':0.0,'duration':d.duration,'power':d.damage*game.damage_mult,'hit':[]}
	cooldown=d.cooldown
	activations+=1
	game.haptic('ability')
	game.sound('ability_'+d.id)
	match d.id:
		'shockwave':
			rings.append({'pos':game.player.position,'radius':d.radius,'age':0.0,'life':.45,'color':Color(d.color)})
			var origin:Vector2=game.player.position
			for e in game.enemies.duplicate():
				if origin.distance_to(e.pos)>d.radius+e.radius:continue
				game.damage_enemy(e,d.damage*game.damage_mult*(1.0+float(game.characters[game.selected].melee_bonus)))
				if game.state!=game.State.COMBAT:return true
				if game.enemies.has(e) and e.kind!='boss':
					var dir:Vector2=(e.pos-origin).normalized()
					if dir==Vector2.ZERO:dir=Vector2.RIGHT
					e.pos=(e.pos+dir*d.knockback).clamp(Vector2(35,35),Vector2(2365,1565))
		'impulse':
			var target=game.nearest(game.player.position,d.reach)
			var at:Vector2=target.pos if target!=null else game.player.position+Vector2(game.facing,0)*250
			grenade={'from':game.player.position,'target':at.clamp(Vector2(45,45),Vector2(2355,1555)),'age':0.0,'fuse':d.fuse,'radius':d.radius,'power':d.damage*game.damage_mult}
	return true
func invulnerable() -> bool:return not dash.is_empty()
func move_dash(dt:float) -> bool:
	if dash.is_empty():return false
	var current=dash
	var before:Vector2=game.player.position
	current.age=minf(current.duration,current.age+dt)
	game.player.position=current.from.lerp(current.target,current.age/current.duration)
	afterimages.append({'pos':before,'life':.22})
	if afterimages.size()>8:afterimages.pop_front()
	for e in game.enemies.duplicate():
		if current.hit.has(e):continue
		if Geometry2D.get_closest_point_to_segment(e.pos,before,game.player.position).distance_to(e.pos)>e.radius+27:continue
		current.hit.append(e)
		game.damage_enemy(e,current.power)
		if game.state!=game.State.COMBAT:return true
	if current.age>=current.duration:dash.clear()
	return true
func update(dt:float):
	cooldown=maxf(0,cooldown-dt)
	for i in range(rings.size()-1,-1,-1):
		rings[i].age+=dt
		if rings[i].age>=rings[i].life:rings.remove_at(i)
	for i in range(afterimages.size()-1,-1,-1):
		afterimages[i].life-=dt
		if afterimages[i].life<=0:afterimages.remove_at(i)
	if grenade.is_empty():return
	grenade.age+=dt
	if grenade.age<grenade.fuse:return
	var bomb=grenade.duplicate()
	grenade.clear()
	rings.append({'pos':bomb.target,'radius':bomb.radius,'age':0.0,'life':.45,'color':Color('#00D9D0')})
	game.sound('ability_explosion')
	for e in game.enemies.duplicate():
		if e.pos.distance_to(bomb.target)>bomb.radius+e.radius:continue
		game.damage_enemy(e,bomb.power)
		if game.state!=game.State.COMBAT:return
		if game.enemies.has(e) and e.kind!='boss':
			e.ability_slow=definition().slow
			e.ability_slow_time=definition().slow_duration
func draw():
	for r in rings:
		var t:float=r.age/r.life
		var color=Color(r.color,1-t)
		game.draw_arc(r.pos,r.radius*(.3+.7*t),0,TAU,64,color,8*(1-t)+2,true)
		game.draw_arc(r.pos,r.radius*(.2+.6*t),0,TAU,48,Color(r.color,(1-t)*.45),3,true)
		for i in range(10):
			var dir=Vector2.from_angle(i*TAU/10)
			game.draw_line(r.pos+dir*r.radius*t,r.pos+dir*(r.radius*t+15),color,4,true)
	for a in afterimages:
		game.draw_circle(a.pos,27,Color(.65,.37,.92,a.life*1.8))
	if not grenade.is_empty():
		var t:float=clampf(grenade.age/grenade.fuse,0,1)
		var at:Vector2=grenade.from.lerp(grenade.target,t)-Vector2(0,sin(t*PI)*100)
		game.draw_arc(grenade.target,grenade.radius,0,TAU,48,Color(0,.85,.82,.45),2,true)
		game.draw_line(at+Vector2(0,-15),at+Vector2(6,-24),Color('#FFD166'),4,true)
		game.draw_circle(at,15,Color('#14213D'))
		game.draw_circle(at,11,Color('#00D9D0'))
		game.draw_line(at+Vector2(-5,0),at+Vector2(5,0),Color.WHITE,3,true)
