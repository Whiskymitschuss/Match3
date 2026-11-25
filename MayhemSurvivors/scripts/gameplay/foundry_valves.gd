extends RefCounted
# Two optional directional bursts per wave; pressure and hit resolution are snapshots.
const ART=preload('res://assets/environments/steam_valve.svg')
var game:Node2D
var arena_ref:WeakRef
var arena:
	get:return arena_ref.get_ref()
var stations:Array=[]
func _init(g:Node2D,a):game=g;arena_ref=weakref(a)
func clear():stations.clear()
func begin_wave():
	var at:Vector2=game.player.position
	var horizontal=(at+Vector2(260 if at.x<500 else -260,65)).clamp(Vector2(170,180),Vector2(2230,1420))
	var vertical=(at+Vector2(180 if at.x<1850 else -180,-200 if at.y>1200 else 180)).clamp(Vector2(170,180),Vector2(2230,1420))
	for i in range(2):
		var pos=horizontal if i==0 else vertical
		var direction=Vector2.RIGHT if pos.x<1200 else Vector2.LEFT
		if i==1:direction=Vector2.DOWN if pos.y<800 else Vector2.UP
		stations.append({'pos':pos,'direction':direction,'age':float(arena.data.foundry.cycle)*i*.5,'held':0.0,'used':false,'was_good':false})
func pressure(v:Dictionary) -> float:return fposmod(float(v.age),float(arena.data.foundry.cycle))/float(arena.data.foundry.cycle)
func good(value:float) -> bool:return value>=float(arena.data.foundry.sweet_min) and value<=float(arena.data.foundry.sweet_max)
func used() -> int:return stations.filter(func(v):return v.used).size()
func update(dt:float):
	if game.state!=game.State.COMBAT:return
	if game.remaining<4:
		for v in stations:v.held=0
		return
	for v in stations:
		if v.used:continue
		v.age+=dt
		var ready=good(pressure(v))
		if ready and not v.was_good:game.sound('valve_ready')
		v.was_good=ready
		v.held=minf(float(arena.data.foundry.hold),float(v.held)+dt) if game.player.position.distance_to(v.pos)<65 and game.move_input.length_squared()<.04 else 0.0
		if v.held>=float(arena.data.foundry.hold):release(v)
func release(v:Dictionary):
	if game.state!=game.State.COMBAT or game.remaining<4 or not arena.normal_wave() or game.arena_id!='foundry' or not stations.has(v) or v.used:return
	var value=pressure(v)
	if not arena.add_hazard('steam',v.pos,float(arena.data.foundry.warm),{},-1,v.direction,value):return
	v.used=true;v.held=0
	game.sound('valve_turn');game.sound('steam_warning')
	game.encounters.warn('DAMPF / BAHN VERLASSEN / GRÜNER DRUCK: BONUS' if good(value) else 'DAMPF / BAHN VERLASSEN / KEIN DRUCKBONUS')
func rect(pos:Vector2,direction:Vector2) -> Rect2:
	var d=arena.data.foundry
	var start=(pos+direction*float(d.offset)).clamp(Vector2(70,70),Vector2(2330,1530))
	var end=(pos+direction*(float(d.offset)+float(d.length))).clamp(Vector2(70,70),Vector2(2330,1530))
	var width=float(d.width)
	if absf(direction.x)>.5:return Rect2(minf(start.x,end.x),start.y-width*.5,absf(end.x-start.x),width)
	return Rect2(start.x-width*.5,minf(start.y,end.y),width,absf(end.y-start.y))
func push(e:Dictionary,direction:Vector2):
	game.encounters.interrupt_elite(e);game.ravox.interrupt(e);game.enemy_pack.interrupt(e);game.united.enemies.interrupt(e)
	e.pos=(e.pos+direction*float(arena.data.foundry.push)).clamp(Vector2(35,35),Vector2(2365,1565))
func completed(h:Dictionary,kills:int):
	arena.maneuvers+=1;game.run_events+=1
	if h.sweet and kills>0:arena.award('foundry')
	else:game.encounters.warn('DAMPF BEENDET / BONUS: GRÜNER DRUCK UND EIN KILL')
func status() -> String:
	if game.remaining<4:return 'GLUTWERK / VENTILFENSTER GESCHLOSSEN'
	return 'DAMPFVENTILE %d / 2 GENUTZT\nGRÜNER DRUCK + KILL: +%d RUN-COINS' % [used(),arena.bonus('foundry')]
func draw():
	var d=arena.data.foundry
	for v in stations:
		var value=pressure(v);var closed=bool(v.used) or game.remaining<4
		var color=Color('#858899') if closed else (Color('#2ED573') if good(value) else Color('#FFAD43'))
		if not closed:
			var preview=rect(v.pos,v.direction)
			game.draw_rect(preview,Color(.65,.84,.9,.045));game.draw_line(preview.get_center()-v.direction*110,preview.get_center()+v.direction*100,Color(.55,.8,.84,.35),3,true)
			var tip:Vector2=preview.get_center()+v.direction*100
			for side in [-1,1]:game.draw_line(tip,tip-v.direction*18+v.direction.orthogonal()*side*12,Color(.55,.8,.84,.5),3,true)
		game.draw_arc(v.pos,64,-PI*.85,PI*.85,40,Color('#26243A'),9,true)
		game.draw_arc(v.pos,64,-PI*.85+PI*1.7*float(d.sweet_min),-PI*.85+PI*1.7*float(d.sweet_max),14,Color('#2ED573'),9,true)
		game.draw_arc(v.pos,64,-PI*.85,-PI*.85+PI*1.7*value,32,color,4,true)
		game.draw_set_transform(v.pos,0 if game.saved.settings.get('reduced_motion',false) else float(v.held)*3)
		game.draw_texture_rect(ART,Rect2(-43,-43,86,86),false,Color(.55,.55,.65) if closed else Color.WHITE);game.draw_set_transform(Vector2.ZERO)
		if v.held>0:game.draw_arc(v.pos,75,-PI/2,-PI/2+TAU*float(v.held)/float(d.hold),28,Color.WHITE,5,true)
		var text='GENUTZT' if v.used else ('GESCHLOSSEN' if closed else 'DRUCK %d %%' % roundi(value*100))
		game.draw_rect(Rect2(v.pos+Vector2(-90,78),Vector2(180,32)),Color('#111324'))
		game.draw_string(game.UISkin.HEADING,v.pos+Vector2(-82,102),text,HORIZONTAL_ALIGNMENT_CENTER,164,23,color)
func draw_hazard(h:Dictionary):
	var color=Color('#FF4757') if h.resolved else Color('#FFD166')
	game.draw_rect(h.rect,Color(color,.22 if h.resolved else .10));game.draw_rect(h.rect,color,false,4,true)
	var center:Vector2=h.rect.get_center()
	for i in range(4):
		var at=center+h.direction*(i-1.5)*70
		game.draw_line(at-h.direction*16,at+h.direction*16,color,3,true)
		game.draw_line(at+h.direction*16,at+h.direction*3+h.direction.orthogonal()*12,color,3,true)
		if h.resolved:
			game.draw_circle(at,28,Color(.9,.96,1,.65));game.draw_circle(at+h.direction.orthogonal()*18,21,Color(.8,.89,1,.5))
	var text='DAMPFSTOSS' if h.resolved else 'DAMPF %.1f s' % maxf(0,float(h.warm)-float(h.age))
	var at:Vector2=h.rect.position-Vector2(0,13)
	game.draw_rect(Rect2(at-Vector2(4,25),Vector2(185,34)),Color('#111324'));game.draw_string(game.UISkin.HEADING,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,23,color)
