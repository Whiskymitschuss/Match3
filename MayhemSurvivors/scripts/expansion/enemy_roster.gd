extends RefCounted
const R=preload('res://scripts/core/roster.gd')
var game:Node2D
var data:Dictionary
var counts={}
var hazards:Array=[]
var slow_time=0.0
func _init(g:Node2D):game=g;data=game.read_data('enemies/united_roster')
func clear():counts.clear();hazards.clear();slow_time=0
func count(id:String) -> int:
	var n=0
	for e in game.enemies:
		if e.kind==id and e.hp>0:n+=1
	return n
func allowed(id:String) -> bool:
	return game.united.enabled and game.run_mode!='tutorial' and not game.rules.boss_wave() and game.enemies.size()<100 and count(id)<int(data[id].cap) and int(counts.get(id,0))<int(data[id].cap)*3
func choose(normal:String,roll:float) -> String:
	if not game.united.enabled or roll<.76 or roll>=.95 or game.rules.boss_wave():return normal
	var index=(int((roll-.76)/.19*10)+int(game.arena_definition.get('rank',0)))%10;var id:String=R.NEW_ENEMIES[index]
	return id if ((game.wave_number-1)%10)+1>=int(data[id].first) and allowed(id) else normal
func initialize(e:Dictionary):
	if not data.has(e.kind):return
	counts[e.kind]=int(counts.get(e.kind,0))+1
	e.u_stage='chase';e.u_clock=2.0;e.u_origin=e.pos;e.u_target=e.pos;e.u_hit=false;e.u_spawned=0;e.u_face=e.pos.direction_to(game.player.position)
func interrupt(e:Dictionary):
	if data.has(e.kind) and e.get('u_stage','') in ['windup','dash']:e.u_stage='recovery';e.u_clock=1.5
func factor(e:Dictionary) -> float:
	if e.kind!='shieldbug':return 1.0
	return .65 if Vector2(e.get('u_face',Vector2.RIGHT)).dot(e.pos.direction_to(game.player.position))>.35 else 1.0
func warning_count() -> int:
	var total=hazards.size()
	for e in game.enemies:
		if data.has(e.kind) and e.get('u_stage','')=='windup':total+=1
	return total
func velocity(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	var config=data[e.kind];var role:String=config.role
	e.u_face=Vector2(e.u_face).lerp(normal.normalized(),minf(1,dt*2)).normalized()
	if role=='zigzag':return (normal.normalized()+normal.normalized().orthogonal()*sin(game.run_time*4+e.pos.x*.03)*.28).normalized()*e.speed
	if role in ['leech','shield']:return normal
	if e.u_stage=='dash':return e.pos.direction_to(e.u_target)*minf(490,e.pos.distance_to(e.u_target)/maxf(.0001,dt))
	if e.u_stage=='windup':
		if not game.enemy_roles.visible(e.pos) or e.pos.distance_to(e.u_origin)>8:interrupt(e);return Vector2.ZERO
		e.u_clock=maxf(0,e.u_clock-dt)
		if e.u_clock<=0:release(e)
		return Vector2.ZERO
	if e.u_stage=='recovery':
		e.u_clock=maxf(0,e.u_clock-dt)
		if e.u_clock<=0:e.u_stage='chase';e.u_clock=3.5
		return Vector2.ZERO
	if not game.enemy_roles.visible(e.pos):return normal
	e.u_clock=maxf(0,e.u_clock-dt)
	if e.u_clock<=0 and warning_count()<3 and e.pos.distance_to(game.player.position)<560:
		e.u_origin=e.pos;e.u_target=game.player.position;e.u_stage='windup';e.u_clock=1.3;e.u_hit=false
		if role=='dash':e.u_target=(e.pos+e.pos.direction_to(game.player.position)*420).clamp(Vector2(40,40),Vector2(2360,1560))
		if role=='blink':e.u_target=(game.player.position+Vector2.from_angle(e.pos.x*.03)*115).clamp(Vector2(45,45),Vector2(2355,1555))
		game.sound('united_warning');return Vector2.ZERO
	return normal*.4 if role in ['medic','mortar','summon'] and e.pos.distance_to(game.player.position)<300 else normal
func release(e:Dictionary):
	var role:String=data[e.kind].role;e.u_stage='recovery';e.u_clock=1.2
	match role:
		'dash':e.u_stage='dash'
		'blink':e.pos=e.u_target;circle(e.pos,82,.7,.3,e.damage,e,Color('#BD79FF'))
		'mortar':circle(e.u_target,100,1.4,.35,e.damage,e,Color('#FFAA55'))
		'frost':circle(e.u_origin,170,.55,.3,e.damage,e,Color('#89EDFF'),'slow')
		'burst':
			for i in range(8):game.shoot(e.pos,Vector2.from_angle(i*TAU/8),e.damage,true,230,3,'pyro')
			game.sound('united_pyro')
		'medic':
			var healed=0
			for other in game.enemies:
				if healed>=3:break
				if is_same(e,other) or R.BOSS_KINDS.has(other.kind) or other.get('elite','')!='' or e.pos.distance_to(other.pos)>220 or other.hp>=other.max_hp:continue
				var amount=minf(other.max_hp-other.hp,other.max_hp*.16);other.hp+=amount;healed+=1
				game.combat_visuals.beam(e.pos,other.pos);game.add_effect(other.pos,Color('#71ED9F'),25,'+%d' % ceili(amount))
		'summon':
			for side in [-1,1]:
				if e.u_spawned>=6 or game.enemies.size()>=100:break
				var at:Vector2=(e.pos+Vector2(side*90,120)).clamp(Vector2(45,45),Vector2(2355,1555))
				if at.distance_to(game.player.position)<160:at=(game.player.position+game.player.position.direction_to(e.pos)*220).clamp(Vector2(45,45),Vector2(2355,1555))
				game.spawn_enemy('grunt');game.enemies.back().pos=at;e.u_spawned+=1
func after_move(e:Dictionary,before:Vector2,after:Vector2):
	if e.get('u_stage','')!='dash':return
	if not e.u_hit and Geometry2D.get_closest_point_to_segment(game.player.position,before,after).distance_to(game.player.position)<e.radius+27:e.u_hit=true;game.hurt(e.damage)
	if game.state==game.State.COMBAT and after.distance_to(e.u_target)<1:e.u_stage='recovery';e.u_clock=1.2
func contact(e:Dictionary,before_hp:float):
	if e.kind=='leech' and game.hp<before_hp and game.enemies.has(e):e.hp=minf(e.max_hp,e.hp+(before_hp-game.hp)*.7)
func removed(e:Dictionary):
	if game.arena_mechanics:game.arena_mechanics.remove_owner(e)
	for i in range(hazards.size()-1,-1,-1):
		if is_same(hazards[i].get('owner'),e):hazards.remove_at(i)
func circle(at:Vector2,radius:float,warm:float,duration:float,damage:float,owner:Dictionary={},color:Color=Color('#FF9F45'),status:String=''):
	if hazards.size()>=12:return
	hazards.append({'shape':'circle','at':at,'radius':radius,'warm':warm,'duration':duration,'age':0.0,'damage':damage,'owner':owner,'color':color,'status':status})
func ring(at:Vector2,radius:float,angle:float,warm:float,damage:float,owner:Dictionary):
	if hazards.size()>=12:return
	hazards.append({'shape':'ring','at':at,'radius':radius,'angle':angle,'warm':warm,'duration':.4,'age':0.0,'damage':damage,'owner':owner,'color':Color('#C48AFF'),'status':''})
func lane(vertical:bool,position:float,warm:float,damage:float,owner:Dictionary={}):
	if hazards.size()>=12:return
	hazards.append({'shape':'lane','rect':Rect2(position-32,0,64,1600) if vertical else Rect2(0,position-32,2400,64),'warm':warm,'duration':.4,'age':0.0,'damage':damage,'owner':owner,'color':Color('#A4DDFF'),'status':''})
func contains(h:Dictionary,at:Vector2) -> bool:
	if h.shape=='lane':return h.rect.grow(27).has_point(at)
	if h.shape=='circle':return h.at.distance_to(at)<=h.radius+27
	var offset:Vector2=at-h.at
	return absf(offset.length()-h.radius)<=45 and absf(wrapf(offset.angle()-h.angle,-PI,PI))>=.9
func update(dt:float):
	if game.state!=game.State.COMBAT:return
	slow_time=maxf(0,slow_time-dt)
	for i in range(hazards.size()-1,-1,-1):
		var h=hazards[i];var before:float=h.age;h.age+=dt
		if h.age>=h.warm and before<h.warm+h.duration and contains(h,game.player.position):
			var hp:float=game.hp;game.hurt(h.damage)
			if game.state!=game.State.COMBAT:return
			if hp>game.hp and h.status=='slow':slow_time=1.5
		if before<h.warm and h.age>=h.warm:game.sound('united_impact')
		if h.age>=h.warm+h.duration:hazards.remove_at(i)
func draw():
	for h in hazards:
		var color=Color('#FF6370') if h.age>=h.warm else Color('#FFD166')
		if h.shape=='lane':game.draw_rect(h.rect,Color(color,.18));game.draw_rect(h.rect,color,false,3,true)
		elif h.shape=='circle':game.draw_circle(h.at,h.radius,Color(color,.14));game.draw_arc(h.at,h.radius,0,TAU,48,color,3,true)
		else:game.encounters.draw_ring(h.at,h.radius,18,h.angle,1.8,color,.23)
	for e in game.enemies:
		if not data.has(e.kind) or e.get('u_stage','')!='windup':continue
		game.draw_arc(e.pos,e.radius+12,0,TAU,24,Color('#FFD166'),3,true)
		if data[e.kind].role=='dash':
			var side:Vector2=e.u_origin.direction_to(e.u_target).orthogonal()*(e.radius+27)
			game.draw_colored_polygon(PackedVector2Array([e.u_origin+side,e.u_target+side,e.u_target-side,e.u_origin-side]),Color(1,.7,.2,.16));game.draw_line(e.u_origin+side,e.u_target+side,Color('#FFD166'),3,true);game.draw_line(e.u_origin-side,e.u_target-side,Color('#FFD166'),3,true)
		elif data[e.kind].role in ['blink','mortar']:game.draw_arc(e.u_target,85,0,TAU,40,Color('#FFD166'),3,true)
		elif data[e.kind].role=='frost':game.draw_arc(e.u_origin,170,0,TAU,40,Color('#89EDFF'),3,true)
