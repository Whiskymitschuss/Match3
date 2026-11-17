extends Control
var texture:Texture2D
var game:Node2D
var clock=0.0
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _process(dt:float):
	if not game or game.saved.settings.reduced_motion or game.saved.settings.quality=='LOW':return
	clock+=dt;queue_redraw()
func _draw():
	if not texture:return
	var source=Vector2(texture.get_size());var ratio=size.x/maxf(1,size.y)
	var width=minf(source.x*.92,source.y*ratio*.92);var crop=Vector2(width,width/ratio)
	var motion=(Vector2(sin(clock*.15),cos(clock*.12))*.10+game.menu_motion.filtered*.12) if game and not game.saved.settings.reduced_motion else Vector2.ZERO
	var position=(source-crop)*.5+(source-crop)*motion
	draw_texture_rect_region(texture,Rect2(Vector2.ZERO,size),Rect2(position,crop))
