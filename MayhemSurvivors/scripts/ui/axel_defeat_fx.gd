extends Control
# A short UI-side death burst continues over the earned level/shop transition.
const ART=preload('res://assets/enemies/breaker_axel.png')
var age=0.0
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _process(dt:float):
	age+=dt;queue_redraw()
	if age>=.85:queue_free()
func _draw():
	var t=clampf(age/.85,0,1);var at=Vector2(1150,1000)
	var size=Vector2(100,150)*Vector2(1+t*.8,1-t*.85)
	draw_string(preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf'),Vector2(735,980),'AXEL BESIEGT!',HORIZONTAL_ALIGNMENT_LEFT,-1,42,Color(1,.83,.46,1-t))
	draw_texture_rect(ART,Rect2(at-size*Vector2(.5,.85),size),false,Color(1,.75,.5,1-t))
	for i in range(10):
		var dir=Vector2.from_angle(i*TAU/10)
		draw_line(at+dir*(30+t*160),at+dir*(48+t*180),Color(1,.73,.3,1-t),5*(1-t)+1,true)
