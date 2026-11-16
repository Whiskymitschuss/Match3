extends RefCounted
# Cosmetic state only: no damage, collision, cooldown or gameplay RNG access.
const Art = preload('res://scripts/ui/combat_art.gd')
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
	game.sound({'blaster':'blaster_fire','splitgun':'splitgun_fire','hammer':'hammer_slam','arc':'arc_zap'}.get(id,'shot'))
	r.angle=direction.angle()
	r.pulse=.115
	if id=='hammer':
		r.swing=.26
		push({'kind':'slam','pos':game.player.position+direction*70,'life':.28,'full':.28,'skin':game.selected})
	elif id in ['blaster','splitgun']:
		shell_counter+=1
		push({'kind':'shell','pos':game.player.position+Vector2(0,-8),'dir':direction.orthogonal()*(-1 if shell_counter%2 else 1),'life':.3,'full':.3,'skin':game.selected})
func impact(pos: Vector2, weapon: String, hostile: bool = false):
	if weapon=='orbit' and impact_sound_clock<=0:
		game.sound('blade_hit')
		impact_sound_clock=.12
	push({'kind':'impact','pos':pos,'life':.19,'full':.19,'skin':game.selected,'weapon':weapon,'hostile':hostile})
func beam(origin: Vector2, target: Vector2):
	push({'kind':'beam','pos':origin,'end':target,'life':.22,'full':.22,'skin':game.selected})
func anchor(direction: Vector2, index: int) -> Vector2:
	# Main weapon is carried at torso height; other slots flank it without covering the face.
	var slots=[Vector2(0,0),Vector2(-43,18),Vector2(39,24),Vector2(-25,43)]
	return game.player.position+Vector2(0,-3)+direction*12+slots[index%4]
func draw_weapons(behind: bool = false):
	for i in range(game.weapons.size()):
		var w=game.weapons[i]
		var r=rig(w.id)
		var direction=Vector2.from_angle(r.angle)
		var color=Art.color_for(game.selected)
		if w.id=='orbit':
			if behind: continue
			var angle=game.orbit_angle
			var radius=110+5*(w.level-1)
			game.draw_arc(game.player.position,radius,angle-.65,angle,16,Color(color,.3),8,true)
			game.draw_arc(game.player.position,radius,angle-.35,angle,12,Color(color,.7),3,true)
			game.draw_set_transform(game.player.position+Vector2.from_angle(angle)*radius,angle+PI*.5)
			game.draw_texture_rect_region(Art.TEXTURE,Rect2(-34,-34,68,68),Art.weapon('orbit'))
			game.draw_set_transform(Vector2.ZERO)
			continue
		if behind != (direction.y<-.25): continue
		var pos=anchor(direction,i)
		if w.id=='hammer':
			var swing=1.0-r.swing/.26
			var offset=lerpf(-1.5,.6,swing) if r.swing>0 else -.3
			game.draw_set_transform(pos,r.angle+offset,Vector2(1,-1 if direction.x<0 else 1))
			game.draw_texture_rect_region(Art.TEXTURE,Rect2(-17,-43,114,86),Art.weapon('hammer'))
			game.draw_set_transform(Vector2.ZERO)
		else:
			var kick=r.pulse/.115
			pos-=direction*kick*7
			game.draw_set_transform(pos,r.angle,Vector2(1,-1 if direction.x<0 else 1))
			game.draw_texture_rect_region(Art.TEXTURE,Rect2(-32,-29,82,70),Art.weapon(w.id))
			if r.pulse>0:
				var muzzle=Vector2(44,-6)
				var star=PackedVector2Array([muzzle+Vector2(-7,-4),muzzle+Vector2(7,-15),muzzle+Vector2(10,-5),muzzle+Vector2(27,0),muzzle+Vector2(10,6),muzzle+Vector2(6,14),muzzle+Vector2(-5,5)])
				game.draw_colored_polygon(star,Color(color,.8*kick))
				game.draw_line(muzzle,muzzle+Vector2(15,0),Color(1,1,1,kick),5,true)
			game.draw_set_transform(Vector2.ZERO)
func draw_shots():
	for s in game.shots:
		if not s.active: continue
		var skin=int(s.get('skin',game.selected))
		var color=Color('#FF592E') if s.hostile else Art.color_for(skin)
		var direction: Vector2=s.vel.normalized()
		var split=s.get('weapon','blaster')=='splitgun'
		var length=32.0 if split else 44.0
		var thickness=16.0 if split else 23.0
		if s.hostile: length=58; thickness=36
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
