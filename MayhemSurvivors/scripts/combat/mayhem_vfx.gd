extends RefCounted
# Cosmetic-only, capped reused particle slots. Never reads or writes gameplay RNG.
const SPLAT=preload('res://assets/effects/cartoon_splat.svg')
const PROFILES={'LOW':{'particles':80,'stains':18,'events':8,'burst':2},'MEDIUM':{'particles':150,'stains':40,'events':16,'burst':4},'HIGH':{'particles':240,'stains':70,'events':24,'burst':6}}
const COLORS={'grunt':Color('#91E65A'),'runner':Color('#FF547A'),'tank':Color('#B575FF'),'boss':Color('#B575FF'),'spitter':Color('#FF7040'),'drone':Color('#00D9D0')}
var game:Node2D
var visual_rng=RandomNumberGenerator.new()
var particles:Array=[]
var stains:Array=[]
var events:Array=[]
var hit_clock=0.0
var sound_clock=0.0
var last_splatter=true
func _init(g:Node2D):
	game=g
	visual_rng.seed=524651
func limits() -> Dictionary:return PROFILES.get(game.saved.settings.quality,PROFILES.LOW)
func clear():
	for p in particles:p.active=false
	stains.clear()
	events.clear()
	hit_clock=0
	sound_clock=0
	last_splatter=true
	visual_rng.seed=524651
func apply_settings():
	var cap=limits()
	if particles.size()>cap.particles:particles.resize(cap.particles)
	while stains.size()>cap.stains:stains.pop_front()
	while events.size()>cap.events:events.pop_front()
	var splatter:bool=game.saved.settings.get('splatter',true)
	if not splatter and last_splatter:
		stains=stains.filter(func(s):return not s.blood)
		for p in particles:
			if p.active and p.get('blood',false):p.active=false
	last_splatter=splatter
func update(dt:float):
	apply_settings()
	hit_clock=maxf(0,hit_clock-dt)
	sound_clock=maxf(0,sound_clock-dt)
	for p in particles:
		if not p.active:continue
		p.life-=dt
		if p.life<=0:p.active=false;continue
		p.pos+=p.vel*dt
		p.vel*=maxf(0,1-dt*float(p.drag))
		p.height=maxf(0,p.height+p.lift*dt)
		p.lift-=380*dt
	for collection in [stains,events]:
		for i in range(collection.size()-1,-1,-1):
			collection[i].life-=dt
			if collection[i].life<=0:collection.remove_at(i)
func particle(pos:Vector2,velocity:Vector2,color:Color,kind:String='spark',size:float=4,blood:bool=false):
	if blood and not game.saved.settings.get('splatter',true):return
	var item=null
	for p in particles:
		if not p.active:item=p;break
	if item==null:
		if particles.size()>=limits().particles:return
		item={}
		particles.append(item)
	var life=visual_rng.randf_range(.22,.5) if kind!='smoke' else .6
	item.merge({'active':true,'pos':pos,'vel':velocity,'color':color,'kind':kind,'size':size,'life':life,'full':life,'height':visual_rng.randf_range(3,16),'lift':visual_rng.randf_range(30,110),'drag':2.0,'blood':blood},true)
func burst(pos:Vector2,color:Color,count:int,kind:String='spark',speed:float=150,blood:bool=false):
	for i in range(count):
		var dir=Vector2.from_angle(visual_rng.randf()*TAU)
		particle(pos,dir*visual_rng.randf_range(speed*.4,speed),color,kind,visual_rng.randf_range(3,7),blood)
func event(kind:String,pos:Vector2,color:Color,radius:float=60,direction:Vector2=Vector2.RIGHT,life:float=.3):
	while events.size()>=limits().events:events.pop_front()
	events.append({'kind':kind,'pos':pos,'color':color,'radius':radius,'direction':direction,'life':life,'full':life,'phase':visual_rng.randf()*TAU})
func stain(pos:Vector2,color:Color,radius:float,blood:bool=true):
	if blood and not game.saved.settings.get('splatter',true):return
	while stains.size()>=limits().stains:stains.pop_front()
	stains.append({'pos':pos,'color':color,'radius':radius,'angle':visual_rng.randf()*TAU,'life':7.0,'blood':blood})
func enemy_hit(enemy:Dictionary,critical:bool):
	if hit_clock>0 and not critical:return
	hit_clock=.035
	var mechanical=enemy.kind=='drone' or (enemy.kind=='boss' and game.is_reactor())
	var color=Color('#FFD166') if mechanical else COLORS.get(enemy.kind,Color('#B575FF'))
	if mechanical:burst(enemy.pos,color,limits().burst,'spark',170)
	elif game.saved.settings.get('splatter',true):
		burst(enemy.pos,color,limits().burst,'drop',120,true)
		if critical:stain(enemy.pos,color,enemy.radius*.8)
	if critical:event('critical',enemy.pos,Color('#FFD166'),42,Vector2.RIGHT,.23)
func coin(pos:Vector2,amount:int):
	event('coin',pos,Color('#FFD166'),10,Vector2.RIGHT,.65)
	events.back().amount=amount
func enemy_died(enemy:Dictionary):
	var mechanical=enemy.kind=='drone' or (enemy.kind=='boss' and game.is_reactor())
	var color=Color('#FFD166') if mechanical else COLORS.get(enemy.kind,Color('#B575FF'))
	if mechanical:
		explosion(enemy.pos,enemy.radius*1.5,color)
		return
	stain(enemy.pos,color,enemy.radius*1.65)
	if game.saved.settings.get('splatter',true):burst(enemy.pos,color,limits().burst*2,'drop',220,true)
	burst(enemy.pos,Color('#D4CEE6'),limits().burst,'smoke',65)
	event('poof',enemy.pos,color,enemy.radius*1.8,Vector2.RIGHT,.35)
	if sound_clock<=0 and game.saved.settings.get('splatter',true):game.sound('fx_splat');sound_clock=.09
func shot(weapon:String,direction:Vector2):
	var color=preload('res://scripts/ui/weapon_skins.gd').color(game.run_loadout,Color('#FFB347') if weapon=='splitgun' else game.combat_visuals.Art.color_for(game.selected))
	var origin=game.player.position+direction*62+Vector2(0,-9)
	if weapon in ['blaster','splitgun']:
		if weapon==game.combat_visuals.primary_id():event('muzzle',origin,color,40 if weapon=='splitgun' else 30,direction,.10)
		burst(origin,color,limits().burst,'spark',180)
		particle(origin,-direction*30,Color('#9AA6BA'),'smoke',6)
	elif weapon=='hammer':
		event('sweep',game.player.position,Color('#FFB347'),105,direction,.24)
		ground_impact(game.player.position+direction*70,95,Color('#FFB347'))
	elif weapon=='arc':event('charge',origin,Color('#45F7FF'),32,direction,.2)
	elif weapon=='flamer':event('sweep',game.player.position,Color('#FF9F45'),180,direction,.22);burst(origin,Color('#FFB553'),limits().burst,'wisp',140)
	elif weapon=='cryo':event('charge',origin,Color('#98EDFF'),30,direction,.18);burst(origin,Color('#C9F8FF'),limits().burst,'spark',140)
	elif weapon=='tesla':event('electric',origin,Color('#7CFFE5'),42,direction,.24)
	elif weapon=='lance':event('sweep',game.player.position,Color('#FFD166'),170,direction,.24)
	elif weapon=='chakram':event('slash',origin,Color('#E875EA'),45,direction,.24)
func impact(pos:Vector2,weapon:String,hostile:bool=false):
	var color=Color('#FF7040') if hostile else (Color('#A55EEA') if weapon=='orbit' else Color('#FFD166'))
	burst(pos,color,limits().burst,'spark',180)
	if weapon=='orbit':event('slash',pos,color,45,Vector2.from_angle(game.orbit_angle),.18)
func ground_impact(pos:Vector2,radius:float,color:Color):
	event('crack',pos,color,radius,Vector2.RIGHT,.5)
	burst(pos,Color('#B7A8A0'),limits().burst,'smoke',80)
func explosion(pos:Vector2,radius:float,color:Color):
	if sound_clock<=0:game.sound('fx_boom');sound_clock=.09
	event('explosion',pos,color,radius,Vector2.RIGHT,.38)
	burst(pos,color,limits().burst*2,'spark',230)
	burst(pos,Color('#7F879B'),limits().burst,'smoke',100)
	stain(pos,Color('#252B3E'),radius*.8,false)
func ability(kind:String,pos:Vector2):
	match kind:
		'shockwave':ground_impact(pos,245,Color('#FF9F1C'))
		'impulse':event('charge',pos,Color('#00D9D0'),40,Vector2.RIGHT,.25)
		'firestorm':explosion(pos,220,Color('#FF9F45'))
		'absolute_zero':ground_impact(pos,280,Color('#98EDFF'));burst(pos,Color('#C9F8FF'),limits().burst*2,'spark',230)
		'overcharge':event('electric',pos,Color('#7CFFE5'),130,Vector2.RIGHT,.45)
		'bastion':event('charge',pos,Color('#8BAEFF'),100,Vector2.RIGHT,.4)
		'phase_dance':burst(pos,Color('#E875EA'),limits().burst*2,'wisp',120)
		'shadow_step':burst(pos,Color('#A55EEA'),limits().burst*2,'wisp',100)
func beam(origin:Vector2,target:Vector2):
	burst(target,Color('#72F7FF'),limits().burst,'spark',130)
	var mid=origin.lerp(target,.65)
	event('electric',mid,Color('#00D9D0'),minf(70,origin.distance_to(target)*.3),(target-origin).normalized(),.2)
func draw_floor():
	for s in stains:
		var alpha=minf(.48,s.life/1.5*.48)
		game.draw_set_transform(s.pos,s.angle,Vector2(1,.65))
		game.draw_texture_rect(SPLAT,Rect2(Vector2(-s.radius,-s.radius*.75),Vector2(s.radius*2,s.radius*1.5)),false,Color(s.color,alpha))
		game.draw_set_transform(Vector2.ZERO)
	for e in events:
		if e.kind!='crack':continue
		var alpha=minf(1,e.life*5)
		for i in range(7):
			var dir=Vector2.from_angle(i*TAU/7+e.phase)
			var normal=dir.orthogonal()
			var points=PackedVector2Array([e.pos+dir*12,e.pos+dir*e.radius*.45+normal*8,e.pos+dir*e.radius*.7-normal*5,e.pos+dir*e.radius])
			game.draw_polyline(points,Color(.08,.1,.16,alpha*.7),5,true)
			game.draw_polyline(points,Color(e.color,alpha*.7),2,true)
func draw_particles():
	for p in particles:
		if not p.active:continue
		var alpha:float=clampf(p.life/p.full*1.6,0,1)
		var at:Vector2=p.pos-Vector2(0,p.height)
		var color=Color(p.color,alpha)
		match p.kind:
			'drop':
				game.draw_circle(at,p.size+1.5,Color(.08,.1,.16,alpha*.65))
				game.draw_circle(at,p.size,color)
				game.draw_circle(at-Vector2(1,2),p.size*.3,Color(1,1,1,alpha*.6))
			'smoke':game.draw_circle(at,p.size*(2-p.life/p.full),Color(p.color,alpha*.18))
			'wisp':game.draw_arc(at,p.size*2,0,PI,10,color,3,true)
			_:
				var dir:Vector2=p.vel.normalized()
				game.draw_line(at-dir*8,at+dir*3,color,p.size*.6,true)
				game.draw_line(at-dir*2,at+dir*3,Color(1,1,.85,alpha),1.5,true)
func draw_front():
	for e in events:
		if e.kind=='crack':continue
		var t:float=1-e.life/e.full
		var alpha:float=1-t
		var color=Color(e.color,alpha)
		match e.kind:
			'muzzle':
				var dir:Vector2=e.direction
				var side=dir.orthogonal()
				var r:float=e.radius*(1-t*.5)
				game.draw_circle(e.pos,r*.8,Color(e.color,alpha*.08))
				game.draw_colored_polygon(PackedVector2Array([e.pos-dir*6,e.pos+dir*10+side*r*.4,e.pos+dir*r,e.pos+dir*10-side*r*.4]),color)
				game.draw_line(e.pos,e.pos+dir*r*.7,Color(1,1,.9,alpha),7,true)
			'explosion':
				var radius:float=e.radius*(.25+.75*t)
				for i in range(6):
					var at:Vector2=e.pos+Vector2.from_angle(i*TAU/6+e.phase)*radius*.55
					game.draw_circle(at,radius*.4,Color(e.color,alpha*.25))
				game.draw_arc(e.pos,radius,0,TAU,40,color,5*alpha+1,true)
				if t<.3:game.draw_circle(e.pos,radius*.35,Color(1,1,.85,alpha*.7))
			'poof':
				for i in range(5):
					var dir=Vector2.from_angle(i*TAU/5+e.phase)
					var at:Vector2=e.pos+dir*e.radius*(.3+.6*t)
					game.draw_circle(at,e.radius*.18,Color(e.color,alpha*.32))
					game.draw_line(at-dir*5,at+dir*5,Color(e.color,alpha*.75),3,true)
			'coin':
				var at:Vector2=e.pos-Vector2(0,16+sin(t*PI*.6)*35)
				game.draw_circle(at,8,Color(.08,.1,.16,alpha))
				game.draw_circle(at,6,Color(1,.82,.4,alpha))
				game.draw_line(at+Vector2(-2,-3),at+Vector2(2,-3),Color(1,1,.8,alpha),2,true)
				game.draw_string_outline(ThemeDB.fallback_font,at+Vector2(11,6),'+'+str(e.amount),HORIZONTAL_ALIGNMENT_LEFT,-1,19,3,Color(.06,.08,.14,alpha))
				game.draw_string(ThemeDB.fallback_font,at+Vector2(11,6),'+'+str(e.amount),HORIZONTAL_ALIGNMENT_LEFT,-1,19,color)
			'critical':
				for i in range(4):
					var dir=Vector2.from_angle(i*TAU/4+.4)
					game.draw_line(e.pos+dir*12,e.pos+dir*e.radius*(.6+.3*t),color,3*alpha+1,true)
				game.draw_circle(e.pos,4*alpha,Color(1,1,.85,alpha))
			'sweep','slash':
				var angle:float=e.direction.angle()
				game.draw_arc(e.pos,e.radius*(.6+.4*t),angle-1.2+t,angle+.8+t,24,Color(e.color,alpha*.3),13,true)
				game.draw_arc(e.pos,e.radius*(.6+.4*t),angle-1+t,angle+.6+t,24,color,4,true)
			'electric':
				var dir:Vector2=e.direction.orthogonal()
				for sign in [-1,1]:
					var points=PackedVector2Array([e.pos,e.pos+dir*e.radius*.4*sign+e.direction*12,e.pos+dir*e.radius*.6*sign-e.direction*9,e.pos+dir*e.radius*sign])
					game.draw_polyline(points,Color(e.color,alpha*.3),8,true)
					game.draw_polyline(points,color,2,true)
			_:
				game.draw_arc(e.pos,e.radius*(.4+.6*t),0,TAU,24,color,3,true)
