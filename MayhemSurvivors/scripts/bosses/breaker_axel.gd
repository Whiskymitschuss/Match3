extends RefCounted
# One deterministic controller, bounded floor hazards, no nodes or gameplay RNG per hit.
const ART=preload('res://assets/enemies/breaker_axel.png')
var game:Node2D
var data:Dictionary
var enabled=true
var stage='chase'
var attack='ring'
var clock=2.5
var tier=1
var pattern=0
var origin=Vector2.ZERO
var target=Vector2.ZERO
var direction=Vector2.RIGHT
var beats=0
var dash_hit=false
var combo=false
var rings:Array=[]
var cracks:Array=[]
var stagger_left=0.0
var slow_left=0.0
var push_velocity=Vector2.ZERO
func _init(g:Node2D):game=g;data=game.read_data('enemies/breaker_axel')
func scheduled() -> bool:return enabled and game.run_mode!='tutorial' and game.wave_number%10==(6 if game.united.enabled else 5)
func actor() -> Dictionary:
	for e in game.enemies:
		if e.kind=='breaker_axel' and e.hp>0:return e
	return {}
func clear():
	stage='chase';attack='ring';clock=(float(game.united.bosses.ladder.cadence.opening_delay) if game.united and game.united.enabled else 2.5);tier=1;pattern=0;beats=0;dash_hit=false;combo=false
	rings.clear();cracks.clear();stagger_left=0;slow_left=0;push_velocity=Vector2.ZERO
func tick_player(dt:float):
	stagger_left=maxf(0,stagger_left-dt);slow_left=maxf(0,slow_left-dt)
	push_velocity*=exp(-8*dt)
	if push_velocity.length_squared()<1:push_velocity=Vector2.ZERO
func control_factor() -> float:return 0.0 if stagger_left>0 else (.55 if slow_left>0 else 1.0)
func hit(amount:float,at:Vector2,force:float=220,stun:float=.22):
	var hp:float=game.hp
	game.hurt(amount)
	if game.state!=game.State.COMBAT or game.hp>=hp:return
	var dir:Vector2=at.direction_to(game.player.position)
	if dir==Vector2.ZERO:dir=Vector2.RIGHT
	push_velocity=(push_velocity+dir*force).limit_length(360)
	stagger_left=maxf(stagger_left,stun);slow_left=maxf(slow_left,.85)
func damage(base:float,e:Dictionary) -> float:
	return base*(e.damage/float(data.damage))*(1.2 if tier==3 else 1.0)
func begin_attack(id:String,e:Dictionary):
	attack=id;stage='windup';clock=float(data.windup);origin=e.pos
	direction=origin.direction_to(game.player.position)
	if direction==Vector2.ZERO:direction=Vector2.RIGHT
	target=(origin+direction*float(data.charge_distance)).clamp(Vector2(90,90),Vector2(2310,1510)) if id=='charge' else origin+direction*95
	dash_hit=false
	game.sound('axel_warning')
func recover():
	stage='recovery';clock=float(data.recovery)*([.9,.8,.7][tier-1] if game.united.enabled else (.7 if tier==3 else 1.0));game.boss_warning=''
func warning_text() -> String:
	if stage=='windup':return {'ring':'BODENSTOSS / DISTANZ SCHAFFEN','hammer':'PRESSLUFTHAMMER / MARKIERUNG VERLASSEN','charge':'ZOMBIE-ANSTURM / SEITLICH AUSWEICHEN'}[attack]+'  %.1f s' % maxf(0,clock)
	if stage=='hammer':return 'PRESSLUFTHAMMER-RASEREI / ABSTAND HALTEN'
	if stage=='dash':return 'ZOMBIE-ANSTURM'
	if stage=='phase':return 'WUTPHASE! / SCHNELLER, HÄRTER, MEHR DRUCK' if tier==3 else 'PHASE 2 / ANSTURM + BODENSTOSS'
	return 'RISSFLÄCHEN MEIDEN' if not cracks.is_empty() else 'DER BODEN GEHÖRT MIR!'
func update(dt:float):
	if game.state!=game.State.COMBAT or dt<=0:return
	var e=actor()
	if e.is_empty():return
	update_hazards(dt)
	if game.state!=game.State.COMBAT:return
	var next=3 if e.hp/e.max_hp<=float(data.phases[1]) else (2 if e.hp/e.max_hp<=float(data.phases[0]) else 1)
	if next>tier and (not game.united.enabled or stage not in ['windup','dash','hammer']):
		tier=next;stage='phase';clock=(float(game.united.bosses.ladder.cadence.phase_pause) if game.united.enabled else 1.1);combo=false;game.sound('axel_rage')
		game.encounters.warn('BREAKER AXEL / '+('WUTPHASE' if tier==3 else 'PHASE 2'));return
	if float(e.get('steel_stun',0))>0:return
	if stage in ['windup','dash','hammer'] and (not game.enemy_roles.visible(e.pos) or (stage=='windup' and e.pos.distance_to(origin)>6)):
		recover();combo=false;return
	clock=maxf(0,clock-dt)
	game.boss_warning=warning_text()
	if clock>0:return
	match stage:
		'chase','recovery','phase':
			if not game.enemy_roles.visible(e.pos):return
			if combo:combo=false;begin_attack('ring',e)
			else:begin_attack((game.united.bosses.ladder['6'].sequence if game.united.enabled else ['ring','hammer','charge'])[pattern%3],e);pattern+=1
		'windup':
			match attack:
				'ring':
					if rings.size()>=2:rings.pop_front()
					rings.append({'origin':origin,'radius':85.0,'max':float(data.ring_radius)+(60 if tier==3 else 0),'hit':false,'damage':damage(data.ring_damage,e)})
					game.sound('axel_slam');game.vfx.ground_impact(origin,100,Color('#FF9F1C'));recover()
				'hammer':stage='hammer';beats=5 if tier==3 else 3;hammer(e)
				'charge':stage='dash';clock=2.5;game.sound('axel_charge')
		'hammer':hammer(e)
		'dash':recover();combo=false
func hammer(e:Dictionary):
	game.sound('axel_drill');game.vfx.ground_impact(target,float(data.hammer_radius),Color('#FFB34C'))
	if game.player.position.distance_to(target)<=float(data.hammer_radius)+27:hit(damage(data.hammer_damage,e),target)
	if game.state!=game.State.COMBAT:return
	beats-=1;clock=float(data.hammer_interval)
	if beats<=0:
		add_crack(origin,origin+direction*340,damage(data.crack_damage,e));recover()
func add_crack(a:Vector2,b:Vector2,power:float):
	if cracks.size()>=6:cracks.pop_front()
	cracks.append({'a':a,'b':b.clamp(Vector2(50,50),Vector2(2350,1550)),'age':0.0,'warm':.9,'damage':power})
func velocity(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	if stage=='dash':return e.pos.direction_to(target)*minf(float(data.charge_speed)*(1.15 if tier==3 else 1.0),e.pos.distance_to(target)/maxf(.0001,dt))
	if stage in ['windup','hammer','phase']:return Vector2.ZERO
	return normal*(1.28 if tier==3 else 1.0)
func after_move(e:Dictionary,before:Vector2,after:Vector2):
	if game.state!=game.State.COMBAT or stage!='dash':return
	if not dash_hit and Geometry2D.get_closest_point_to_segment(game.player.position,before,after).distance_to(game.player.position)<=e.radius+27:
		dash_hit=true;hit(damage(data.charge_damage,e),before,320,.28)
		if game.state!=game.State.COMBAT:return
	if after.distance_to(target)<1:
		add_crack(origin,after,damage(data.crack_damage,e));recover();combo=tier>=2
		if combo:clock=.75
func update_hazards(dt:float):
	for i in range(rings.size()-1,-1,-1):
		var r=rings[i];var before:float=r.radius;r.radius=minf(r.max+65,r.radius+float(data.ring_speed)*dt)
		var distance:float=game.player.position.distance_to(r.origin)
		if not r.hit and distance>=before-float(data.ring_width)-27 and distance<=minf(r.max,r.radius)+float(data.ring_width)+27:
			r.hit=true;hit(r.damage,r.origin,240,.15)
			if game.state!=game.State.COMBAT:return
		if r.radius>=r.max+65:rings.remove_at(i)
	for i in range(cracks.size()-1,-1,-1):
		var c=cracks[i];var previous:float=c.age;c.age+=dt
		if c.age>=c.warm and previous<c.warm+float(data.crack_duration) and Geometry2D.get_closest_point_to_segment(game.player.position,c.a,c.b).distance_to(game.player.position)<=49:
			hit(c.damage,c.a,0,0)
			if game.state!=game.State.COMBAT:return
		if c.age>=c.warm+float(data.crack_duration):cracks.remove_at(i)
func draw_floor():
	for c in cracks:
		var hot=c.age>=c.warm;var color=Color('#FF653B') if hot else Color('#FFD166')
		game.draw_line(c.a,c.b,Color(color,.17),44,true)
		game.draw_line(c.a,c.b,color,3,true)
		var dir:Vector2=(c.b-c.a).normalized();var side=dir.orthogonal()
		for i in range(1,7):
			var at:Vector2=c.a.lerp(c.b,i/7.0)
			game.draw_line(at-side*13,at+side*15+dir*10,color,3,true)
	for r in rings:
		if r.radius<=r.max+float(data.ring_width):
			game.draw_arc(r.origin,minf(r.radius,r.max),0,TAU,64,Color('#FF713E'),float(data.ring_width)*2,true)
			game.draw_arc(r.origin,minf(r.radius,r.max),0,TAU,64,Color('#FFE8AF'),4,true)
	var e=actor()
	if e.is_empty():return
	if stage=='windup' and attack=='charge':
		var side:Vector2=origin.direction_to(target).orthogonal()*(e.radius+27)
		game.draw_colored_polygon(PackedVector2Array([origin+side,target+side,target-side,origin-side]),Color(1,.63,.1,.18))
		game.draw_line(origin+side,target+side,Color('#FFD166'),3,true);game.draw_line(origin-side,target-side,Color('#FFD166'),3,true)
		game.draw_arc(target,e.radius+27,0,TAU,48,Color('#FFD166'),3,true)
		for i in range(1,5):
			var at:Vector2=origin.lerp(target,i/5.0)
			game.draw_line(at-direction*16+direction.orthogonal()*15,at,Color('#FFE9A1'),4,true)
			game.draw_line(at-direction*16-direction.orthogonal()*15,at,Color('#FFE9A1'),4,true)
	elif stage=='windup' or stage=='hammer':
		var at:Vector2=origin if attack=='ring' else target
		var radius:float=float(data.ring_radius)+(60 if tier==3 else 0) if attack=='ring' else float(data.hammer_radius)
		game.draw_circle(at,radius,Color(1,.67,.15,.12));game.draw_arc(at,radius,0,TAU,64,Color('#FFD166'),4,true)
		if stage=='windup':game.draw_arc(at,radius+8,-PI*.5,-PI*.5+TAU*clampf(1-clock/float(data.windup),0,1),64,Color.WHITE,3,true)
func intro():
	game.backdrop('BREAKER AXEL',data.title+' / WELLE '+str(game.wave_number))
	game.UISkin.image(game,ART,Rect2(110,260,600,700))
	game.label_at('BASIS: 1500 HP / 15 % RESISTENZ',Vector2(135,970),25,game.GOLD)
	game.UISkin.panel(game,Rect2(760,285,1040,510),Color('#FF9F1C'))
	game.label_at('„'+data.quote+'“',Vector2(800,315),43,game.GOLD)
	game.label_at('PRESSLUFTHAMMER-RASEREI\nGelbe Kreisfläche verlassen. Mehrere Schläge!\n\nBODENSTOSS & ZOMBIE-ANSTURM\nSchockring ausweichen. Sturmspur seitlich verlassen.\n\nAB 40 % HP: WUTPHASE\nSchneller und stärker. Bodenrisse bleiben gefährlich.',Vector2(800,400),30)
	game.label_at('75 Sekunden / Sieg öffnet den Shop für Welle %d\nBewegung, Ausweichen und Heilung bleiben entscheidend.' % (game.wave_number+1),Vector2(800,815),27,game.TEAL)
	game.button('DER BODEN BEBT – LOS!',Vector2(800,930),Vector2(940,100),func():game.queue_ui_action(game.begin_wave),Color('#97502A'))
