extends Control
var color = Color('#00d9d0')
var kind = 'sparky'
var mode = 'portrait'
var clock = 0.0
func _process(dt):
	clock+=dt
	queue_redraw()
func _draw():
	var p=Vector2(90,90+sin(clock*3)*5)
	if mode=='victory':
		for i in range(45):
			var at=Vector2(fmod(i*173.0,1700),fmod(i*113+clock*90,700))
			draw_rect(Rect2(at,Vector2(9,16)),[color,Color('#ffd166'),Color('#ff4757')][i%3])
		draw_circle(p,87+sin(clock*4)*8,Color(1,.82,.4,.15))
	draw_circle(p+Vector2(0,70),67,Color(0,0,0,.2))
	if kind=='shade':
		draw_colored_polygon(PackedVector2Array([p+Vector2(-85,25),p+Vector2(0,-105),p+Vector2(85,25)]),color.darkened(.2))
	draw_circle(p,66,Color('#14213d'))
	draw_circle(p,60,color)
	draw_arc(p-Vector2(0,7),45,PI,TAU,24,color.lightened(.4),8,true)
	if kind=='bruiser':
		for side in [-1,1]:
			draw_circle(p+Vector2(side*67,30),27,Color('#14213d'))
			draw_circle(p+Vector2(side*67,27),22,Color('#ffd166'))
	for side in [-1,1]:
		var eye=p+Vector2(side*23,-5)
		draw_circle(eye,15,Color('#14213d'))
		draw_circle(eye+Vector2(2,-3),8,Color.WHITE)
	if kind=='sparky':
		for side in [-1,1]:draw_arc(p+Vector2(side*23,-5),22,0,TAU,24,Color('#ffd166'),6,true)
	if mode=='defeat':
		for side in [-1,1]:draw_circle(p+Vector2(side*24,24),6,Color('#00d9d0'))
	else:draw_arc(p+Vector2(0,25),18,0,PI,14,Color('#14213d'),5,true)
	for side in [-1,1]:draw_circle(p+Vector2(side*35,60),17,Color('#14213d'))
