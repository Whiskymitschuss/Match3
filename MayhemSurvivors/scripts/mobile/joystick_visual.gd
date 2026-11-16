extends Control
const CombatArt = preload('res://scripts/ui/combat_art.gd')
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
	var bar = Rect2(80,135,420,20)
	draw_style_box(game.style(Color('#0e182b')),bar.grow(4))
	draw_rect(Rect2(bar.position,Vector2(bar.size.x*maxf(0,game.hp/game.max_hp),20)),Color('#ff4757'))
	bar = Rect2(80,168,420,12)
	draw_rect(bar,Color('#0e182b'))
	draw_rect(Rect2(bar.position,Vector2(bar.size.x*minf(1,float(game.xp)/game.required_xp()),12)),Color('#00d9d0'))
	for enemy in game.enemies:
		if enemy.kind=='boss':
			draw_rect(Rect2(620,245,680,24),Color('#0e182b'))
			draw_rect(Rect2(620,245,680*clampf(enemy.hp/enemy.max_hp,0,1),24),Color('#ff4757'))

	# Real equipment art uses the same atlas as the held weapons and shop offers.
	for i in range(game.weapons.size()):
		var w=game.weapons[i]
		var at=Vector2(1100+i*116,44)
		draw_style_box(game.style(Color('#18263d')),Rect2(at,Vector2(104,104)))
		draw_string(ThemeDB.fallback_font,at+Vector2(4,19),{'blaster':'BLASTER','hammer':'HAMMER','splitgun':'SPLITGUN','arc':'ARC','orbit':'ORBIT'}[w.id],HORIZONTAL_ALIGNMENT_CENTER,96,16,Color.WHITE)
		draw_texture_rect_region(CombatArt.TEXTURE,Rect2(at+Vector2(6,18),Vector2(92,61)),CombatArt.weapon(w.id))
		draw_string(ThemeDB.fallback_font,at+Vector2(32,94),'Lv.'+str(w.level),HORIZONTAL_ALIGNMENT_LEFT,-1,19,Color('#ffd166'))
