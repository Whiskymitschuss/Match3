extends Control
var garage
var case_id='crew'
var revision=0
var age=0.0
var done=false
func _process(dt):
	if garage.game.ui_revision!=revision:queue_free();return
	age+=dt;queue_redraw()
	if age>=1.35 and not done:done=true;garage.call_deferred('reveal')
func _draw():
	var center=Vector2(960,580);var color=Color(garage.C.catalog().cases[case_id].color)
	for i in range(16):
		var dir=Vector2.from_angle(i*TAU/16+age*.3);draw_line(center+dir*120,center+dir*(260+age*140),Color(color,.2),10,true)
	draw_arc(center,250+sin(age*7)*15,0,TAU,64,Color(color,.45),5,true)
	draw_set_transform(center+Vector2(sin(age*48)*age*8,0),sin(age*40)*age*.015)
	draw_texture_rect_region(garage.Art.CASES,Rect2(-420,-240,840,480),garage.Art.case_region(case_id))
	draw_set_transform(Vector2.ZERO)
