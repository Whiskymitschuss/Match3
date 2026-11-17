extends RefCounted
const Specs=preload('res://scripts/weapons/specializations.gd')
var game:Node2D
var pool:Array=[]
var queued:Array=[]
var fields:Array=[]
var burn_clock=0.0
const CAP=16
func _init(g:Node2D):
	game=g
	for i in range(CAP):pool.append({'active':false})
func active() -> bool:return game.characters[game.selected].id=='kicksy'
func clear():
	for b in pool:b.active=false
	queued.clear();fields.clear();burn_clock=0
func spawn(origin:Vector2,target:Vector2,power:float,radius:float,flight:float=.65,path:String='') -> bool:
	for b in pool:
		if b.active:continue
		b.clear();b.merge({'active':true,'origin':origin,'target':target.clamp(Vector2(45,45),Vector2(2355,1555)),'power':power,'radius':radius,'flight':maxf(.15,flight),'age':0.0,'path':path});return true
	return false
func attack(w:Dictionary,dt:float):
	if game.state!=game.State.COMBAT or not active():return
	w.clock-=dt
	if w.clock>0:return
	var d=game.weapon_data.bomb;var spec=Specs.definition(w)
	var target=game.nearest(game.player.position,float(d.reach)+10*(w.level-1))
	if target==null:return
	var direction:Vector2=(target.pos-game.player.position).normalized()
	w.clock=float(d.cooldown)/game.attack_mult/(1+.06*(w.level-1))
	var power=float(d.damage)*(1+(w.level-1)*.3)*game.damage_mult*game.gear_weapon_multiplier('bomb')
	var count=mini(5,1+game.multishot)
	game.combat_visuals.attack('bomb',direction,w.level)
	for i in range(count):
		var forecast:Vector2=target.pos
		if target.get('ravox_stage','') not in ['windup','recovery']:
			forecast+=(game.player.position-target.pos).normalized()*minf(float(target.speed)*float(d.flight)/game.projectile_speed,target.pos.distance_to(game.player.position)*.65)
		var at:Vector2=forecast+direction.orthogonal()*(i-(count-1)*.5)*65
		spawn(game.player.position,at,power,float(d.radius)+5*(w.level-1),float(d.flight)/game.projectile_speed,w.get('spec',''))
func activate():
	if not active() or game.state!=game.State.COMBAT:return
	var at:Vector2=game.player.position;var visited:Array=[]
	for i in range(3):
		var choice=null;var nearest=450.0 if i==0 else 260.0
		for e in game.enemies:
			if not visited.has(e) and e.pos.distance_to(at)<nearest:nearest=e.pos.distance_to(at);choice=e
		if choice!=null:visited.append(choice);at=choice.pos
		elif i==0:at=game.player.position+Vector2(game.facing,0)*170
		if queued.size()>=15:break
		queued.append({'delay':.22*i,'pos':at,'power':float(game.hero_ability.definition().damage)*game.damage_mult,'radius':125.0})
func explode(at:Vector2,power:float,radius:float,path:String=''):
	game.vfx.explosion(at,radius,Color('#FF9F1C'))
	if path=='bombard':
		for i in range(3):
			if queued.size()>=15:break
			queued.append({'delay':.32,'pos':(at+Vector2.from_angle(i*TAU/3)*85).clamp(Vector2(45,45),Vector2(2355,1555)),'power':power*.30,'radius':65.0})
	elif path=='fireball':
		if fields.size()>=4:fields.pop_front()
		fields.append({'pos':at,'radius':radius*.8,'life':3.0,'power':power*.35})
	for e in game.enemies.duplicate():
		if e.pos.distance_to(at)>radius+e.radius:continue
		game.damage_enemy(e,power)
		if game.state!=game.State.COMBAT:return
func update(dt:float):
	if game.state!=game.State.COMBAT or not active():return
	update_fields(dt)
	if game.state!=game.State.COMBAT:return
	for i in range(queued.size()-1,-1,-1):
		queued[i].delay-=dt
		if queued[i].delay>0:continue
		var event=queued[i].duplicate();queued.remove_at(i);explode(event.pos,event.power,event.radius)
		if game.state!=game.State.COMBAT:return
	for b in pool:
		if not b.active:continue
		b.age+=dt
		if b.age<b.flight:continue
		var shot=b.duplicate();b.active=false;explode(shot.target,shot.power,shot.radius,shot.path)
		if game.state!=game.State.COMBAT:return
func update_fields(dt:float):
	if game.state!=game.State.COMBAT or not active():return
	burn_clock+=dt
	for e in game.enemies.duplicate():
		var dose=0.0
		for field in fields:
			if e.pos.distance_to(field.pos)<=field.radius+e.radius:dose=maxf(dose,float(field.power)*minf(dt,field.life))
		if dose>0:e.burn_dose=float(e.get('burn_dose',0))+dose
	for i in range(fields.size()-1,-1,-1):
		fields[i].life-=dt
		if fields[i].life<=0:fields.remove_at(i);burn_clock=maxf(.25,burn_clock)
	if burn_clock<.25:return
	burn_clock=fmod(burn_clock,.25)
	for e in game.enemies.duplicate():
		var dose=float(e.get('burn_dose',0));e.burn_dose=0
		if dose>0:game.damage_enemy(e,dose)
		if game.state!=game.State.COMBAT:return
func draw_floor():
	for field in fields:
		game.draw_circle(field.pos,field.radius,Color(1,.25,.05,.22))
		game.draw_arc(field.pos,field.radius,0,TAU,32,Color('#FF9F1C'),3,true)
	for event in queued:game.draw_arc(event.pos,event.radius,0,TAU,32,Color(1,.65,.2,.6),2,true)
func draw():
	var art=preload('res://scripts/ui/combat_art.gd')
	for b in pool:
		if not b.active:continue
		var t=clampf(b.age/b.flight,0,1)
		var at:Vector2=b.origin.lerp(b.target,t)-Vector2(0,sin(t*PI)*100)
		game.draw_set_transform(at,t*TAU)
		game.draw_texture_rect_region(art.weapon_texture('bomb'),Rect2(-24,-24,48,48),art.weapon('bomb'))
		game.draw_set_transform(Vector2.ZERO)
