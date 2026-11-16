extends Control
var texture:Texture2D
func _draw():
	if texture:draw_texture_rect(texture,Rect2(Vector2.ZERO,size),false)
