extends RefCounted
const R=preload('res://scripts/core/roster.gd')
var game:Node2D
var fire_fields:Array=[]
var fire_clock=0.0
var burn_tick=0.0
var overcharge=0.0
var shield=0.0
var shield_time=0.0
var invulnerability=0.0
var decoy_time=0.0
var decoy=Vector2.ZERO
func _init(g:Node2D):game=g
func hero() -> String:return game.characters[game.selected].id
func clear():fire_fields.clear();burn_tick=0;fire_clock=0;overcharge=0;shield=0;shield_time=0;invulnerability=0;decoy_time=0
func rate() -> float:return 1.4 if overcharge>0 else 1.0
func absorb(damage:float) -> float:
	if shield<=0:return damage
	var stopped=minf(shield,damage);shield-=stopped;game.add_effect(game.player.position,Color('#8BAEFF'),38,'SCHILD -%d' % ceili(stopped));return damage-stopped
func active():
	match hero():
		'cinder':fire_clock=5
		'frosty':
			for e in game.enemies.duplicate():
				if e.pos.distance_to(game.player.position)>280+e.radius:continue
				if R.BOSS_KINDS.has(e.kind):e.ability_slow=.65;e.ability_slow_time=2.4
				else:e.steel_stun=2.0;game.united.enemies.interrupt(e);game.ravox.interrupt(e);game.enemy_pack.interrupt(e)
				game.damage_enemy(e,40*game.damage_mult)
				if game.state!=game.State.COMBAT:return
		'volt':
			overcharge=6
			var w={'id':'tesla','level':3,'clock':0.0};chain(w,30*game.damage_mult,5)
		'rook':shield=80;shield_time=8
		'nyx':decoy=game.player.position;decoy_time=4;invulnerability=.45
func power(w:Dictionary) -> float:
	return float(game.weapon_data[w.id].damage)*(1+(int(w.level)-1)*.3)*game.damage_mult*game.gear_weapon_multiplier(w.id)*(1+float(game.characters[game.selected].get('element_bonus',0)))
func attack(w:Dictionary,dt:float):
	if game.state!=game.State.COMBAT:return
	w.clock-=dt
	if w.clock>0:return
	var d=game.weapon_data[w.id];var target=game.nearest(game.player.position,float(d.reach)+10*(int(w.level)-1))
	if target==null:return
	var spec=game.Specs.definition(w);var amount=power(w)*float(spec.get('damage',1));var dir:Vector2=game.player.position.direction_to(target.pos)
	w.clock=float(d.cooldown)/game.attack_mult/(1+.06*(int(w.level)-1));game.combat_visuals.attack(w.id,dir,w.level)
	match w.id:
		'flame':
			var angle=.9 if spec.get('variant',-1)==0 else .55
			for e in game.enemies.duplicate():
				var offset:Vector2=e.pos-game.player.position
				if offset.length()>float(d.reach)+10*(w.level-1)+e.radius or dir.dot(offset.normalized())<cos(angle):continue
				game.damage_enemy(e,amount)
				if game.state!=game.State.COMBAT:return
			game.vfx.burst(game.player.position+dir*70,Color('#FFAB47'),game.vfx.limits().burst*2,'spark',140)
			if spec.get('variant',-1)==1:add_fire(target.pos,70,3,amount*2)
		'tesla':chain(w,amount,5 if spec.get('variant',-1)==0 else 3)
		'lance':
			for e in game.enemies.duplicate():
				var offset:Vector2=e.pos-game.player.position;var reach=float(d.reach)+(70 if spec.get('variant',-1)==0 else 0)
				if offset.length()>reach+e.radius or (spec.get('variant',-1)!=1 and dir.dot(offset.normalized())<.4):continue
				game.combat_visuals.impact(e.pos,'lance');game.damage_enemy(e,amount)
				if game.state!=game.State.COMBAT:return
				if game.enemies.has(e) and not R.BOSS_KINDS.has(e.kind):game.united.enemies.interrupt(e);e.pos=(e.pos+dir*(70 if spec.get('variant',-1)==1 else 30)).clamp(Vector2(35,35),Vector2(2365,1565))
		'cryo','chakram':
			var count=(3 if w.id=='cryo' and spec.get('variant',-1)==1 else (2 if w.id=='chakram' and spec.get('variant',-1)==0 else 1))+game.multishot
			for i in range(count):
				var direction=dir.rotated((i-(count-1)*.5)*.15)
				var shot=game.shoot(game.player.position+direction*28,direction,amount,false,(470 if w.id=='chakram' else 620)*game.projectile_speed,2.0,w.id)
				if shot==null:continue
				shot.united=true;shot.united_age=0.0;shot.united_leg=0;shot.united_hits=[];shot.united_pierce=4 if spec.get('variant',-1)==0 and w.id=='cryo' else (2 if w.level>=3 else 1);shot.united_spec=int(spec.get('variant',-1))
func chain(w:Dictionary,amount:float,count:int):
	var at:Vector2=game.player.position;var hit=[]
	for i in range(count):
		var nearest=null;var distance=380.0 if i==0 else 225.0
		for e in game.enemies:
			if not hit.has(e) and e.pos.distance_to(at)<distance:nearest=e;distance=e.pos.distance_to(at)
		if nearest==null:break
		hit.append(nearest);game.combat_visuals.beam(at,nearest.pos);at=nearest.pos
		if game.Specs.definition(w).get('variant',-1)==1:nearest.ability_slow=.6;nearest.ability_slow_time=1.2
		game.damage_enemy(nearest,amount*(1-i*.09))
		if game.state!=game.State.COMBAT:return
func projectile(s:Dictionary,before:Vector2,dt:float):
	s.united_age+=dt
	if s.weapon=='chakram':
		if s.united_age>=(.8 if s.united_spec==1 else .55) and s.united_leg==0:s.united_leg=1;s.united_hits.clear();s.damage*=1.35 if s.united_spec==1 else 1.0
		if s.united_leg==1:
			s.vel=s.pos.direction_to(game.player.position)*s.vel.length()
			if s.pos.distance_to(game.player.position)<28:s.active=false;return
	for e in game.enemies.duplicate():
		if s.united_hits.has(e) or Geometry2D.get_closest_point_to_segment(e.pos,before,s.pos).distance_to(e.pos)>e.radius+9:continue
		s.united_hits.append(e)
		if s.weapon=='cryo':e.ability_slow=.55 if s.united_spec==1 else .65;e.ability_slow_time=1.5*(1+float(game.characters[game.selected].get('slow_bonus',0)))
		game.combat_visuals.impact(e.pos,s.weapon);game.damage_enemy(e,s.damage)
		if game.state!=game.State.COMBAT:return
		if s.weapon=='cryo' and s.united_hits.size()>=s.united_pierce:s.active=false;return
func add_fire(at:Vector2,radius:float,life:float,power_value:float):
	if fire_fields.size()>=6:fire_fields.pop_front()
	fire_fields.append({'pos':at,'radius':radius,'life':life,'power':power_value})
func update(dt:float):
	if game.state!=game.State.COMBAT:return
	overcharge=maxf(0,overcharge-dt);invulnerability=maxf(0,invulnerability-dt);decoy_time=maxf(0,decoy_time-dt);shield_time=maxf(0,shield_time-dt)
	if shield_time<=0:shield=0
	var fire_active=fire_clock>0
	fire_clock=maxf(0,fire_clock-dt)
	burn_tick+=dt
	if burn_tick>=.2:
		var step=minf(.4,burn_tick);burn_tick=0
		for e in game.enemies.duplicate():
			var dose=18*game.damage_mult*1.15*step if fire_active and e.pos.distance_to(game.player.position)<=220+e.radius else 0.0
			var field_dose=0.0
			for f in fire_fields:
				if f.pos.distance_to(e.pos)<=f.radius+e.radius:field_dose=maxf(field_dose,f.power*step)
			dose+=field_dose
			if dose>0:game.damage_enemy(e,dose)
			if game.state!=game.State.COMBAT:return
	for i in range(fire_fields.size()-1,-1,-1):
		fire_fields[i].life-=dt
		if fire_fields[i].life<=0:fire_fields.remove_at(i)
func draw():
	for f in fire_fields:game.draw_circle(f.pos,f.radius,Color(1,.35,.05,.16));game.draw_arc(f.pos,f.radius,0,TAU,32,Color('#FF9F45'),3,true)
	if fire_clock>0:game.draw_arc(game.player.position,220,0,TAU,64,Color(1,.55,.15,.6),8,true)
	if shield>0:game.draw_arc(game.player.position,49,0,TAU*shield/80,48,Color('#8BAEFF'),6,true)
	if decoy_time>0:
		var art=preload('res://scripts/expansion/comic_art.gd');game.draw_texture_rect_region(art.HEROES,Rect2(decoy-Vector2(48,64),Vector2(96,96)),art.hero('nyx'),Color(.8,.4,1,.4))
