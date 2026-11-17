extends RefCounted
const Specs=preload('res://scripts/weapons/specializations.gd')
var game:Node2D
var data:Dictionary
var attacks=0
var regen_clock=0.0
var buff_left=0.0
var buff_extension=0.0
var sweeps:Array=[]
var pressure:Array=[]
func _init(g:Node2D):game=g;data=game.read_data('characters/steelfist')
func active() -> bool:return game.characters[game.selected].id=='steelfist'
func clear():buff_left=0;buff_extension=0;sweeps.clear();pressure.clear()
func reset_run():clear();attacks=0;regen_clock=0
func damage_factor() -> float:return 1.0-float(game.characters[game.selected].get('damage_reduction',0))
func speed_multiplier() -> float:return 1.0+float(game.hero_ability.data.steelfist.buff_attack_speed) if active() and buff_left>0 else 1.0
func power(w:Dictionary) -> float:
	return float(game.weapon_data.tools.damage)*(1+(int(w.level)-1)*.3)*game.damage_mult*(1+float(game.characters[game.selected].melee_bonus))*float(Specs.definition(w).get('power',1))
func cooldown(w:Dictionary) -> float:
	return float(game.weapon_data.tools.cooldown)/game.attack_mult/speed_multiplier()/(1+.06*(int(w.level)-1))*float(Specs.definition(w).get('cooldown',1))
func reach(w:Dictionary) -> float:return (float(game.weapon_data.tools.reach)+10*(int(w.level)-1))*float(Specs.definition(w).get('reach',1))
func attack(w:Dictionary,dt:float):
	if not active() or game.state!=game.State.COMBAT:return
	w.clock-=dt
	if w.clock>0:return
	var range_value=reach(w);var target=game.nearest(game.player.position,range_value)
	if target==null:return
	w.clock=cooldown(w);attacks+=1
	var double_hit=attacks%int(data.double_every)==0
	var direction:Vector2=(target.pos-game.player.position).normalized()
	if direction==Vector2.ZERO:direction=Vector2(game.facing,0)
	game.combat_visuals.attack('tools',direction,int(w.level))
	var rig=game.combat_visuals.rig('tools');rig.hand=(attacks-1)%2;rig.double_hit=double_hit
	if sweeps.size()>=4:sweeps.pop_front()
	sweeps.append({'pos':game.player.position,'angle':direction.angle(),'radius':range_value,'life':.3,'double_hit':double_hit})
	var amount=power(w)*(float(data.double_multiplier) if double_hit else 1.0)
	for e in game.enemies.duplicate():
		var offset:Vector2=e.pos-game.player.position
		if offset.length()>range_value+e.radius or (offset!=Vector2.ZERO and direction.dot(offset.normalized())<0):continue
		game.combat_visuals.impact(e.pos,'tools');game.damage_enemy(e,amount)
		if game.state!=game.State.COMBAT:return
		if double_hit and game.enemies.has(e):displace(e,float(data.heavy_knockback))
func displace(e:Dictionary,distance:float):
	game.encounters.interrupt_elite(e);game.ravox.interrupt(e);game.enemy_pack.interrupt(e)
	if e.kind=='spitter':e.windup=0;e.attack_clock=2.0
	var direction:Vector2=(e.pos-game.player.position).normalized()
	if direction==Vector2.ZERO:direction=Vector2.RIGHT
	e.pos=(e.pos+direction*distance).clamp(Vector2(35,35),Vector2(2365,1565))
func activate():
	if not active() or game.state!=game.State.COMBAT:return
	var d=game.hero_ability.definition();var w:Dictionary={}
	for weapon in game.weapons:
		if weapon.id=='tools':w=weapon;break
	if w.is_empty():return
	buff_left=d.buff_duration;buff_extension=0
	if pressure.size()>=3:pressure.pop_front()
	pressure.append({'pos':game.player.position,'radius':float(d.radius),'life':1.1})
	game.vfx.ground_impact(game.player.position,float(d.radius),Color(d.color))
	game.vfx.burst(game.player.position,Color('#CFF7FF'),game.vfx.limits().burst*3,'smoke',160)
	var amount=power(w)*float(d.damage_multiplier)
	for e in game.enemies.duplicate():
		if e.pos.distance_to(game.player.position)>float(d.radius)+e.radius:continue
		e.steel_stun=float(d.stun)
		displace(e,float(d.knockback))
		game.damage_enemy(e,amount)
		if game.state!=game.State.COMBAT:return
func on_kill():
	if not active() or game.state!=game.State.COMBAT or buff_left<=0:return
	var extra=minf(float(data.buff_kill_extension),maxf(0,float(data.buff_extension_cap)-buff_extension))
	buff_left+=extra;buff_extension+=extra
func boss_stunned() -> bool:
	if not active():return false
	for e in game.enemies:
		if e.kind=='boss' and float(e.get('steel_stun',0))>0:return true
	return false
func stunned(e:Dictionary,dt:float) -> bool:
	var was=float(e.get('steel_stun',0))>0
	if was:e.steel_stun=maxf(0,float(e.steel_stun)-dt)
	return was
func update(dt:float):
	if not active() or game.state!=game.State.COMBAT or game.hp<=0 or dt<=0:return
	buff_left=maxf(0,buff_left-dt)
	regen_clock+=dt
	var ticks=floori((regen_clock+.000001)/float(data.regen_interval))
	if ticks>0:
		regen_clock=maxf(0,regen_clock-ticks*float(data.regen_interval))
		var before:float=game.hp
		game.hp=minf(game.max_hp,game.hp+game.max_hp*float(data.regen_fraction)*ticks)
		if game.hp>before:
			game.add_effect(game.player.position,Color('#5DDCFF'),35,'+%.1f HP' % (game.hp-before));game.sound('steel_regen')
	for collection in [sweeps,pressure]:
		for i in range(collection.size()-1,-1,-1):
			collection[i].life-=dt
			if collection[i].life<=0:collection.remove_at(i)
func draw_floor():
	if not active():return
	for sweep in sweeps:
		var alpha:float=sweep.life/.3
		game.draw_arc(sweep.pos,sweep.radius,sweep.angle-PI*.5,sweep.angle+PI*.5,30,Color(.36,.86,1,alpha*.7),5,true)
		if sweep.double_hit:game.draw_arc(sweep.pos,sweep.radius-16,sweep.angle-PI*.5,sweep.angle+PI*.5,30,Color(1,.62,.11,alpha*.8),6,true)
	for wave in pressure:
		var progress=1-wave.life/1.1
		game.draw_circle(wave.pos,wave.radius*progress,Color(.35,.85,1,wave.life*.08))
		for j in range(3):game.draw_arc(wave.pos,wave.radius*clampf(progress*1.6-j*.15,0,1),0,TAU,48,Color(.45,.9,1,wave.life*(.6-j*.15)),5,true)
		var jets=6 if game.saved.settings.quality=='LOW' else 12
		for j in range(jets):
			var dir=Vector2.from_angle(j*TAU/jets);var at:Vector2=wave.pos+dir*wave.radius*.55
			game.draw_line(at,at-Vector2(0,80*progress),Color(.85,.97,1,wave.life*.5),10,true)
			game.draw_circle(at-Vector2(0,80*progress),14+20*progress,Color(.85,.97,1,wave.life*.17))
	for e in game.enemies:
		if float(e.get('steel_stun',0))<=0:continue
		var at:Vector2=e.pos-Vector2(0,e.radius+16)
		game.draw_arc(at,15,0,TAU,18,Color('#5DDCFF'),2,true)
		for i in range(3):game.draw_circle(at+Vector2.from_angle(game.animation_clock*3+i*TAU/3)*15,3,Color('#FFD166'))
	if buff_left>0:
		game.draw_arc(game.player.position,48,game.animation_clock*3,game.animation_clock*3+PI*1.5,24,Color('#5DDCFF'),3,true)
