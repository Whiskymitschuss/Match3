extends RefCounted
const IDS=['grunt','runner','tank']
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
func _init(g:Node):game_ref=weakref(g)
func active(e:Dictionary) -> bool:return game.united.enabled and game.run_mode!='tutorial' and e.kind in IDS and not e.has('elite')
func initialize(e:Dictionary):
	if e.kind not in IDS:return
	e.core_stage='chase';e.core_clock=1.0+int(e.save_actor)%5*.17;e.core_origin=e.pos;e.core_target=e.pos;e.core_hit=false
func velocity(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	if not active(e):return normal
	if not e.has('core_stage'):initialize(e)
	if e.core_stage=='pounce':return e.pos.direction_to(e.core_target)*minf(370,e.pos.distance_to(e.core_target)/maxf(.0001,dt))
	e.core_clock=maxf(0,e.core_clock-dt)
	if e.core_stage=='recovery':
		if e.core_clock<=0:e.core_stage='chase';e.core_clock=.8
		return normal*.25
	if e.core_stage=='windup':
		if e.pos.distance_to(e.core_origin)>12:e.core_stage='recovery';e.core_clock=.6;return Vector2.ZERO
		if e.core_clock<=0:release(e)
		return Vector2.ZERO
	var reach={'grunt':105,'runner':290,'tank':180}[e.kind]
	if e.core_clock<=0 and e.pos.distance_to(game.player.position)<reach:
		var warnings=0
		for other in game.enemies:
			if other.get('core_stage','')=='windup':warnings+=1
		if warnings<3:
			e.core_stage='windup';e.core_clock={'grunt':.65,'runner':.9,'tank':1.3}[e.kind];e.core_origin=e.pos;e.core_target=game.player.position;e.core_hit=false
			game.sound('core_warning' if e.kind=='tank' else 'spitter_warning')
			return Vector2.ZERO
	return normal
func release(e:Dictionary):
	e.core_stage='recovery';e.core_clock=1.5 if e.kind!='tank' else 2.4
	if e.kind=='runner':
		e.core_target=(e.pos+e.pos.direction_to(e.core_target)*minf(260,e.pos.distance_to(e.core_target)+55)).clamp(Vector2(40,40),Vector2(2360,1560));e.core_stage='pounce';return
	if e.kind=='tank':
		game.vfx.ground_impact(e.pos,150,Color('#BA86FF'));game.united.enemies.circle(e.pos,150,0,.25,e.damage,e,Color('#BA86FF'));return
	var offset:Vector2=game.player.position-e.pos;var aim:Vector2=e.core_target-e.core_origin
	game.vfx.event('slash',e.pos,Color('#91E65A'),80,aim.normalized(),.22)
	if offset.length()<105 and (offset.length()<1 or aim.normalized().dot(offset.normalized())>.45):game.hurt(e.damage)
func after_move(e:Dictionary,before:Vector2):
	if not active(e) or e.get('core_stage','')!='pounce':return
	if not e.core_hit and Geometry2D.get_closest_point_to_segment(game.player.position,before,e.pos).distance_to(game.player.position)<e.radius+27:e.core_hit=true;game.hurt(e.damage)
	if e.pos.distance_to(e.core_target)<2:e.core_stage='recovery';e.core_clock=1.4
func draw():
	for e in game.enemies:
		if not active(e) or e.get('core_stage','')!='windup':continue
		var color=Color('#FFD166');var aim:Vector2=e.pos.direction_to(e.core_target)
		if e.kind=='tank':game.draw_circle(e.core_origin,150,Color(color,.10));game.draw_arc(e.core_origin,150,0,TAU,32,color,3,true)
		elif e.kind=='grunt':game.draw_arc(e.pos,90,aim.angle()-.95,aim.angle()+.95,16,color,4,true)
		else:
			var to:Vector2=e.pos+aim*260;var side=aim.orthogonal()*32
			game.draw_polyline(PackedVector2Array([to-aim*36+side,to,to-aim*36-side]),color,4,true)
			game.draw_line(e.pos,to,Color(color,.3),3,true)
