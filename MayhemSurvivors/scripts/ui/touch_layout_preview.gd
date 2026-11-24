extends Control
var editor
func _draw():
	var g=editor.game;var map=editor.projection();var d=editor.Layout.geometry(Rect2(0,0,1920,1080),editor.draft)
	draw_style_box(g.style(Color('#111729')),Rect2(Vector2.ZERO,size))
	draw_set_transform(map.offset,0,Vector2.ONE*map.scale)
	draw_rect(Rect2(0,0,1920,1080),Color('#1F2545'))
	draw_rect(Rect2(65,35,550,220),Color('#31203D'));draw_string(g.UISkin.HEADING,Vector2(90,115),'HP / XP / WELLE',HORIZONTAL_ALIGNMENT_LEFT,-1,48,g.GOLD)
	draw_string(g.UISkin.HEADING,Vector2(780,650),'DEIN FIGHTER',HORIZONTAL_ALIGNMENT_LEFT,-1,48,Color.WHITE)
	draw_texture_rect(preload('res://assets/ui/joystick_base.svg'),Rect2(d.joy-Vector2.ONE*d.visual_radius,Vector2.ONE*d.visual_radius*2),false,Color(1,1,1,d.opacity))
	draw_texture_rect(preload('res://assets/ui/joystick_thumb.svg'),Rect2(d.joy-Vector2.ONE*56*d.scale,Vector2.ONE*112*d.scale),false,Color(1,1,1,d.opacity))
	draw_style_box(g.UISkin.box(Color('#694197'),g.TEAL),d.ability);draw_string(g.UISkin.HEADING,d.ability.position+Vector2(25,110)*d.scale,'FÄHIGKEIT',HORIZONTAL_ALIGNMENT_LEFT,-1,36*d.scale,Color.WHITE)
	draw_style_box(g.UISkin.box(Color('#33264D')),d.spell);draw_string(g.UISkin.HEADING,d.spell.position+Vector2(25,85)*d.scale,'ZAUBER',HORIZONTAL_ALIGNMENT_LEFT,-1,32*d.scale,Color.WHITE)
