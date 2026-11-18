extends RefCounted
const Specs=preload('res://scripts/weapons/specializations.gd')
var game:Node2D
var fx:Array=[]
func _init(g:Node2D):game=g
func clear():fx.clear()
func limit() -> int:
	return 8 if game.saved.settings.quality=='LOW' else (12 if game.saved.settings.quality=='MEDIUM' else 16)
func update(dt:float):
	while fx.size()>limit():fx.pop_front()
	for i in range(fx.size()-1,-1,-1):
		fx[i].life-=dt
		if fx[i].life<=0:fx.remove_at(i)
func ring(pos:Vector2,radius:float,color:Color):
	if radius>=200:game.vfx.ground_impact(pos,radius,color)
	elif radius>=75:game.vfx.explosion(pos,radius,color)
	var cap=limit()
	while fx.size()>=cap:fx.pop_front()
	fx.append({'pos':pos,'radius':radius,'color':color,'life':.4})
func orbit_pose(w:Dictionary) -> Dictionary:
	var d=Specs.definition(w)
	return {'angle':game.orbit_angle*float(d.get('angular',1.0)),'radius':float(d.get('radius',110+5*(w.level-1))),'size':float(d.get('size',68))}
func fire(w:Dictionary,d:Dictionary,power:float,dt:float):
	var base=game.weapon_data[w.id]
	if w.id=='orbit':
		var pose=orbit_pose(w)
		var blade=game.player.position+Vector2.from_angle(pose.angle)*pose.radius
		for e in game.enemies.duplicate():
			if e.pos.distance_to(blade)<e.radius+28 and e.orbit_cd<=0:
				e.orbit_cd=.5/game.attack_mult/(1+.08*(w.level-1))*d.hit_cooldown
				game.combat_visuals.impact(e.pos,'orbit')
				game.damage_enemy(e,game.united.bosses.weapon_power(w,e,power*d.power))
				if game.state!=game.State.COMBAT:return
		return
	w.clock-=dt
	if w.clock>0:return
	var reach:float=(float(base.reach)+10*(w.level-1))*float(d.get('reach',1.0))
	var target=game.nearest(game.player.position,reach)
	if target==null:return
	w.clock=float(base.cooldown)/game.attack_mult/(1+.06*(w.level-1))*float(d.get('cooldown',1.0))
	var direction:Vector2=(target.pos-game.player.position).normalized()
	game.combat_visuals.attack(w.id,direction,w.level)
	game.sound('spec_'+w.id)
	match w.id:
		'blaster','splitgun':
			var count=int(d.get('count',1))+game.multishot
			for j in range(count):
				var spread:float=float(d.get('spread',.15-.01*(w.level-1)))
				var shot=game.shoot(game.player.position+direction*30,direction.rotated((j-(count-1)*.5)*spread),power*d.power,false,650*game.projectile_speed*(1+.04*(w.level-1)),(float(base.reach)/650+.25)*float(d.get('reach',1.0)),w.id)
				if shot!=null:
					shot.spec=w.spec
					shot.hits_left=int(d.get('hits',1))
					shot.splash_power=power*float(d.get('splash',0))
		'hammer':
			if w.spec=='crusher':
				game.damage_enemy(target,power*d.power)
			else:
				ring(game.player.position,d.radius,Color(d.color))
				for e in game.enemies.duplicate():
					if e.pos.distance_to(game.player.position)<=d.radius+e.radius:
						game.damage_enemy(e,power*d.power)
						if game.state!=game.State.COMBAT:return
		'arc':
			var origin=game.player.position
			var hit:Array=[]
			for j in range(int(d.targets)):
				var choice=null
				var dist=reach if j==0 else 220.0+25*(w.level-1)+d.jump
				for e in game.enemies:
					if not hit.has(e) and origin.distance_to(e.pos)<dist:choice=e;dist=origin.distance_to(e.pos)
				if choice==null:break
				hit.append(choice)
				game.combat_visuals.beam(origin,choice.pos)
				ring(choice.pos,22,Color(d.color))
				origin=choice.pos
				game.damage_enemy(choice,power*d.power*(1-j*maxf(.04,.15-.02*(w.level-1))))
				if game.state!=game.State.COMBAT:return
func hit_before(shot:Dictionary,enemy:Dictionary) -> bool:
	for e in shot.hit_enemies:
		if is_same(e,enemy):return true
	return false
func projectile(shot:Dictionary,old:Vector2):
	var hits:Array=[]
	for e in game.enemies:
		if hit_before(shot,e):continue
		if Geometry2D.get_closest_point_to_segment(e.pos,old,shot.pos).distance_to(e.pos)<e.radius+8:hits.append(e)
	hits.sort_custom(func(a,b):return old.distance_squared_to(a.pos)<old.distance_squared_to(b.pos))
	for e in hits:
		if not game.enemies.has(e):continue
		shot.hit_enemies.append(e)
		shot.hits_left-=1
		var at:Vector2=e.pos
		game.combat_visuals.impact(at,shot.weapon)
		game.damage_enemy(e,shot.damage)
		if game.state!=game.State.COMBAT:return
		if shot.splash_power>0:
			var d=Specs.all()[shot.spec]
			ring(at,d.radius,Color(d.color))
			for other in game.enemies.duplicate():
				if is_same(other,e):continue
				if other.pos.distance_to(at)<=d.radius+other.radius:
					game.damage_enemy(other,shot.splash_power)
					if game.state!=game.State.COMBAT:return
		if shot.hits_left<=0:shot.active=false;return
func draw():
	for e in fx:
		var t:float=1-e.life/.4
		game.draw_arc(e.pos,e.radius*(.3+.7*t),0,TAU,40,Color(e.color,1-t),5,true)
		for i in range(6):
			var dir=Vector2.from_angle(i*TAU/6)
			game.draw_line(e.pos+dir*e.radius*t,e.pos+dir*(e.radius*t+12),Color(e.color,1-t),3,true)
