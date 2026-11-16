extends RefCounted
# Visual-only world renderer. It never changes enemies, collisions or gameplay RNG.
const FLOOR = preload('res://assets/environments/scrapyard.png')
const REACTOR_FLOOR=preload('res://assets/environments/reactor.png')
const GUARDIAN=preload('res://assets/enemies/reactor_guardian.png')
const GUARDIAN_REGION=Rect2(0,70,1254,1168)
const ROLE_ART=preload('res://assets/enemies/reactor_roles.png')
const ELITES=preload('res://assets/enemies/elites.png')
const ENEMIES = preload('res://assets/enemies/enemies_atlas.png')
const REGIONS = {'grunt':Rect2(132,79,377,516),'runner':Rect2(738,60,383,536),'tank':Rect2(26,675,576,566),'boss':Rect2(636,633,571,611),'spitter':Rect2(32,90,704,870),'drone':Rect2(792,72,720,824)}
var game: Node2D
var deaths: Array = []
func _init(owner_game: Node2D):game=owner_game
func clear():deaths.clear()
func update(dt: float):
	for i in range(deaths.size()-1,-1,-1):
		deaths[i].life-=dt
		if deaths[i].life<=0:deaths.remove_at(i)
func death_limit() -> int:
	return 12 if game.saved.settings.quality=='LOW' else (20 if game.saved.settings.quality=='MEDIUM' else 32)
func enemy_defeated(enemy: Dictionary):
	if deaths.size()>=death_limit():return
	deaths.append({'kind':enemy.kind,'elite':enemy.get('elite',''),'pos':enemy.pos,'radius':enemy.radius,'life':.38,'full':.38,'face':-1.0 if game.player.position.x<enemy.pos.x else 1.0})
static func region(kind: String) -> Rect2:
	return REGIONS.get(kind,Rect2(0,0,1,1))
static func dimensions(radius: float, kind: String = 'grunt') -> Vector2:
	var source=region(kind).size
	var width=radius*(2.2 if kind in ['grunt','runner'] else 2.6)
	return Vector2(width,width*source.y/source.x)
func draw_arena():
	game.draw_texture_rect(REACTOR_FLOOR if game.is_reactor() else FLOOR,Rect2(0,0,2400,1600),false)
func draw_enemy(enemy: Dictionary, decorative: bool = false):
	var radius: float=enemy.radius
	var guardian=game.is_reactor() and enemy.kind=='boss'
	var elite=enemy.get('elite','')!=''
	var source=Rect2((ELITES.get_width()*.5) if enemy.get('elite')=='pulse' else 0,0,ELITES.get_width()*.5,ELITES.get_height()) if elite else (GUARDIAN_REGION if guardian else region(enemy.kind))
	var size=Vector2(radius*2.8,radius*2.8*source.size.y/source.size.x) if guardian else (Vector2(radius*3.0,radius*3.0*source.size.y/source.size.x) if elite else dimensions(radius,enemy.kind))
	var pos: Vector2=enemy.pos
	var clock=game.animation_clock if decorative else game.run_time
	var speed=11.0 if enemy.kind in ['runner','drone'] else (5.0 if enemy.kind in ['boss','tank'] else 8.0)
	var stride=sin(clock*speed+pos.x*.015)
	var bounce=absf(stride)*(5.0 if enemy.kind=='drone' else (2.0 if enemy.kind=='boss' else 1.6))
	var face=-1.0 if game.player.position.x<pos.x else 1.0
	if enemy.kind=='spitter' and float(enemy.get('windup',0))>0:face=-1.0 if enemy.aim.x<pos.x else 1.0
	game.draw_set_transform(pos+Vector2(0,size.y*.29),0,Vector2(1,.3))
	game.draw_circle(Vector2.ZERO,radius*.9,Color(0,0,0,.28))
	game.draw_set_transform(pos,stride*.018,Vector2(face,1))
	var tint=Color(2.2,2.2,2.2) if float(enemy.get('hit',0))>0 else Color.WHITE
	game.draw_texture_rect_region(ELITES if elite else (GUARDIAN if guardian else (ROLE_ART if enemy.kind in ['spitter','drone'] else ENEMIES)),Rect2(Vector2(-size.x*.5,-size.y*.66-bounce),size),source,tint)
	game.draw_set_transform(Vector2.ZERO)
	if enemy.kind!='boss' and (elite or enemy.get('hp',1)<enemy.get('max_hp',1)):
		var bar=pos+Vector2(-radius,-size.y*.66-10)
		var ratio=maxf(0,enemy.hp/enemy.max_hp)
		game.draw_line(bar,bar+Vector2(radius*2,0),Color('#101323'),7,true)
		game.draw_line(bar,bar+Vector2(radius*2*ratio,0),Color('#FF6376'),4,true)
func draw_deaths():
	for e in deaths:
		var progress=1.0-e.life/e.full
		var alpha=1.0-progress
		var guardian=game.is_reactor() and e.kind=='boss'
		var elite=e.get('elite','')!=''
		var source=Rect2((ELITES.get_width()*.5) if e.get('elite')=='pulse' else 0,0,ELITES.get_width()*.5,ELITES.get_height()) if elite else (GUARDIAN_REGION if guardian else region(e.kind))
		var base=Vector2(e.radius*2.8,e.radius*2.8*source.size.y/source.size.x) if guardian else (Vector2(e.radius*3.0,e.radius*3.0*source.size.y/source.size.x) if elite else dimensions(e.radius,e.kind))
		var size=base*Vector2(1+progress*.12,1-progress*.6)
		game.draw_set_transform(e.pos,0,Vector2(e.face,1))
		game.draw_texture_rect_region(ELITES if elite else (GUARDIAN if guardian else (ROLE_ART if e.kind in ['spitter','drone'] else ENEMIES)),Rect2(Vector2(-size.x*.5,-size.y*.66+progress*10),size),source,Color(1,1,1,alpha*.7))
		game.draw_set_transform(Vector2.ZERO)
		var color=Color(game.enemy_definition(e.kind).color)
		for i in range(5):
			var dir=Vector2.from_angle(i*TAU/5+.25)
			var at=e.pos+dir*(7+progress*(e.radius+16))
			game.draw_line(at,at+dir*6,Color(color,alpha),3*alpha+1,true)
func boss_telegraph() -> Dictionary:
	if game.is_reactor():return {}
	# Read the actual combat phase and the locked target, never a guessed attack timer.
	for e in game.enemies:
		if e.kind!='boss':continue
		if game.boss_phase==1:return {'kind':'radial','origin':e.pos,'radius':e.radius,'progress':clampf(1-game.boss_clock/1.3,0,1),'seconds':maxf(0,game.boss_clock)}
		if game.boss_phase==3:return {'kind':'charge','origin':e.pos,'target':game.boss_target,'radius':e.radius,'progress':clampf(1-game.boss_clock/1.3,0,1),'seconds':maxf(0,game.boss_clock)}
	return {}
func draw_telegraph():
	var t=boss_telegraph()
	if t.is_empty():return
	var pulse=.5+.5*sin(game.run_time*18)
	var color=Color('#FF594C')
	if t.kind=='radial':
		var radius=t.radius+36
		game.draw_arc(t.origin,radius,0,TAU,64,Color(color,.5+.3*pulse),5,true)
		game.draw_arc(t.origin,radius+12,0,TAU*t.progress,64,Color('#FFD166'),3,true)
		for i in range(18):
			var dir=Vector2.from_angle(i*TAU/18)
			var normal=dir.orthogonal()
			var end=t.origin+dir*(radius+70)
			game.draw_line(t.origin+dir*(t.radius+8),end,Color(color,.2+.3*t.progress),3,true)
			game.draw_colored_polygon(PackedVector2Array([end+dir*10,end-dir*8+normal*6,end-dir*8-normal*6]),Color(color,.55+.3*pulse))
	else:
		var dir: Vector2=(t.target-t.origin).normalized()
		var normal=dir.orthogonal()*t.radius
		game.draw_colored_polygon(PackedVector2Array([t.origin+normal,t.target+normal,t.target-normal,t.origin-normal]),Color(color,.12+.09*pulse))
		for side in [-1,1]:game.draw_line(t.origin+normal*side,t.target+normal*side,Color(color,.6),3,true)
		game.draw_arc(t.target,t.radius,0,TAU,48,Color(color,.7),3,true)
		var length: float=t.origin.distance_to(t.target)
		for i in range(1,6):
			var at: Vector2=t.origin+dir*(length*i/6)
			game.draw_line(at-dir*10+dir.orthogonal()*10,at,Color('#FFD166'),3,true)
			game.draw_line(at-dir*10-dir.orthogonal()*10,at,Color('#FFD166'),3,true)
