extends Control
var game:Node2D
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _process(_dt):queue_redraw()
func _draw():
	if not is_instance_valid(game):return
	var at=game.hud_top_left()
	draw_style_box(game.style(Color('#121A27')),Rect2(Vector2(55,22)+at,Vector2(720,180)))
	draw_rect(Rect2(Vector2(55,32)+at,Vector2(5,158)),Color('#FF9F1C'))
	var top=game.hud_top_right()
	draw_style_box(game.style(Color('#121A27')),Rect2(Vector2(1085,30)+top,Vector2(475,130)))

	for e in game.enemies:
		if e.kind not in ['boss','breaker_axel']:continue
		var pos=Vector2(620,247)+Vector2(0,game.safe_logical.position.y)
		draw_style_box(game.style(Color('#15121D')),Rect2(pos-Vector2(15,100),Vector2(1120,125)))
		draw_rect(Rect2(pos,Vector2(1070,16)),Color('#382C40'))
		draw_rect(Rect2(pos,Vector2(1070*clampf(e.hp/e.max_hp,0,1),16)),Color('#FF673F') if e.kind=='breaker_axel' else Color('#BA55DF'))
		for threshold in ([.7,.4] if e.kind=='breaker_axel' else [.65,.3]):draw_line(pos+Vector2(1070*threshold,-3),pos+Vector2(1070*threshold,19),Color('#FFD166'),3,true)
