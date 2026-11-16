extends Button
# Render feedback never changes hit boxes or gameplay time.
var motion_enabled=true
var hover_amount=0.0
var press_amount=0.0
var clock=0.0
func _ready():
	set_process(motion_enabled)
	mouse_entered.connect(queue_redraw);mouse_exited.connect(queue_redraw)
	button_down.connect(queue_redraw);button_up.connect(queue_redraw)
func _process(delta):
	if not motion_enabled:return
	var target=1.0 if is_hovered() and not disabled else 0.0
	var down=1.0 if button_pressed and not disabled else 0.0
	var old=hover_amount+press_amount
	hover_amount=move_toward(hover_amount,target,delta*7);press_amount=move_toward(press_amount,down,delta*12)
	if absf(old-hover_amount-press_amount)>.001:queue_redraw()
func _draw():
	if disabled:return
	var points=PackedVector2Array([Vector2(18,5),Vector2(size.x-18,5),Vector2(size.x-5,18),Vector2(size.x-5,size.y-18),Vector2(size.x-18,size.y-6),Vector2(18,size.y-6),Vector2(5,size.y-18),Vector2(5,18)])
	var top=Color(.85,.45,1,.10+hover_amount*.08);var bottom=Color(.02,.01,.06,.17)
	draw_polygon(points,PackedColorArray([top,top,top,bottom,bottom,bottom,bottom,top]))
	var fade=.13+hover_amount*.23+press_amount*.17
	draw_line(Vector2(18,3),Vector2(size.x-18,3),Color(1,.76,1,fade),2,true)
	if hover_amount>.01:
		draw_style_box(focus_box(),Rect2(1,1,size.x-2,size.y-2))
func focus_box() -> StyleBoxFlat:
	var box=StyleBoxFlat.new();box.bg_color=Color(0,0,0,0);box.border_color=Color(.96,.35,1,hover_amount*.65)
	box.set_border_width_all(2);box.set_corner_radius_all(14);return box
