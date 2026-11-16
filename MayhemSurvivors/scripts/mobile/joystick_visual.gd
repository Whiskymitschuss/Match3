extends Control
var game
func _draw():
	if not game: return
	var p: Vector2 = game.stick_origin if game.stick_id>=0 else Vector2(220,850)
	draw_circle(p,130,Color('#14213d99'))
	draw_arc(p,122,0,TAU,48,Color('#00d9d080'),5,true)
	draw_circle(p+game.stick_pos,55,Color('#00d9d0aa'))
	draw_circle(p+game.stick_pos,43,Color('#cfffff55'))
	draw_string(ThemeDB.fallback_font,p+Vector2(-72,170),'BEWEGEN',HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color.WHITE)
	# Large contrast bars supplement the numeric HUD.
	var bar = Rect2(80,157,420,20)
	draw_style_box(game.style(Color('#0e182b')),bar.grow(4))
	draw_rect(Rect2(bar.position,Vector2(bar.size.x*maxf(0,game.hp/game.max_hp),20)),Color('#ff4757'))
	bar = Rect2(80,190,420,12)
	draw_rect(bar,Color('#0e182b'))
	draw_rect(Rect2(bar.position,Vector2(bar.size.x*minf(1,float(game.xp)/game.required_xp()),12)),Color('#00d9d0'))
	for enemy in game.enemies:
		if enemy.kind=='boss':
			draw_rect(Rect2(620,245,680,24),Color('#0e182b'))
			draw_rect(Rect2(620,245,680*maxf(0,enemy.hp/2500),24),Color('#ff4757'))
