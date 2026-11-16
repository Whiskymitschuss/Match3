extends RefCounted
# All simulation is gated by COMBAT. Cosmetics never consume gameplay RNG.
const Specs=preload('res://scripts/weapons/specializations.gd')
var game:Node2D
var puddles:Array=[]
var sweeps:Array=[]
var tornado_left=0.0
var tornado_age=0.0
var tick_clock=0.0
const MAX_PUDDLES=5
func _init(g:Node2D):game=g
func active() -> bool:return game.characters[game.selected].id=='twinkle'
func clear():
	puddles.clear();sweeps.clear();tornado_left=0;tornado_age=0;tick_clock=0
func area_multiplier() -> float:
	return 1.0+float(game.characters[game.selected].get('area_bonus',0))
func attack(w:Dictionary,dt:float):
	if game.state!=game.State.COMBAT or not active():return
	w.clock-=dt
	if w.clock>0:return
	var d=game.weapon_data.mop;var spec=Specs.definition(w)
	var reach=(float(d.reach)+10*(int(w.level)-1))*float(spec.get('reach',1))
	var target=game.nearest(game.player.position,reach)
	if target==null:return
	w.clock=float(d.cooldown)/game.attack_mult/(1+.06*(int(w.level)-1))
	var origin:Vector2=game.player.position
	var direction:Vector2=(target.pos-origin).normalized()
	if direction==Vector2.ZERO:direction=Vector2(game.facing,0)
	var power=float(d.damage)*(1+(int(w.level)-1)*.3)*game.damage_mult*area_multiplier()
	game.combat_visuals.attack('mop',direction,int(w.level))
	if sweeps.size()>=6:sweeps.pop_front()
	sweeps.append({'origin':origin,'angle':direction.angle(),'reach':reach,'spray_to':target.pos,'spray_from':origin+Vector2(-19*game.character_facing(),-8),'life':.28})
	# Spray is part of the same attack, never another weapon or fake extra arm.
	var at:Vector2=target.pos
	if puddles.size()>=MAX_PUDDLES:puddles.pop_front()
	puddles.append({'pos':at,'radius':float(d.puddle_radius)+4*(int(w.level)-1),'life':float(d.puddle_duration)+float(spec.get('puddle_extra',0)),'power':float(d.poison_dps)*(1+(int(w.level)-1)*.3)*game.damage_mult*area_multiplier()*float(spec.get('poison',1))})
	for e in game.enemies.duplicate():
		var offset:Vector2=e.pos-origin
		if offset.length()>reach+e.radius or (offset!=Vector2.ZERO and direction.dot(offset.normalized())<0):continue
		apply_stun(e,float(spec.get('stun',d.stun)))
		game.damage_enemy(e,power)
		if game.state!=game.State.COMBAT:return
func apply_stun(e:Dictionary,duration:float):
	if e.kind=='boss' or float(e.get('suds_resist',0))>0:return
	e.suds_stun=duration;e.suds_resist=float(game.weapon_data.mop.stun_resistance)
	game.encounters.interrupt_elite(e)
func stunned(e:Dictionary,dt:float) -> bool:
	if not active():return false
	e.suds_resist=maxf(0,float(e.get('suds_resist',0))-dt)
	var was=float(e.get('suds_stun',0))>0
	e.suds_stun=maxf(0,float(e.get('suds_stun',0))-dt)
	return was and e.kind!='boss'
func on_kill():
	if not active() or game.state!=game.State.COMBAT or game.kills%20!=0 or game.hp<=0:return
	var before:float=game.hp
	game.hp=minf(game.max_hp,game.hp+2)
	if game.hp>before:
		game.add_effect(game.player.position,Color('#6FFFE6'),35,'+2 HP')
		game.sound('twinkle_heal')
func activate_tornado():
	if not active() or game.state!=game.State.COMBAT:return
	tornado_left=5;tornado_age=0
func update(dt:float):
	if game.state!=game.State.COMBAT or not active() or dt<=0:return
	for i in range(sweeps.size()-1,-1,-1):
		sweeps[i].life-=dt
		if sweeps[i].life<=0:sweeps.remove_at(i)
	var duration=minf(dt,tornado_left)
	var ending=tornado_left>0 and duration>=tornado_left
	if duration>0:
		tornado_left=maxf(0,tornado_left-duration);tornado_age+=duration
	var force_flush=ending
	for e in game.enemies.duplicate():
		var dose=0.0
		# Strongest overlapping field only. Separate spray puddles never multiply poison.
		for field in puddles:
			if e.pos.distance_to(field.pos)<=field.radius+e.radius:dose=maxf(dose,float(field.power)*minf(dt,field.life))
		if duration>0 and e.pos.distance_to(game.player.position)<=float(game.hero_ability.definition().radius)+e.radius:
			dose+=float(game.hero_ability.definition().damage)*game.damage_mult*area_multiplier()*duration
			if e.kind!='boss':
				game.encounters.interrupt_elite(e)
				var direction:Vector2=(e.pos-game.player.position).normalized()
				if direction==Vector2.ZERO:direction=Vector2.RIGHT
				e.pos=(e.pos+direction*float(game.hero_ability.definition().knockback)*duration).clamp(Vector2(35,35),Vector2(2365,1565))
		if dose>0:e.twinkle_dose=float(e.get('twinkle_dose',0))+dose
	for i in range(puddles.size()-1,-1,-1):
		puddles[i].life-=dt
		if puddles[i].life<=0:puddles.remove_at(i);force_flush=true
	tick_clock+=dt
	if tick_clock<.25 and not force_flush:return
	tick_clock=fmod(tick_clock,.25)
	for e in game.enemies.duplicate():
		var damage=float(e.get('twinkle_dose',0))
		e.twinkle_dose=0.0
		if damage<=0:continue
		game.damage_enemy(e,damage)
		if game.state!=game.State.COMBAT:return
func draw_floor():
	if not active():return
	for field in puddles:
		var alpha=clampf(field.life/.5,0,1)
		game.draw_circle(field.pos,field.radius,Color(.53,.1,.74,.27*alpha))
		game.draw_arc(field.pos,field.radius,0,TAU,40,Color(.87,.45,1,.65*alpha),3,true)
		var count=3 if game.saved.settings.quality=='LOW' else 7
		for i in range(count):
			var at:Vector2=field.pos+Vector2.from_angle(i*2.4+game.animation_clock*.2)*field.radius*(.25+.08*(i%5))
			game.draw_circle(at,5+i%3,Color(.75,.95,1,.23*alpha))
			game.draw_arc(at,5+i%3,PI,TAU,12,Color(.8,1,1,.6*alpha),1.4,true)
	for e in game.enemies:
		if float(e.get('suds_stun',0))<=0:continue
		var at:Vector2=e.pos-Vector2(0,e.radius+12)
		game.draw_arc(at,13,0,TAU,20,Color('#79FFEF'),2,true)
		for i in range(3):game.draw_circle(at+Vector2.from_angle(game.animation_clock*5+i*TAU/3)*14,3,Color('#FFD166'))
	for sweep in sweeps:
		var alpha:float=sweep.life/.28
		var bubble_count=3 if game.saved.settings.quality=='LOW' else 7
		for i in range(bubble_count):
			var progress=fmod((1-alpha)*2+i/float(bubble_count),1.0)
			var at:Vector2=sweep.spray_from.lerp(sweep.spray_to,progress)+Vector2(0,sin(i*2.4)*8*progress)
			game.draw_circle(at,3+progress*4,Color(.85,.6,1,alpha*.6))
		game.draw_arc(sweep.origin,sweep.reach,sweep.angle-PI*.5,sweep.angle+PI*.5,36,Color(.6,1,.96,alpha*.75),7*alpha+2,true)
	if tornado_left<=0:return
	var origin:Vector2=game.player.position
	var radius:float=game.hero_ability.definition().radius
	game.draw_circle(origin,radius,Color(.65,.3,.9,.08))
	var arcs=3 if game.saved.settings.quality=='LOW' else 6
	for i in range(arcs):
		var angle=tornado_age*7+i*TAU/arcs
		var r=radius*(.5+.5*float(i+1)/arcs)
		game.draw_arc(origin,r,angle,angle+PI*1.2,32,Color(.7,1,1,.35+.05*i),4,true)
		var at=origin+Vector2.from_angle(angle)*r
		game.draw_circle(at,9,Color(.8,1,1,.3))
		game.draw_arc(at,9,PI,TAU,12,Color('#CFFFF6'),2,true)

func draw_bottle(at:Vector2):
	game.draw_set_transform(at-Vector2(0,8),-.15*game.character_facing())
	game.draw_style_box(bottle_style(),Rect2(-8,0,16,25))
	game.draw_rect(Rect2(-4,-8,8,9),Color('#34213E'))
	game.draw_line(Vector2(-4,-9),Vector2(10,-9),Color('#FFD166'),5,true)
	game.draw_line(Vector2(10,-9),Vector2(10,-4),Color('#E879F9'),3,true)
	game.draw_line(Vector2(-4,6),Vector2(-4,18),Color('#E0FFFF'),2,true)
	game.draw_line(Vector2(-3,13),Vector2(3,13),Color.WHITE,2,true)
	game.draw_line(Vector2(0,10),Vector2(0,16),Color.WHITE,2,true)
	game.draw_set_transform(Vector2.ZERO)
var bottle_box:StyleBoxFlat
func bottle_style() -> StyleBoxFlat:
	if bottle_box==null:
		bottle_box=StyleBoxFlat.new();bottle_box.bg_color=Color('#B644D5');bottle_box.border_color=Color('#20152F');bottle_box.set_border_width_all(2);bottle_box.set_corner_radius_all(4)
	return bottle_box
