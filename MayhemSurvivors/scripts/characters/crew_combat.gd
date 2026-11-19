extends RefCounted
# Four additional classes share the existing projectile pool and visual budgets.
const IDS=['viper','echo','nova','rivet']
var owner_ref:WeakRef
var game:Node2D:
	get:return owner_ref.get_ref()
var cloud:Dictionary={}
var drone_left=0.0
var drone_clock=0.0
var heal_clock=0.0
var drone_phase=0.0
var sonic_flash=0.0
var shield=0.0
var shield_left=0.0
func _init(g:Node2D):owner_ref=weakref(g)
func hero() -> String:return game.characters[game.selected].id
func live() -> bool:return game.state==game.State.COMBAT and not (game.tutorial and game.tutorial.active and game.tutorial.frozen())
func clear():
	cloud.clear();sonic_flash=0;drone_left=0;drone_clock=0;heal_clock=0;drone_phase=0;shield=0;shield_left=0
	for e in game.enemies:
		for key in ['toxin_left','toxin_clock']:e.erase(key)
func active_left() -> float:return maxf(shield_left,maxf(drone_left,float(cloud.get('left',0))))
func heal(amount:float):
	if not live() or game.hp<=0:return
	var restored=minf(amount,game.max_hp-game.hp)
	if restored<=0:return
	game.hp+=restored;game.add_effect(game.player.position,Color('#2ED573'),42,'+%d HP' % ceili(restored));game.sound('crew_heal')
func absorb(amount:float) -> float:
	if shield<=0:return amount
	var stopped=minf(shield,amount);shield-=stopped
	return amount-stopped
func after_hit(e:Dictionary,weapon:String):
	if not live() or hero()!='viper' or weapon!='blaster' or e.hp<=0 or not game.enemies.has(e):return
	e.toxin_left=float(game.characters[game.selected].poison_duration)
	if not e.has('toxin_clock'):e.toxin_clock=0.0
func on_kill():
	if live() and hero()=='nova' and game.kills>0 and game.kills%maxi(1,int(game.characters[game.selected].heal_every_kills))==0:heal(float(game.characters[game.selected].heal_per_cycle))
func activate():
	if not live() or hero() not in IDS:return
	var d=game.hero_ability.definition();var color=Color(d.color)
	match hero():
		'viper':
			var target=game.nearest(game.player.position,400)
			var at:Vector2=target.pos if target!=null else game.player.position
			cloud={'at':at,'left':float(d.duration),'clock':0.0,'radius':float(d.radius),'damage':float(d.damage)}
			ring(at,d.radius,color)
		'echo':
			sonic_flash=.45
			ring(game.player.position,d.radius,color)
			for e in game.enemies.duplicate():
				if e.pos.distance_to(game.player.position)>d.radius+e.radius:continue
				game.damage_enemy(e,d.damage*game.damage_mult)
				if not live():return
				if game.enemies.has(e) and e.kind not in game.united.R.BOSS_KINDS:
					game.united.enemies.interrupt(e);game.ravox.interrupt(e);game.enemy_pack.interrupt(e);game.encounters.interrupt_elite(e)
					e.steel_stun=float(d.stun);var direction:Vector2=game.player.position.direction_to(e.pos)
					if direction==Vector2.ZERO:direction=Vector2.RIGHT
					e.pos=(e.pos+direction*float(d.push)).clamp(Vector2(35,35),Vector2(2365,1565))
		'nova':heal(float(d.heal));shield=float(d.shield);shield_left=float(d.duration);ring(game.player.position,125,color)
		'rivet':drone_left=float(d.duration);drone_clock=0;heal_clock=0;ring(game.player.position,85,color)
func ring(at:Vector2,radius:float,color:Color):game.specialized_combat.ring(at,radius,color)
func drone_position() -> Vector2:return game.player.position+Vector2(cos(drone_phase)*60,-65+sin(drone_phase)*12)
func update(dt:float):
	if not live() or hero() not in IDS:return
	sonic_flash=maxf(0,sonic_flash-dt)
	shield_left=maxf(0,shield_left-dt)
	if shield_left<=0:shield=0
	# Poison refreshes duration, never stacks. Actual elapsed doses are applied at 2 Hz.
	for e in game.enemies.duplicate():
		if float(e.get('toxin_left',0))<=0:continue
		var dose=minf(dt,float(e.toxin_left));e.toxin_left=maxf(0,e.toxin_left-dt);e.toxin_clock+=dose
		if e.toxin_clock>=.5 or e.toxin_left<=0:
			var amount=float(e.toxin_clock)*float(game.characters[game.selected].poison_dps)*game.damage_mult;e.toxin_clock=0
			game.damage_enemy(e,amount,'toxin')
			if not live():return
	if not cloud.is_empty():
		var active=minf(dt,float(cloud.left));cloud.left=maxf(0,cloud.left-dt);cloud.clock+=active
		if cloud.clock>=.5 or cloud.left<=0:
			var amount=float(cloud.clock)*float(cloud.damage)*game.damage_mult;cloud.clock=0
			for e in game.enemies.duplicate():
				if e.pos.distance_to(cloud.at)>float(cloud.radius)+e.radius:continue
				game.damage_enemy(e,amount,'toxin')
				if not live():return
		if cloud.left<=0:cloud.clear()
	if drone_left<=0:return
	var active=minf(dt,drone_left);drone_left=maxf(0,drone_left-dt);drone_clock-=active;heal_clock+=active;drone_phase+=active*2
	var drone_data=game.hero_ability.data.rivet
	if heal_clock>=float(drone_data.heal_interval):
		var doses=floori(heal_clock/float(drone_data.heal_interval));heal_clock-=doses*float(drone_data.heal_interval);heal(doses*float(drone_data.heal))
	if drone_clock<=0:
		var target=game.nearest(drone_position(),float(drone_data.reach))
		if target!=null:
			var at=drone_position();var d=game.hero_ability.data.rivet
			game.shoot(at,at.direction_to(target.pos),float(d.damage)*game.damage_mult,false,float(d.projectile_speed)*game.projectile_speed,float(d.projectile_lifetime),'blaster');game.sound('drone_pulse')
		drone_clock=float(game.hero_ability.data.rivet.interval)
func draw():
	if sonic_flash>0:
		var t=1-sonic_flash/.45
		for i in range(3):game.draw_arc(game.player.position,40+180*t+i*15,0,TAU,40,Color(1,.72,.3,(1-t)*(.8-i*.2)),4-i,true)
	if not cloud.is_empty():
		var color=Color('#B2EB42');game.draw_circle(cloud.at,cloud.radius,Color(color,.14));game.draw_arc(cloud.at,cloud.radius,0,TAU,36,color,3,true)
		for i in range(5):
			var at:Vector2=cloud.at+Vector2.from_angle(i*TAU/5+game.run_time*.5)*float(cloud.radius)*.55
			game.draw_circle(at,12+sin(game.run_time*3+i)*3,Color(color,.25))
	for e in game.enemies:
		if float(e.get('toxin_left',0))>0:game.draw_arc(e.pos+Vector2(0,9),e.radius+5,0,TAU,16,Color('#B2EB42'),2,true)
	if shield>0:game.draw_arc(game.player.position,53,-PI/2,-PI/2+TAU*shield/35,36,Color('#FFE8A1'),5,true)
	if drone_left>0:
		var at=drone_position();game.draw_line(at+Vector2(-26,-20),at+Vector2(26,-20),Color('#99FFFF'),3,true)
		game.draw_circle(at+Vector2(-21,-20),10,Color('#263747'));game.draw_circle(at+Vector2(21,-20),10,Color('#263747'))
		game.draw_rect(Rect2(at-Vector2(21,15),Vector2(42,30)),Color('#101522'));game.draw_rect(Rect2(at-Vector2(17,11),Vector2(34,22)),Color('#6EDDD2'));game.draw_circle(at+Vector2(0,-1),6,Color('#FFD166'))
