extends Control
var game:Node2D
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw():
	if not is_instance_valid(game):return
	var at=game.hud_top_left()
	draw_style_box(game.style(Color('#121A27')),Rect2(Vector2(55,22)+at,Vector2(720,180)))
	draw_rect(Rect2(Vector2(55,32)+at,Vector2(5,158)),Color('#FF9F1C'))
	var top=game.hud_top_right()
	draw_style_box(game.style(Color('#121A27')),Rect2(Vector2(1085,30)+top,Vector2(475,130)))
