extends Button
var game:Node2D
const ICONS={'pipe_burst':preload('res://assets/ui/abilities/pipe_burst.svg'),'chain_reaction':preload('res://assets/ui/abilities/chain_reaction.svg'),'twinkle_tornado':preload('res://assets/ui/abilities/twinkle_tornado.svg'),'shockwave':preload('res://assets/ui/abilities/shockwave.svg'),'impulse':preload('res://assets/ui/abilities/impulse.svg'),'shadow_step':preload('res://assets/ui/abilities/shadow_step.svg')}
func _draw():
	if not is_instance_valid(game):return
	var a=game.hero_ability
	var d=a.definition()
	var ready=a.ready_to_use()
	var color=Color(d.color)
	var icon_rect=Rect2(Vector2(size.x/2-38,10),Vector2(76,76))
	draw_texture_rect(ICONS[d.id],icon_rect,false,Color.WHITE if ready else Color(.65,.65,.75))
	var font=preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf')
	draw_string(font,Vector2(10,121),d.name,HORIZONTAL_ALIGNMENT_CENTER,size.x-20,23,color)
	var status='BEREIT' if ready else ('AKTIV' if a.invulnerable() or game.twinkle.tornado_left>0 else '%.1f s' % a.cooldown)
	if d.id=='pipe_burst' and game.steelfist.buff_left>0:status='KRAFT %.1f s / CD %.0f s' % [game.steelfist.buff_left,a.cooldown]
	if game.tutorial and game.tutorial.frozen():status='PAUSIERT'
	draw_string(font,Vector2(10,164),status,HORIZONTAL_ALIGNMENT_CENTER,size.x-20,30,Color.WHITE)
	draw_rect(Rect2(14,185,size.x-28,9),Color('#0E182B'))
	draw_rect(Rect2(14,185,(size.x-28)*(1-clampf(a.cooldown/d.cooldown,0,1)),9),color)
