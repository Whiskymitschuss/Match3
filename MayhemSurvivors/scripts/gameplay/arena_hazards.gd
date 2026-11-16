extends RefCounted
# Gameplay geometry and warning geometry share one immutable snapshot.
var game: Node2D
var items:Array=[]
var clock=8.0
var pattern=0
func _init(g: Node2D):game=g
func clear():
	items.clear()
	clock=8.0
	pattern=0
func lane(vertical: bool, at: float, width: float, warm: float, duration: float, damage: float):
	var rect=Rect2(at-width/2,0,width,1600) if vertical else Rect2(0,at-width/2,2400,width)
	items.append({'shape':'lane','rect':rect,'age':0.0,'warm':warm,'duration':duration,'damage':damage})
func bomb(at: Vector2, radius: float, warm: float):
	items.append({'shape':'circle','pos':at,'radius':radius,'age':0.0,'warm':warm,'duration':.45,'damage':18.0})
func contains(h: Dictionary, pos: Vector2) -> bool:
	if h.shape=='lane':return h.rect.grow(27).has_point(pos)
	return h.pos.distance_to(pos)<=h.radius+27
func update(dt: float):
	if not game.is_reactor():return
	for i in range(items.size()-1,-1,-1):
		var h=items[i]
		var previous:float=h.age
		h.age+=dt
		if previous<h.warm and h.age>=h.warm:
			if h.shape=='circle':game.vfx.explosion(h.pos,h.radius,Color('#FF7040'))
			else:
				var at:Vector2=h.rect.get_center()
				if h.rect.size.x<h.rect.size.y:at.y=game.player.position.y
				else:at.x=game.player.position.x
				game.vfx.burst(at,Color('#FF7040'),game.vfx.limits().burst,'spark',170)
		# Crossing the active interval also counts, even after a long frame.
		if h.age>=h.warm and previous<h.warm+h.duration and contains(h,game.player.position):
			game.hurt(h.damage)
			if game.state!=game.State.COMBAT:return
		if h.age>=h.warm+h.duration:items.remove_at(i)
	if game.wave_number>=3 and game.wave_number<10:
		clock-=dt
		if clock<=0:
			clock+=12
			var vertical=pattern%2==0
			lane(vertical,([600,1200,1800] if vertical else [400,800,1200])[pattern%3],52,1.6,.65,10)
			pattern+=1
			game.sound('boss_radial_warning')
func draw():
	for h in items:
		var active=h.age>=h.warm
		var color=Color('#FF4757') if active else Color('#FFD166')
		var pulse=.65+.25*sin(h.age*16)
		if h.shape=='lane':
			game.draw_rect(h.rect,Color(color,.4 if active else .10))
			game.draw_rect(h.rect,Color(color,pulse),false,4,true)
			if active:game.draw_rect(h.rect.grow(-8),Color(1,1,.75,.5))
		else:
			game.draw_circle(h.pos,h.radius,Color(color,.4 if active else .12))
			game.draw_arc(h.pos,h.radius,0,TAU,48,Color(color,pulse),4,true)
			game.draw_line(h.pos-Vector2(12,0),h.pos+Vector2(12,0),color,3,true)
			game.draw_line(h.pos-Vector2(0,12),h.pos+Vector2(0,12),color,3,true)
