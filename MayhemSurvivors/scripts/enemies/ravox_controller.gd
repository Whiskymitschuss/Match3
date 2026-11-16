extends RefCounted
# A rare charging enemy. Uses existing spawn rolls, no independent gameplay RNG.
var game:Node2D
var data:Dictionary
var spawned={}
var enabled=true
func _init(g:Node2D):game=g;data=game.read_data('enemies/ravox')
func reset_run():spawned.clear()
func allowed() -> bool:
	if game.state!=game.State.COMBAT or game.wave_number<int(data.first_wave) or game.wave_number>9:return false
	var count=0
	for e in game.enemies:
		if e.kind=='ravox' and e.hp>0:count+=1
	return count<int(data.cap) and int(spawned.get(game.wave_number,0))<int(data.wave_cap)
func select_kind(normal:String,roll:float) -> String:
	return 'ravox' if enabled and roll>=1.0-float(data.weight) and allowed() else normal
func initialize(e:Dictionary):
	if e.kind!='ravox':return
	spawned[game.wave_number]=int(spawned.get(game.wave_number,0))+1
	e.ravox_stage='chase';e.ravox_clock=float(data.initial_delay);e.ravox_origin=e.pos;e.ravox_target=e.pos;e.ravox_hit=false
func interrupt(e:Dictionary):
	if e.kind!='ravox' or not e.has('ravox_stage'):return
	if e.ravox_stage not in ['windup','dash']:return
	e.ravox_stage='recovery';e.ravox_clock=float(data.recovery);e.ravox_hit=true
func velocity(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	if game.state!=game.State.COMBAT or dt<=0:return Vector2.ZERO
	if e.ravox_stage in ['windup','dash'] and not game.enemy_roles.visible(e.pos):interrupt(e)
	if e.ravox_stage=='windup':
		if e.pos.distance_to(e.ravox_origin)>6:interrupt(e);return Vector2.ZERO
		e.ravox_clock=maxf(0,e.ravox_clock-dt)
		if e.ravox_clock<=0:
			e.ravox_stage='dash';e.ravox_hit=false;game.sound('ravox_charge')
		return Vector2.ZERO
	if e.ravox_stage=='dash':
		return e.pos.direction_to(e.ravox_target)*minf(float(data.dash_speed),e.pos.distance_to(e.ravox_target)/dt)
	if e.ravox_stage=='recovery':
		e.ravox_clock=maxf(0,e.ravox_clock-dt)
		if e.ravox_clock<=0:e.ravox_stage='chase';e.ravox_clock=float(data.cooldown)
		return Vector2.ZERO
	if not game.enemy_roles.visible(e.pos):return normal
	e.ravox_clock=maxf(0,e.ravox_clock-dt)
	if e.ravox_clock>0 or e.pos.distance_to(game.player.position)>float(data.range):return normal
	for other in game.enemies:
		if other.kind=='ravox' and other.get('ravox_stage','') in ['windup','dash']:return normal
	var offset:Vector2=game.player.position-e.pos
	var direction:Vector2=offset.normalized() if offset.length_squared()>.01 else Vector2.RIGHT
	e.ravox_origin=e.pos
	e.ravox_target=(e.pos+direction*minf(float(data.dash_distance),offset.length()+70)).clamp(Vector2(35,35),Vector2(2365,1565))
	e.ravox_stage='windup';e.ravox_clock=float(data.windup)
	game.sound('ravox_warning')
	return Vector2.ZERO
func after_move(e:Dictionary,before:Vector2,after:Vector2):
	if game.state!=game.State.COMBAT or e.kind!='ravox' or e.ravox_stage!='dash':return
	if not e.ravox_hit and Geometry2D.get_closest_point_to_segment(game.player.position,before,after).distance_to(game.player.position)<=e.radius+27:
		e.ravox_hit=true
		game.hurt(float(e.damage)*float(data.charge_bonus))
		if game.state!=game.State.COMBAT:return
	if after.distance_to(e.ravox_target)<1:e.ravox_stage='recovery';e.ravox_clock=float(data.recovery)
func draw_floor():
	for e in game.enemies:
		if e.kind!='ravox':continue
		if e.ravox_stage not in ['windup','dash']:continue
		var a:Vector2=e.ravox_origin;var b:Vector2=e.ravox_target
		var direction:Vector2=(b-a).normalized();var side=direction.orthogonal()*(e.radius+27)
		var color=Color('#FF653B');var alpha=.18 if e.ravox_stage=='windup' else .10
		game.draw_circle(a,e.radius+27,Color(color,alpha));game.draw_circle(b,e.radius+27,Color(color,alpha))
		game.draw_colored_polygon(PackedVector2Array([a+side,b+side,b-side,a-side]),Color(color,alpha))
		game.draw_line(a+side,b+side,Color(color,.9),3,true);game.draw_line(a-side,b-side,Color(color,.9),3,true)
		game.draw_arc(b,e.radius+27,0,TAU,32,Color(color,.8),3,true)
		game.draw_line(b-direction*24+side*.25,b,Color('#FFD166'),4,true);game.draw_line(b-direction*24-side*.25,b,Color('#FFD166'),4,true)
		if e.ravox_stage=='windup':
			var progress=1-float(e.ravox_clock)/float(data.windup)
			game.draw_arc(e.pos,e.radius+12,-PI*.5,-PI*.5+TAU*progress,32,Color('#FFD166'),4,true)
func draw_name(e:Dictionary):
	if e.kind!='ravox':return
	game.draw_string(game.UISkin.HEADING,e.pos+Vector2(-50,-e.radius*3.4*.66-22),'RAVOX',HORIZONTAL_ALIGNMENT_CENTER,100,17,Color('#FFAA55'))
