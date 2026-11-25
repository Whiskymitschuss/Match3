extends Control
var tutorial
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _process(_dt):queue_redraw()
func _draw():
	if not is_instance_valid(tutorial) or not tutorial.active or tutorial.done:return
	var g=tutorial.game
	var rect=Rect2()
	match tutorial.step:
		1:rect=Rect2(g.joystick_rest()-Vector2(150,150),Vector2(300,300))
		5:rect=g.ability_rect()
		7:rect=Rect2(120,640,360,85)
		8:rect=Rect2(1300,770,480,90)
		9:rect=Rect2(100,880,235,135) if g.ui_root.get_children().any(func(n):return n is Button and n.text.begins_with('WERTE')) else Rect2(610,840,570,105)
		10:rect=Rect2(Vector2(1690,40)+g.hud_top_right(),Vector2(140,100)) if g.state==g.State.COMBAT else Rect2(120,320,620,110)
	if rect.size!=Vector2.ZERO:
		var style=g.UISkin.box(Color(0,0,0,0),Color('#FFD166'));style.bg_color=Color(0,0,0,0);style.shadow_size=0
		draw_style_box(style,rect.grow(7))
