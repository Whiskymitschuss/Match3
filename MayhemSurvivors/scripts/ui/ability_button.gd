extends Button
var game:Node2D
const ICONS={'toxin_cloud':preload('res://assets/ui/abilities/toxin_cloud.svg'),'sonic_burst':preload('res://assets/ui/abilities/sonic_burst.svg'),'light_pulse':preload('res://assets/ui/abilities/light_pulse.svg'),'repair_drone':preload('res://assets/ui/abilities/repair_drone.svg'),'firestorm':preload('res://assets/ui/abilities/firestorm.svg'),'absolute_zero':preload('res://assets/ui/abilities/absolute_zero.svg'),'overcharge':preload('res://assets/ui/abilities/overcharge.svg'),'bastion':preload('res://assets/ui/abilities/bastion.svg'),'phase_dance':preload('res://assets/ui/abilities/phase_dance.svg'),'pipe_burst':preload('res://assets/ui/abilities/pipe_burst.svg'),'chain_reaction':preload('res://assets/ui/abilities/chain_reaction.svg'),'twinkle_tornado':preload('res://assets/ui/abilities/twinkle_tornado.svg'),'shockwave':preload('res://assets/ui/abilities/shockwave.svg'),'impulse':preload('res://assets/ui/abilities/impulse.svg'),'shadow_step':preload('res://assets/ui/abilities/shadow_step.svg')}
func _draw():
	if not is_instance_valid(game):return
	var touch_scale=game.touch_geometry().scale
	draw_set_transform(Vector2.ZERO,0,Vector2.ONE*touch_scale)
	var a=game.hero_ability
	var d=a.definition()
	var ready=a.ready_to_use()
	var color=Color(d.color)
	var icon_rect=Rect2(Vector2((size.x/touch_scale)/2-38,10),Vector2(76,76))
	draw_texture_rect(ICONS.get(d.id,preload('res://scripts/ui/icon_catalog.gd').get_icon('shockwave')),icon_rect,false,Color.WHITE if ready else Color(.65,.65,.75))
	var font=preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf')
	draw_string(font,Vector2(10,121),d.name,HORIZONTAL_ALIGNMENT_CENTER,(size.x/touch_scale)-20,23,color)
	var status='BEREIT' if ready else ('AKTIV' if a.invulnerable() or game.twinkle.tornado_left>0 else '%.1f s' % a.cooldown)
	if d.id=='pipe_burst' and game.steelfist.buff_left>0:status='KRAFT %.1f s / CD %.0f s' % [game.steelfist.buff_left,a.cooldown]
	if d.id in ['firestorm','overcharge','bastion','phase_dance']:
		var left={'firestorm':game.united.heroes.fire_clock,'overcharge':game.united.heroes.overcharge,'bastion':game.united.heroes.shield_time,'phase_dance':game.united.heroes.decoy_time}[d.id]
		if left>0:status='AKTIV %.1f s / CD %.0f s' % [left,a.cooldown]
	if d.id in ['toxin_cloud','light_pulse','repair_drone'] and game.crew.active_left()>0:status='AKTIV %.1f s / CD %.0f s' % [game.crew.active_left(),a.cooldown]
	if game.tutorial and game.tutorial.frozen():status='PAUSIERT'
	draw_string(font,Vector2(10,164),status,HORIZONTAL_ALIGNMENT_CENTER,(size.x/touch_scale)-20,30,Color.WHITE)
	draw_rect(Rect2(14,185,(size.x/touch_scale)-28,9),Color('#0E182B'))
	draw_rect(Rect2(14,185,((size.x/touch_scale)-28)*(1-clampf(a.cooldown/d.cooldown,0,1)),9),color)
