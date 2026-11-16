extends RefCounted
# Arena-specific enemy behaviors. No independent RNG; each spawn uses the existing roll.
var game:Node2D
var data:Dictionary
var drones:Array=[]
func _init(g:Node2D):
	game=g
	data=game.read_data('enemies/reactor_roles')
func clear():drones.clear()
func initialize(e:Dictionary):
	if e.kind=='spitter':
		e.attack_clock=data.spitter.initial_delay
		e.windup=0.0
		e.aim=Vector2.ZERO
	elif e.kind=='drone':drones.append(e)
func removed(e:Dictionary):
	for i in range(drones.size()-1,-1,-1):
		if is_same(e,drones[i]):drones.remove_at(i)
func count(kind:String) -> int:
	var result=0
	for e in game.enemies:
		if e.kind==kind and e.hp>0:result+=1
	return result
func spawn_kind(w:Dictionary,roll:float) -> String:
	# Existing thresholds preserve the old composition when new weights are zero.
	var tank:float=w.tank_weight
	var runner:float=w.runner_weight
	if roll<tank:return 'tank'
	if roll<tank+runner:return 'runner'
	if roll<tank+runner+float(w.get('spitter_weight',0)):
		return 'spitter' if count('spitter')<int(data.spitter.cap) else 'grunt'
	if roll<tank+runner+float(w.get('spitter_weight',0))+float(w.get('drone_weight',0)):
		return 'drone' if count('drone')<int(data.drone.cap) else 'grunt'
	return 'grunt'
func visible(pos:Vector2) -> bool:
	var screen:Vector2=game.get_global_transform_with_canvas()*pos
	return game.get_viewport_rect().grow(-90).has_point(screen)
func shield_source(e:Dictionary):
	if not game.is_reactor() or e.kind in ['boss','drone'] or e.hp<=0:return null
	for d in drones:
		if d.hp>0 and d.pos.distance_squared_to(e.pos)<=pow(float(data.drone.shield_radius),2):return d
	return null
func damage_factor(e:Dictionary) -> float:
	return 1.0-float(data.drone.damage_reduction) if shield_source(e)!=null else 1.0
func shot_origin(e:Dictionary,target:Vector2) -> Vector2:
	return e.pos+Vector2((-1 if target.x<e.pos.x else 1)*e.radius*.85,-e.radius*.6)
func velocity(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	if game.state!=game.State.COMBAT:return Vector2.ZERO
	if e.kind=='drone':return normal
	if e.kind!='spitter':return normal
	var config=data.spitter
	var distance:float=e.pos.distance_to(game.player.position)
	if e.windup>0:
		e.windup=maxf(0,e.windup-dt)
		if e.windup<=0:
			# No offscreen shots. Aim remains locked to the announced snapshot.
			if visible(e.pos):
				var origin=shot_origin(e,e.aim)
				var direction:Vector2=(e.aim-origin).normalized()
				if direction.length_squared()>.01:
					var shot=game.shoot(origin,direction,config.shot_damage,true,config.shot_speed,config.shot_life)
					if shot!=null:shot.enemy_kind='spitter'
					game.vfx.event('muzzle',origin,Color('#FF7040'),28,direction,.1)
					game.sound('spitter_fire')
			e.attack_clock=config.cooldown
		return Vector2.ZERO
	e.attack_clock=maxf(0,e.attack_clock-dt)
	if e.attack_clock<=0 and distance<=config.range and visible(e.pos):
		var warnings=0
		for other in game.enemies:
			if other.kind=='spitter' and float(other.get('windup',0))>0:warnings+=1
		if warnings>=int(config.max_windups):e.attack_clock=.2;return Vector2.ZERO
		e.windup=config.windup
		e.aim=game.player.position
		game.sound('spitter_warning')
		return Vector2.ZERO
	if distance<config.min_distance:return -normal*float(config.retreat_factor)
	if distance<config.hold_distance:return Vector2.ZERO
	return normal
func draw_floor():
	if not game.is_reactor():return
	for d in drones:
		if d.hp<=0:continue
		var color=Color('#00D9D0')
		var radius:float=data.drone.shield_radius
		# A cool dashed aura is distinct from warm solid damage warnings.
		for i in range(12):game.draw_arc(d.pos,radius,i*TAU/12,i*TAU/12+.25,5,Color(color,.26),2,true)
	for e in game.enemies:
		var provider=shield_source(e)
		if provider==null:continue
		game.draw_line(provider.pos,e.pos,Color(0,.85,.82,.27),2,true)
		game.draw_arc(e.pos,e.radius+9,0,TAU,24,Color(0,.85,.82,.65),2,true)
func draw_telegraphs():
	for e in game.enemies:
		if e.kind!='spitter' or float(e.get('windup',0))<=0:continue
		var origin=shot_origin(e,e.aim)
		var dir:Vector2=(e.aim-origin).normalized()
		var end:Vector2=origin+dir*float(data.spitter.shot_speed)*float(data.spitter.shot_life)
		var progress=1-e.windup/float(data.spitter.windup)
		game.draw_line(origin,end,Color(1,.3,.25,.22+progress*.35),3,true)
		game.draw_arc(e.aim,27,0,TAU,24,Color('#FFD166'),3,true)
		game.draw_arc(e.pos,e.radius+12,-PI*.5,-PI*.5+TAU*progress,32,Color('#FF7040'),4,true)
		game.draw_colored_polygon(PackedVector2Array([e.pos+Vector2(-9,-e.radius-32),e.pos+Vector2(9,-e.radius-32),e.pos+Vector2(0,-e.radius-47)]),Color('#FFD166'))
