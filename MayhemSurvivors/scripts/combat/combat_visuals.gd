extends RefCounted
# Cosmetic state only: no damage, collision, cooldown or gameplay RNG access.
const Specs=preload('res://scripts/weapons/specializations.gd')
const Art = preload('res://scripts/ui/combat_art.gd')
const HeroArt = preload('res://scripts/ui/character_art.gd')
var game: Node2D
var rigs: Dictionary = {}
var fx: Array = []
var aim_clock = 0.0
var target_direction = Vector2.RIGHT
var shell_counter = 0
var impact_sound_clock = 0.0
func _init(owner_game: Node2D): game=owner_game
func clear():
	rigs.clear()
	fx.clear()
	aim_clock=0
	target_direction=Vector2.RIGHT
	impact_sound_clock=0
func rig(id: String) -> Dictionary:
	if not rigs.has(id): rigs[id]={'angle':target_direction.angle(),'pulse':0.0,'swing':0.0}
	return rigs[id]
func update(dt: float):
	impact_sound_clock=maxf(0,impact_sound_clock-dt)
	aim_clock-=dt
	if aim_clock<=0:
		aim_clock=.08
		var target=game.nearest(game.player.position,520)
		if target!=null: target_direction=(target.pos-game.player.position).normalized()
		elif game.move_input.length_squared()>.01: target_direction=game.move_input.normalized()
	for id in rigs:
		var r=rigs[id]
		r.pulse=maxf(0,r.pulse-dt)
		r.swing=maxf(0,r.swing-dt)
		if r.swing<=0: r.angle=lerp_angle(r.angle,target_direction.angle(),minf(1,dt*16))
	for i in range(fx.size()-1,-1,-1):
		fx[i].life-=dt
		if fx[i].life<=0: fx.remove_at(i)
func limit() -> int:
	return 24 if game.saved.settings.quality=='LOW' else (48 if game.saved.settings.quality=='MEDIUM' else 72)
func push(effect: Dictionary):
	if fx.size()<limit(): fx.append(effect)
func attack(id: String, direction: Vector2, _level: int):
	var r=rig(id)
	game.sound({'blaster':'blaster_fire','splitgun':'splitgun_fire','hammer':'hammer_slam','arc':'arc_zap','mop':'mop_swish','bomb':'bomb_throw','tools':'steel_swing','flamer':'united_flame','cryo':'united_cryo','tesla':'united_tesla','lance':'united_lance','chakram':'united_chakram'}.get(id,'shot'))
	r.angle=direction.angle()
	r.pulse=.115
	game.vfx.shot(id,direction)
	if id=='tools':r.swing=.32
	if id in ['hammer','mop','lance']:
		r.swing=.26
		push({'kind':'slam','pos':game.player.position+direction*70,'life':.28,'full':.28,'skin':game.selected})
	elif id in ['blaster','splitgun']:
		shell_counter+=1
		push({'kind':'shell','pos':game.player.position+Vector2(0,-8),'dir':direction.orthogonal()*(-1 if shell_counter%2 else 1),'life':.3,'full':.3,'skin':game.selected})
func impact(pos: Vector2, weapon: String, hostile: bool = false):
	game.vfx.impact(pos,weapon,hostile)
	if weapon=='orbit' and impact_sound_clock<=0:
		game.sound('blade_hit')
		impact_sound_clock=.12
	push({'kind':'impact','pos':pos,'life':.19,'full':.19,'skin':game.selected,'weapon':weapon,'hostile':hostile})
func beam(origin: Vector2, target: Vector2):
	game.vfx.beam(origin,target)
	push({'kind':'beam','pos':origin,'end':target,'life':.22,'full':.22,'skin':game.selected})
func primary_id() -> String:
	for w in game.weapons:
		if w.id!='orbit': return w.id
	return ''

func held_pose() -> Dictionary:
	var id=primary_id()
	if id=='': return {}
	var r=rig(id)
	var direction=Vector2.from_angle(r.angle)
	var mirror=-1.0 if direction.x<0 else 1.0
	var angle=r.angle
	var center=game.player.position+Vector2(0,-9)+direction*14-direction*(r.pulse/.115)*5
	var rect=Rect2(-32,-29,82,70)
	var grips=[Vector2(-18,18),Vector2(12,4)]
	if id in ['hammer','mop','lance']:
		var progress=1.0-r.swing/.26
		angle+=sin(progress*PI)*.8 if r.swing>0 else -.3
		center=game.player.position+Vector2(0,-8)+direction*5
		rect=Rect2(-14,-43,110,84)
		grips=[Vector2(5,0),Vector2(27,0)]
	if id in ['bomb','chakram']:
		rect=Rect2(-25,-25,50,50);grips=[Vector2(-10,5),Vector2(10,5)]
	if id=='mop' and game.twinkle.tornado_left>0:
		angle=game.twinkle.tornado_age*TAU*2
		mirror=-1.0 if cos(angle)<0 else 1.0
		center=game.player.position+Vector2(0,-8)+Vector2.from_angle(angle)*10
	var hands: Array[Vector2]=[]
	if id=='tools':
		var face=game.character_facing();var strength=sin((1-r.swing/.32)*PI) if r.swing>0 else 0.0
		for i in range(2):
			var offset=direction*strength*27 if r.get('double_hit',false) or int(r.get('hand',0))==i else Vector2.ZERO
			hands.append(game.player.position+Vector2((-23 if i==0 else 23)*face,0)+offset)
		return {'id':id,'center':game.player.position,'angle':angle,'mirror':mirror,'rect':rect,'hands':hands,'pulse':r.pulse}
	for point in grips: hands.append(center+Vector2(point.x,point.y*mirror).rotated(angle))
	if id=='mop':hands[1]=game.player.position+Vector2(-19*game.character_facing(),1)
	return {'id':id,'center':center,'angle':angle,'mirror':mirror,'rect':rect,'hands':hands,'pulse':r.pulse}

func hand_positions() -> Array:
	var pose=held_pose()
	if not pose.is_empty(): return pose.hands
	# An orbit weapon never acquires fake hands; the hero keeps two neutral arms.
	var face=game.character_facing()
	return [game.player.position+Vector2(-19*face,5),game.player.position+Vector2(19*face,4)]

func shoulder_positions() -> Array:
	var face=game.character_facing();var result=[]
	var stride=sin(game.animation_clock*12) if game.state==game.State.COMBAT and game.move_input.length_squared()>.01 else 0.0
	for point in HeroArt.shoulders(game.characters[game.selected].id):
		var at:Vector2=Vector2(-48,-64-absf(stride)*3)+Vector2(point)*(96.0/360)
		at.x*=face;result.append(game.player.position+at.rotated(stride*.035))
	return result

func elbows(hands: Array) -> Array:
	var shoulders=shoulder_positions()
	var face=game.character_facing()
	var result: Array[Vector2]=[]
	for i in range(2):
		var offset: Vector2=hands[i]-shoulders[i]
		var middle: Vector2=(hands[i]+shoulders[i])*.5
		var height=sqrt(maxf(0,18*18-offset.length_squared()*.25))
		var normal=offset.normalized().orthogonal()
		var a=middle+normal*height
		var b=middle-normal*height
		var side=(-1 if i==0 else 1)*face
		if primary_id()=='': result.append(middle+Vector2(side*3,0))
		else: result.append(a if a.x*side>b.x*side else b)
	return result

func arm_segment(a: Vector2, b: Vector2, width: float, color: Color):
	var outline=Color('#10111C')
	game.draw_line(a,b,outline,width+3,true)
	for end in [a,b]: game.draw_circle(end,width*.5+1.5,outline)
	game.draw_line(a,b,color,width,true)
	for end in [a,b]: game.draw_circle(end,width*.5,color)
	var side=(b-a).normalized().orthogonal()*width*.18
	game.draw_line(a+side,b+side,color.lightened(.25),maxf(1,width*.22),true)

func draw_arms(hands: Array):
	var shoulders=shoulder_positions()
	var bends=elbows(hands)
	var skin=game.GearArt.skin(game.characters[game.selected].id)
	var width=8.0 if game.selected in [0,5] else 6.0
	for i in range(2):
		arm_segment(shoulders[i],bends[i],width,skin)
		arm_segment(bends[i],hands[i],width*.85,skin.darkened(.08))
		# Wrist guards connect naturally to the glove components.
		arm_segment(hands[i].lerp(bends[i],.22),hands[i],width,Color('#272332'))

func draw_hands(hands: Array):
	var bends=elbows(hands)
	for i in range(2):
		var angle=(hands[i]-bends[i]).angle()
		game.draw_set_transform(hands[i],angle,Vector2(1,1 if i==0 else -1))
		game.draw_texture_rect_region(HeroArt.hand_texture(),Rect2(-14,-14,28,28),HeroArt.hand_region(game.characters[game.selected].id),game.Mastery.tint(game.Mastery.selected(game.saved,game.characters[game.selected].id)))
		game.draw_set_transform(Vector2.ZERO)

func draw_weapons(behind: bool = false):
	var pose=held_pose()
	var pose_behind=false if pose.is_empty() else Vector2.from_angle(pose.angle).y<-.25
	if pose.get('id','')=='tools':pose_behind=false
	if behind==pose_behind:
		var hands=hand_positions()
		draw_arms(hands)
		if pose.get('id','')=='tools':
			var r=rig('tools');var strength=sin((1-r.swing/.32)*PI) if r.swing>0 else 0.0
			for i in range(2):
				var angle=(pose.angle+PI*.5)*strength if r.get('double_hit',false) or int(r.get('hand',0))==i else .15*(1 if i==0 else -1)
				game.draw_set_transform(hands[i],angle)
				var id='wrench' if i==0 else 'pliers'
				game.draw_texture_rect_region(Art.weapon_texture(id),Rect2(-24,-64,48,84),Art.weapon(id),game.GearArt.weapon_tint(game.run_loadout))
				preload('res://scripts/ui/weapon_skins.gd').livery(game,Rect2(-24,-64,48,84),game.run_loadout,game.animation_clock)
				game.draw_set_transform(Vector2.ZERO)
		elif not pose.is_empty():
			game.draw_set_transform(pose.center,pose.angle,Vector2(1,pose.mirror))
			game.draw_texture_rect_region(Art.weapon_texture(pose.id),pose.rect,Art.weapon(pose.id),game.GearArt.weapon_tint(game.run_loadout))
			preload('res://scripts/ui/weapon_skins.gd').livery(game,pose.rect,game.run_loadout,game.animation_clock)
			for w in game.weapons:
				if w.id!=pose.id:continue
				var spec=Specs.definition(w)
				if spec.is_empty():continue
				var at=Vector2(54,-33) if pose.id=='hammer' else Vector2(3,-25)
				game.draw_texture_rect(Specs.icon(w.spec),Rect2(at,Vector2(28,28)),false)
				game.draw_line(at+Vector2(2,29),at+Vector2(29,29),Color(spec.color),4,true)
			if pose.id not in ['hammer','mop','bomb'] and pose.pulse>0:
				var color=Art.color_for(game.selected)
				var kick=pose.pulse/.115
				var muzzle=Vector2(44,-6)
				var star=PackedVector2Array([muzzle+Vector2(-7,-4),muzzle+Vector2(7,-15),muzzle+Vector2(10,-5),muzzle+Vector2(27,0),muzzle+Vector2(10,6),muzzle+Vector2(6,14),muzzle+Vector2(-5,5)])
				game.draw_colored_polygon(star,Color(color,.8*kick))
				game.draw_line(muzzle,muzzle+Vector2(15,0),Color(1,1,1,kick),5,true)
			game.draw_set_transform(Vector2.ZERO)
		if pose.get('id','')=='mop':game.twinkle.draw_bottle(hands[1])
		draw_hands(hands)
	if behind: return
	# Orbit Blade is a free orbiting weapon, never another pair of holding arms.
	for w in game.weapons:
		if w.id!='orbit': continue
		var orbit_pose=game.specialized_combat.orbit_pose(w)
		var angle=orbit_pose.angle
		var radius=orbit_pose.radius
		var color=Art.color_for(game.selected)
		game.draw_arc(game.player.position,radius,angle-.65,angle,16,Color(color,.3),8,true)
		game.draw_arc(game.player.position,radius,angle-.35,angle,12,Color(color,.7),3,true)
		game.draw_set_transform(game.player.position+Vector2.from_angle(angle)*radius,angle+PI*.5)
		var blade_size:float=orbit_pose.size
		game.draw_texture_rect_region(Art.weapon_texture('orbit'),Rect2(Vector2.ONE*(-blade_size/2),Vector2.ONE*blade_size),Art.weapon('orbit'),game.GearArt.weapon_tint(game.run_loadout))
		preload('res://scripts/ui/weapon_skins.gd').livery(game,Rect2(Vector2.ONE*(-blade_size/2),Vector2.ONE*blade_size),game.run_loadout,game.animation_clock)
		if not Specs.definition(w).is_empty():game.draw_texture_rect(Specs.icon(w.spec),Rect2(-11,-11,22,22),false)
		game.draw_set_transform(Vector2.ZERO)

func draw_shots():
	for s in game.shots:
		if not s.active: continue
		if game.united.draw_shot(s):continue
		var skin=int(s.get('skin',game.selected))
		var color=Color('#FF592E') if s.hostile else preload('res://scripts/ui/weapon_skins.gd').color(game.run_loadout,Art.color_for(skin))
		var direction: Vector2=s.vel.normalized()
		if s.hostile and s.get('enemy_kind','')=='spitter':
			game.draw_line(s.pos-direction*28,s.pos,Color(1,.3,.15,.45),8,true)
			game.draw_circle(s.pos,12,Color('#14213D'))
			game.draw_circle(s.pos,9,Color('#FF7040'))
			game.draw_circle(s.pos+Vector2(-2,-3),4,Color('#FFD166'))
			continue
		if not s.hostile and Specs.all().has(s.get('spec','')):
			var accent=Color(Specs.all()[s.spec].color)
			if s.spec=='blast':game.draw_arc(s.pos,14,0,TAU,16,accent,3,true)
			else:game.draw_line(s.pos-direction*45,s.pos,Color(accent,.8),4,true)
		if not s.hostile and skin>=11:
			game.draw_line(s.pos-direction*25,s.pos,Color(color,.5),6,true)
			if skin==12:
				for distance in [0,10,20]:game.draw_arc(s.pos-direction*distance,7,-PI*.45+direction.angle(),PI*.45+direction.angle(),10,color,2,true)
			else:game.draw_circle(s.pos,5,color);game.draw_circle(s.pos,2,Color.WHITE)
			continue
		var split=s.get('weapon','blaster')=='splitgun'
		var length=32.0 if split else 44.0
		var thickness=16.0 if split else 23.0
		if s.hostile: length=58; thickness=36
		game.draw_line(s.pos-direction*58,s.pos-direction*10,Color(color,.10),thickness*.7,true)
		game.draw_line(s.pos-direction*38,s.pos-direction*8,Color(color,.4),3,true)
		game.draw_line(s.pos-direction*26,s.pos-direction*8,Color(color,.22),thickness*.5,true)
		game.draw_set_transform(s.pos,s.vel.angle())
		game.draw_texture_rect_region(Art.TEXTURE,Rect2(-length+9,-thickness*.5,length,thickness),Art.projectile(skin,s.hostile))
		game.draw_set_transform(Vector2.ZERO)
func draw_effects():
	for e in fx:
		var progress=1.0-e.life/e.full
		var alpha=1.0-progress
		var color=Color('#FF592E') if e.get('hostile',false) else Art.color_for(e.skin)
		match e.kind:
			'beam':
				var points=PackedVector2Array()
				var offset: Vector2=e.end-e.pos
				var normal=offset.normalized().orthogonal()
				for i in range(9):
					var wobble=(1 if i%2 else -1)*10.0 if i>0 and i<8 else 0.0
					points.append(e.pos+offset*(i/8.0)+normal*wobble)
				game.draw_polyline(points,Color(color,alpha*.18),10,true)
				game.draw_polyline(points,Color(color,alpha),3.5,true)
				game.draw_polyline(points,Color(1,1,1,alpha),1.3,true)
				game.draw_arc(e.end,12+progress*20,0,TAU,16,Color(color,alpha),3,true)
			'slam':
				game.draw_set_transform(e.pos,0,Vector2(1,.6))
				game.draw_arc(Vector2.ZERO,18+progress*80,0,TAU,32,Color(color,alpha),6*alpha+1,true)
				game.draw_arc(Vector2.ZERO,10+progress*55,0,TAU,24,Color(1,1,1,alpha*.8),2,true)
				game.draw_set_transform(Vector2.ZERO)
				for i in range(6):
					var dir=Vector2.from_angle(i*TAU/6)
					game.draw_line(e.pos+dir*12,e.pos+dir*(20+progress*45),Color(color,alpha),3,true)
			'impact':
				for i in range(5):
					var dir=Vector2.from_angle(i*TAU/5+.4)
					game.draw_line(e.pos+dir*(4+progress*10),e.pos+dir*(10+progress*28),Color(color,alpha),3*alpha+1,true)
				game.draw_line(e.pos-Vector2(5,0)*alpha,e.pos+Vector2(5,0)*alpha,Color(1,1,1,alpha),5*alpha+1,true)
			'shell':
				var pos: Vector2=e.pos+e.dir*progress*37+Vector2(0,-sin(progress*PI)*22)
				game.draw_set_transform(pos,progress*7)
				game.draw_rect(Rect2(-4,-2,8,4),Color('#F9CC6B')*Color(1,1,1,alpha))
				game.draw_set_transform(Vector2.ZERO)
