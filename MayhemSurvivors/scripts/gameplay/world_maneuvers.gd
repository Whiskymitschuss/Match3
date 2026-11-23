extends RefCounted
# Six optional arena tools. The same frozen geometry draws warnings and resolves hits.
const IDS=['gardens','frost','storm','crystal','carnival','void']
var owner_ref:WeakRef
var game_ref:WeakRef
var game:Node2D:
	get:return game_ref.get_ref()
var owner:
	get:return owner_ref.get_ref()
var data:Dictionary
var icons:Dictionary={}
var nodes:Array=[]
var hazards:Array=[]
var stage='idle'
var step=0
var held=0.0
var kills=0
var warmth_left=0.0
var warmth_at=Vector2.ZERO
func _init(g:Node2D,parent):
	game_ref=weakref(g);owner_ref=weakref(parent);data=game.read_data('arenas/tactics')
	for id in IDS:icons[id]=load('res://assets/environments/tool_'+id+'.svg')
func supported() -> bool:return owner.supported() and IDS.has(game.arena_id)
func live() -> bool:return supported() and game.state==game.State.COMBAT and not (game.tutorial and game.tutorial.active and game.tutorial.frozen())
func definition() -> Dictionary:return data[game.arena_id]
func clear():
	nodes.clear();hazards.clear();stage='idle';step=0;held=0;kills=0;warmth_left=0;warmth_at=Vector2.ZERO
func begin_wave():
	if not supported() or not owner.normal_wave():return
	stage='waiting'
	var center=(game.player.position+Vector2(-300 if game.player.position.x>1200 else 300,-140)).clamp(Vector2(500,400),Vector2(1900,1200))
	nodes=[center]
	if definition().mode=='relay':nodes=[center+Vector2(-150,0),center+Vector2(80,-150),center+Vector2(170,110)]
func protects_slow() -> bool:return supported() and game.arena_id=='frost' and warmth_left>0 and game.player.position.distance_to(warmth_at)<=float(data.frost.radius)
func update(dt:float):
	if not live():return
	warmth_left=maxf(0,warmth_left-dt)
	for h in hazards.duplicate():
		if not hazards.has(h):continue
		if not h.owner.is_empty() and (not game.enemies.has(h.owner) or not game.enemy_roles.visible(h.owner.pos) or (not h.resolved and h.owner.pos.distance_to(h.owner_start)>8)):
			hazards.erase(h);continue
		# Pull only into the announced annulus; bosses and elites resist this control.
		var pull_seconds=maxf(0,minf(float(h.warm),float(h.age)+dt)-maxf(float(h.age),float(h.warm)-1))
		if h.kind=='void' and h.owner.is_empty() and not h.resolved and pull_seconds>0:
			for e in game.enemies:
				if controlled(e) and e.pos.distance_to(h.at)>float(h.inner)+45 and e.pos.distance_to(h.at)<float(h.radius)+100:
					interrupt(e);e.pos=e.pos.move_toward(h.at,minf(pull_seconds*90,maxf(0,e.pos.distance_to(h.at)-float(h.inner)-45)))
		h.age+=dt
		if not h.resolved and h.age>=h.warm:
			h.resolved=true;resolve(h)
			if not live():return
		if hazards.has(h) and h.age>=h.warm+.8:hazards.erase(h)
	if not owner.normal_wave():return
	if stage=='windup' and (hazards.is_empty() or hazards.all(func(h):return h.resolved)):
		stage='complete';game.arena_events.active=false;game.run_events+=1;owner.maneuvers+=1
		if kills>=int(definition().bonus_kills):owner.award(game.arena_id)
		else:game.encounters.warn('MANÖVER BEENDET / %d VON %d KILLS / KEIN BONUS' % [kills,definition().bonus_kills])
	if stage in ['complete','expired','windup','idle']:return
	var d=definition()
	if game.remaining<6:stage='expired';held=0;return
	if stage=='waiting':
		if float(game.rules.current_wave().duration)-game.remaining<float(d.appear_after):return
		stage='ready';game.encounters.warn(d.name+' BEREIT / '+d.prompt);game.sound('arena_ready')
	if game.player.position.distance_to(nodes[step])>68:held=0;return
	if d.mode=='relay':
		step+=1;game.sound('core_collect')
		if step<nodes.size():return
	else:
		held=minf(float(d.hold),held+dt) if game.move_input.length_squared()<.04 else 0.0
		if held<float(d.hold):return
	activate()
func activate():
	if not live() or not owner.normal_wave() or stage!='ready':return
	stage='windup';held=0;game.arena_events.active=true
	spawn_pattern(nodes.back());game.sound('arena_arm');game.encounters.warn(definition().name+' / '+definition().command)
func add(shape:String,at:Vector2,warm:float,source:Dictionary={},extra:Dictionary={}) -> bool:
	if hazards.size()>=6:return false
	var d=definition();var h={'shape':shape,'kind':game.arena_id,'at':at,'warm':warm,'age':0.0,'resolved':false,'owner':source,'owner_start':source.get('pos',at),'radius':float(d.radius),'inner':float(d.get('inner',0)),'friendly':source.is_empty() and d.mode in ['purge','heat'],'damage':float(d.enemy_damage)+owner.wave_slot()*float(d.damage_per_wave),'player_damage':float(source.damage)*.7 if not source.is_empty() else float(d.player_damage)}
	h.merge(extra,true);hazards.append(h);return true
func beam(at:Vector2,direction:Vector2,warm:float,source:Dictionary={},outward:bool=false):
	var a=at+direction*(90 if outward else -300);var b=at+direction*(650 if outward else 300)
	add('beam',at,warm,source,{'a':a.clamp(Vector2(45,45),Vector2(2355,1555)),'b':b.clamp(Vector2(45,45),Vector2(2355,1555)),'width':float(definition().get('width',90))})
func spawn_pattern(at:Vector2,source:Dictionary={}) -> float:
	var d=definition();var boss=not source.is_empty();var warm=float(d.boss_warm if boss else d.warm)
	match game.arena_id:
		'gardens':
			if not boss:add('circle',at,warm)
			else:
				for offset in [Vector2.ZERO,Vector2(-210,120),Vector2(210,-120)]:add('circle',(at+offset).clamp(Vector2(120,120),Vector2(2280,1480)),warm,source,{'radius':100.0})
		'frost':add('ring' if boss else 'circle',at,warm,source,{'inner':95.0 if boss else 0.0})
		'storm':
			if boss:
				for direction in [Vector2.RIGHT,Vector2.DOWN]:beam(at,direction,warm,source)
			else:
				var target=game.nearest(at,900);var direction:Vector2=at.direction_to(target.pos) if target!=null else Vector2.RIGHT
				if direction.length_squared()<.1:direction=Vector2.RIGHT
				beam(at,direction,warm,{},true)
		'crystal':
			for angle in [-PI/4,PI/4]:beam(at,Vector2.from_angle(angle),warm,source)
		'carnival':
			for i in range(3):
				var offset:Vector2=[Vector2.ZERO,Vector2(-185,110),Vector2(185,110)][i]
				add('circle',(at+offset).clamp(Vector2(120,120),Vector2(2280,1480)),warm+i*.6,source)
			warm+=1.2
		'void':add('ring',at,warm,source)
	return warm
func boss_zones(source:Dictionary,at:Vector2) -> float:
	if not supported():return 0.0
	return spawn_pattern(at,source)
func contains(h:Dictionary,at:Vector2,radius:float) -> bool:
	if h.shape=='beam':return Geometry2D.get_closest_point_to_segment(at,h.a,h.b).distance_to(at)<=float(h.width)*.5+radius
	var distance=at.distance_to(h.at)
	return distance<=float(h.radius)+radius and (h.shape!='ring' or distance>=float(h.inner)-radius)
func controlled(e:Dictionary) -> bool:return e.kind not in game.united.R.BOSS_KINDS and not e.has('elite')
func interrupt(e:Dictionary):
	game.united.enemies.interrupt(e);game.ravox.interrupt(e);game.enemy_pack.interrupt(e);game.encounters.interrupt_elite(e)
func purge(at:Vector2,radius:float):
	for h in game.united.enemies.hazards.duplicate():
		if h.shape=='circle' and h.at.distance_to(at)<=radius and h.owner.get('kind','') not in game.united.R.BOSS_KINDS:game.united.enemies.hazards.erase(h)
func resolve(h:Dictionary):
	game.sound('arena_pulse');game.vfx.burst(h.at,Color(definition().color),game.vfx.limits().burst,'spark',160)
	if not h.friendly and contains(h,game.player.position,27):
		var before=game.hp;game.hurt(h.player_damage)
		if not live():return
		if h.kind=='frost' and game.hp<before:game.united.enemies.slow_time=maxf(game.united.enemies.slow_time,1.0)
	if h.owner.is_empty() and h.kind=='gardens':purge(h.at,h.radius)
	if h.owner.is_empty() and h.kind=='frost':warmth_at=h.at;warmth_left=4.0
	for e in game.enemies.duplicate():
		if not contains(h,e.pos,e.radius):continue
		var amount=float(h.damage)
		if e.kind in game.united.R.BOSS_KINDS:amount=minf(amount,float(e.max_hp)*float(owner.data.limits.boss_fraction_cap))
		game.damage_enemy(e,amount,'arena')
		if not live():return
		if e.hp<=0:
			if h.owner.is_empty():kills+=1
		elif controlled(e) and h.owner.is_empty():
			interrupt(e)
			if h.kind=='storm':e.steel_stun=1.0
			if h.kind=='frost':e.ability_slow=.5;e.ability_slow_time=2.0
func remove_owner(source:Dictionary):
	for h in hazards.duplicate():
		if not h.owner.is_empty() and is_same(h.owner,source):hazards.erase(h)
func status() -> String:
	if not owner.normal_wave():return ''
	var d=definition()
	if warmth_left>0:return 'WÄRMEFELD %.1f s\nIM KREIS GEGEN FROST GESCHÜTZT' % warmth_left
	if stage=='waiting':return d.name+'\nAB 10 s VERFÜGBAR'
	if stage=='expired':return d.name+'\nZEITFENSTER BEENDET'
	if stage=='complete':return d.name+'\nMANÖVER ABGESCHLOSSEN'
	if stage=='windup':return d.name+'\n'+d.command
	if d.mode=='relay':return '%s %d / %d\nNÄCHSTE LEUCHTENDE RUNE BERÜHREN' % [d.name,step,nodes.size()]
	return d.name+'\n1 s ANHALTEN / %d KILLS → +%d RUN-COINS' % [d.bonus_kills,owner.bonus(game.arena_id)]
func draw_text(at:Vector2,value:String,color:Color,font:int=22):
	var width=game.UISkin.HEADING.get_string_size(value,HORIZONTAL_ALIGNMENT_LEFT,-1,font).x
	game.draw_rect(Rect2(at-Vector2(width*.5+7,24),Vector2(width+14,32)),Color('#111324'))
	game.draw_string(game.UISkin.HEADING,at-Vector2(width*.5,0),value,HORIZONTAL_ALIGNMENT_LEFT,-1,font,color)
func draw():
	if not supported():return
	var color=Color(definition().color)
	if owner.normal_wave() and stage in ['ready','waiting']:
		for i in range(nodes.size()):
			var at:Vector2=nodes[i];var active=stage=='ready' and i==step
			var tint=Color.WHITE if active else Color(.5,.5,.6,.65)
			game.draw_circle(at,68,Color(color,.09 if active else .04));game.draw_arc(at,68,0,TAU,32,color if active else Color(color,.3),3,true)
			game.draw_texture_rect(icons[game.arena_id],Rect2(at-Vector2(32,40),Vector2(64,64)),false,tint)
			if active:
				if definition().mode=='relay':draw_text(at+Vector2(0,97),'RUNE %d / 3' % (i+1),color)
				else:draw_text(at+Vector2(0,97),'ANHALTEN %.1f s' % definition().hold,color)
			if held>0 and active:game.draw_arc(at,76,-PI/2,-PI/2+TAU*held/float(definition().hold),32,Color.WHITE,5,true)
	if warmth_left>0:
		game.draw_circle(warmth_at,float(data.frost.radius),Color(1,.6,.25,.10));game.draw_arc(warmth_at,float(data.frost.radius),0,TAU,48,Color('#FFBF69'),3,true)
	for h in hazards:
		var tint=game.TEAL if h.friendly else (Color('#FF6370') if h.resolved else game.GOLD)
		if h.shape=='beam':
			var side:Vector2=Vector2(h.a).direction_to(h.b).orthogonal()*float(h.width)*.5
			var polygon=PackedVector2Array([h.a+side,h.b+side,h.b-side,h.a-side])
			game.draw_colored_polygon(polygon,Color(tint,.30 if h.resolved else .13));game.draw_polyline(PackedVector2Array([h.a+side,h.b+side,h.b-side,h.a-side,h.a+side]),tint,3,true)
			for end in [h.a,h.b]:game.draw_arc(end,float(h.width)*.5,0,TAU,24,tint,3,true)
		else:
			if h.shape=='ring':
				game.draw_arc(h.at,(float(h.radius)+float(h.inner))*.5,0,TAU,64,Color(tint,.15),float(h.radius)-float(h.inner),true)
				game.draw_arc(h.at,h.inner,0,TAU,40,game.TEAL,4,true);draw_text(h.at+Vector2(0,8),'INNEN SICHER',game.TEAL,19)
			else:game.draw_circle(h.at,h.radius,Color(tint,.25 if h.resolved else .1))
			game.draw_arc(h.at,h.radius,0,TAU,48,tint,4,true)
		var value='IMPULS' if h.resolved else ('HILFE %.1f s' if h.friendly else 'GEFAHR %.1f s') % maxf(0,float(h.warm)-float(h.age))
		draw_text(h.at+Vector2(0,-(float(h.radius) if h.shape!='beam' else 85)-20),value,tint)
