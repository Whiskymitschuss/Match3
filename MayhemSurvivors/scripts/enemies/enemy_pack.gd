extends RefCounted
var game:Node2D
var enabled=true
const CONFIG={'bombling':{'first':2,'cap':4,'warm':1.4,'cooldown':4.0,'range':150},'longshot':{'first':4,'cap':2,'warm':1.6,'cooldown':4.0,'range':700},'hexling':{'first':6,'cap':2,'warm':1.7,'cooldown':5.0,'range':480}}
func _init(g:Node2D):game=g
func count(kind:String) -> int:
	var n=0
	for e in game.enemies:
		if e.kind==kind and e.hp>0:n+=1
	return n
func choose(normal:String,roll:float) -> String:
	if not enabled or game.rules.boss_wave() or game.run_mode=='tutorial':return normal
	var kind='bombling' if roll>=.55 and roll<.63 else ('longshot' if roll>=.63 and roll<.69 else ('hexling' if roll>=.69 and roll<.75 else ''))
	return kind if kind!='' and game.wave_number>=CONFIG[kind].first and count(kind)<CONFIG[kind].cap else normal
func initialize(e:Dictionary):
	if not CONFIG.has(e.kind):return
	e.pack_stage='chase';e.pack_clock=2.0;e.pack_aim=e.pos;e.pack_origin=e.pos
func interrupt(e:Dictionary):
	if CONFIG.has(e.kind) and e.get('pack_stage','') in ['windup','release']:e.pack_stage='chase';e.pack_clock=2.0
func velocity(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	if game.state!=game.State.COMBAT or not CONFIG.has(e.kind):return Vector2.ZERO
	var d=CONFIG[e.kind]
	if e.pack_stage=='windup':
		if not game.enemy_roles.visible(e.pos) or e.pos.distance_to(e.pack_origin)>8:interrupt(e);return Vector2.ZERO
		e.pack_clock=maxf(0,e.pack_clock-dt)
		if e.pack_clock<=0:
			e.pack_stage='release';e.pack_clock=float(d.cooldown)
		return Vector2.ZERO
	if e.pack_stage=='release':return Vector2.ZERO
	if not game.enemy_roles.visible(e.pos):return normal
	e.pack_clock=maxf(0,e.pack_clock-dt)
	var distance:float=e.pos.distance_to(game.player.position)
	if e.pack_clock<=0 and distance<=d.range:
		var warnings=0
		for other in game.enemies:
			if CONFIG.has(other.kind) and other.get('pack_stage','') in ['windup','release']:warnings+=1
		if warnings<2 and not (e.kind=='hexling' and game.arena_events.active):
			e.pack_stage='windup';e.pack_clock=float(d.warm);e.pack_aim=game.player.position;e.pack_origin=e.pos;game.sound('ravox_warning');return Vector2.ZERO
	if e.kind!='bombling' and distance<float(d.range)*.65:return Vector2.ZERO
	return normal
func resolve(e:Dictionary):
	if game.state!=game.State.COMBAT or not CONFIG.has(e.kind) or e.pack_stage!='release' or not game.enemies.has(e):return
	if e.get('suds_stun',0.0)>0 or e.get('steel_stun',0.0)>0:interrupt(e);return
	if not game.enemy_roles.visible(e.pos):e.pack_stage='chase';return
	e.pack_stage='chase'
	if e.kind=='bombling':
		var origin:Vector2=e.pack_origin;e.hp=0;game.world_visuals.enemy_defeated(e);game.enemy_roles.removed(e);game.enemies.erase(e)
		game.vfx.explosion(origin,120,Color('#FF9F1C'))
		if origin.distance_to(game.player.position)<=147:game.hurt(e.damage)
	elif e.kind=='longshot':
		var dir:Vector2=(e.pack_aim-e.pos).normalized()
		if dir.length_squared()>.01:game.shoot(e.pos,dir,e.damage,true,540,1.6);game.sound('spitter_fire')
	elif e.kind=='hexling' and game.arena_hazards.items.size()<12:
		game.arena_hazards.bomb(e.pack_aim,100,.8);game.arena_hazards.items.back().damage=e.damage
func draw():
	for e in game.enemies:
		if not CONFIG.has(e.kind) or e.get('pack_stage','') not in ['windup','release']:continue
		var color=Color('#FFD166');var progress=1-float(e.pack_clock)/float(CONFIG[e.kind].warm) if e.pack_stage=='windup' else 1.0
		game.draw_arc(e.pos,e.radius+12,-PI*.5,-PI*.5+TAU*progress,28,color,3,true)
		if e.kind=='bombling':
			game.draw_circle(e.pack_origin,120,Color(1,.4,.1,.12));game.draw_arc(e.pack_origin,120,0,TAU,32,Color('#FF9F1C'),3,true)
		elif e.kind=='longshot':
			var end:Vector2=e.pack_origin+(e.pack_aim-e.pack_origin).normalized()*864
			game.draw_line(e.pack_origin,end,Color(1,.25,.3,.65),4,true)
		else:game.draw_arc(e.pack_aim,100,0,TAU,32,Color('#E879F9'),4,true)
