extends Control
var clock=0.0
var count=40
func _process(dt):
	clock+=dt
	queue_redraw()
func _draw():
	var fade=maxf(0,1-clock/1.4)
	if fade>0:
		draw_rect(Rect2(0,0,1920,1080),Color(1,.82,.4,fade*.12))
		for i in range(16):
			var angle=i*TAU/16
			var a=Vector2(1530,450)+Vector2.from_angle(angle)*(100+clock*80)
			draw_line(a,a+Vector2.from_angle(angle)*(100+clock*160),Color('#FFD166')*Color(1,1,1,fade*.35),5,true)
	for i in range(count):
		var x=fmod(i*193.0+sin(clock+i)*35,1920)
		var y=fmod(i*97.0+clock*(80+i%7*13),1080)
		var color=[Color('#FFD166'),Color('#A55EEA'),Color('#00D9D0')][i%3]
		draw_set_transform(Vector2(x,y),clock*2+i)
		draw_rect(Rect2(-4,-7,8,14),Color(color,.65))
		draw_set_transform(Vector2.ZERO)
