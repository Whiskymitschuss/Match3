extends Control
const CombatArt = preload('res://scripts/ui/combat_art.gd')
var game
func _draw():
	if not game: return
	game.encounters.draw_notice(self)
	var p: Vector2 = game.stick_origin if game.stick_id>=0 else game.joystick_rest()
	draw_texture_rect(preload('res://assets/ui/joystick_base.svg'),Rect2(p-Vector2(140,140),Vector2(280,280)),false)
	draw_texture_rect(preload('res://assets/ui/joystick_thumb.svg'),Rect2(p+game.stick_pos-Vector2(56,56),Vector2(112,112)),false)
	draw_string(preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf'),p+Vector2(-72,170),'BEWEGEN',HORIZONTAL_ALIGNMENT_LEFT,-1,24,Color.WHITE)
	if game.hit_feedback.hurt_flash>0:
		var alpha=game.hit_feedback.hurt_flash/.22*.65
		for x in [game.ui_bleed.position.x,game.ui_bleed.end.x-12]:draw_rect(Rect2(x,game.ui_bleed.position.y,12,game.ui_bleed.size.y),Color(1,.28,.35,alpha))
		for y in [game.ui_bleed.position.y,game.ui_bleed.end.y-12]:draw_rect(Rect2(game.ui_bleed.position.x,y,game.ui_bleed.size.x,12),Color(1,.28,.35,alpha))
	# Large contrast bars supplement the numeric HUD.
	var bar = Rect2(Vector2(80,135)+game.hud_top_left(),Vector2(420,20))
	draw_style_box(game.style(Color('#0e182b')),bar.grow(4))
	draw_rect(Rect2(bar.position,Vector2(bar.size.x*maxf(0,game.hp/game.max_hp),20)),Color('#ff4757'))
	bar = Rect2(Vector2(80,168)+game.hud_top_left(),Vector2(420,12))
	draw_rect(bar,Color('#0e182b'))
	draw_rect(Rect2(bar.position,Vector2(bar.size.x*minf(1,float(game.xp)/game.required_xp()),12)),Color('#00d9d0'))
	for enemy in game.enemies:
		if enemy.kind=='boss':
			draw_rect(Rect2(620,245+game.safe_logical.position.y,680,24),Color('#0e182b'))
			draw_rect(Rect2(620,245+game.safe_logical.position.y,680*clampf(enemy.hp/enemy.max_hp,0,1),24),Color('#ff4757'))

	# Real equipment art uses the same atlas as the held weapons and shop offers.
	for i in range(game.weapons.size()):
		var w=game.weapons[i]
		var at=Vector2(1100+i*116,44)+game.hud_top_right()
		draw_style_box(game.style(Color('#18263d')),Rect2(at,Vector2(104,104)))
		draw_string(preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf'),at+Vector2(4,19),{'blaster':'BLASTER','hammer':'HAMMER','splitgun':'SPLITGUN','arc':'ARC','orbit':'ORBIT','mop':'MOPP','bomb':'BOMBE','tools':'WERKZEUG'}.get(w.id,game.weapon_data[w.id].name),HORIZONTAL_ALIGNMENT_CENTER,96,16,Color.WHITE)
		draw_texture_rect_region(CombatArt.weapon_texture(w.id),Rect2(at+Vector2(6,18),Vector2(92,61)),CombatArt.weapon(w.id))
		draw_string(preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf'),at+Vector2(32,94),'Lv.'+str(w.level),HORIZONTAL_ALIGNMENT_LEFT,-1,19,Color('#ffd166'))

		if not game.Specs.definition(w).is_empty():draw_texture_rect(game.Specs.icon(w.spec),Rect2(at+Vector2(74,70),Vector2(26,26)),false)
