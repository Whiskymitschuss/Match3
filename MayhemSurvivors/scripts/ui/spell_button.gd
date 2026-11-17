extends Button
var game:Node2D
func _draw():
	if not is_instance_valid(game) or game.equipped_spell.id=='':return
	var spell=game.equipped_spell;var d=spell.C.catalog().items[spell.id]
	draw_texture_rect(preload('res://scripts/ui/gear_art.gd').icon(spell.id),Rect2(15,12,75,75),false)
	var font=game.UISkin.HEADING
	draw_string(font,Vector2(105,40),d.name,HORIZONTAL_ALIGNMENT_LEFT,180,23,Color(d.color))
	draw_string(font,Vector2(105,77),'VOLLE HP' if spell.id=='heal_pulse' and game.hp>=game.max_hp and spell.cooldown<=0 else ('BEREIT' if spell.ready() else '%.1f s' % spell.cooldown),HORIZONTAL_ALIGNMENT_LEFT,180,27,Color.WHITE)
	draw_rect(Rect2(15,110,270,8),Color('#101625'));draw_rect(Rect2(15,110,270*(1-clampf(spell.cooldown/spell.duration(),0,1)),8),Color(d.color))
