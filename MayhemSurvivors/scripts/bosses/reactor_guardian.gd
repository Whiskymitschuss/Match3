extends RefCounted
# Independent boss: locked cross lasers, three mortar targets, directed burst fan.
var game: Node2D
var stage='recovery'
var clock=3.0
var pattern=0
var burst=0
var origin=Vector2.ZERO
var angle=0.0
func _init(g: Node2D):game=g
func clear():
	stage='recovery'
	clock=3
	pattern=0
	burst=0
func stationary() -> bool:return stage!='recovery'
func update(dt: float):
	var boss:Dictionary={}
	for e in game.enemies:
		if e.kind=='boss':boss=e;break
	if boss.is_empty():return
	clock-=dt
	if clock>0:return
	if stage=='recovery':
		origin=boss.pos
		angle=(game.player.position-origin).angle()
		game.sound('boss_charge_warning')
		match pattern%3:
			0:
				stage='cross'
				clock=2.1
				game.boss_warning='⚠ KREUZLASER – STROMBAHN VERLASSEN!'
				game.arena_hazards.lane(true,origin.x,60,1.5,.6,16)
				game.arena_hazards.lane(false,origin.y,60,1.5,.6,16)
			1:
				stage='bombs'
				clock=1.95
				game.boss_warning='⚠ KERNBOMBEN – MARKIERUNGEN VERLASSEN!'
				for offset in [-180,0,180]:game.arena_hazards.bomb((game.player.position+Vector2(offset,0)).clamp(Vector2(100,100),Vector2(2300,1500)),90,1.5)
			2:
				stage='fan_warning'
				clock=1.1
				game.boss_warning='⚠ IMPULSFÄCHER – SEITLICH AUSWEICHEN!'
	elif stage=='fan_warning' or stage=='volley':
		if stage=='fan_warning':burst=0
		for j in range(3):game.shoot(origin,Vector2.from_angle(angle+(burst-1.5)*.22+(j-1)*.15),12,true,260,4.4)
		game.sound('warning')
		burst+=1
		stage='volley'
		clock=.18
		if burst>=4:recover()
	else:recover()
func recover():
	stage='recovery'
	clock=2.0
	pattern+=1
	game.boss_warning=''
func draw():
	if stage!='fan_warning':return
	var color=Color('#FFD166')
	var left=Vector2.from_angle(angle-.55)*650
	var right=Vector2.from_angle(angle+.55)*650
	game.draw_colored_polygon(PackedVector2Array([origin,origin+left,origin+right]),Color(color,.12))
	game.draw_line(origin,origin+left,color,4,true)
	game.draw_line(origin,origin+right,color,4,true)
	game.draw_arc(origin,160,angle-.55,angle+.55,24,color,4,true)
