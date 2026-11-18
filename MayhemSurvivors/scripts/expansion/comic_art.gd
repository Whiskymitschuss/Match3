extends RefCounted
const R=preload('res://scripts/core/roster.gd')
const HEROES=preload('res://assets/characters/united_heroes.png')
const ENEMIES=preload('res://assets/enemies/united_enemies.png')
const BOSSES=preload('res://assets/enemies/united_bosses.png')
const WEAPONS=preload('res://assets/weapons/united_weapons.png')
const FLOORS=preload('res://assets/environments/united.png')
const ENEMY_IDS=['grunt','runner','tank','ravox','bombling','longshot','hexling','spitter','drone','slicer','lurker','shieldbug','medic','mortar','frostling','roller','leech','summoner','pyro','elite']
const WEAPON_IDS=['blaster','hammer','splitgun','arc','orbit','mop','bomb','tools','flamer','cryo','tesla','lance','chakram','wrench','pliers','spray']
static var floor_cache={}
static func cell(t:Texture2D,i:int,columns:int,rows:int) -> Rect2:
	var step=Vector2(t.get_size())/Vector2(columns,rows)
	return Rect2(Vector2(i%columns,i/columns)*step,step).grow(-2)
static func hero(id:String) -> Rect2:return cell(HEROES,maxi(0,R.HEROES.find(id)),4,3)
static func glove() -> Rect2:
	var r=cell(HEROES,11,4,3);return Rect2(r.position+r.size*Vector2(.15,.15),r.size*Vector2(.82,.73))
static func weapon(id:String) -> Rect2:
	var r=cell(WEAPONS,maxi(0,WEAPON_IDS.find(id)),4,4)
	if id in ['wrench','pliers']:return Rect2(r.position+r.size*Vector2(.20,0),r.size*Vector2(.60,1))
	return r
static func floor_texture(id:String) -> Texture2D:
	if not floor_cache.has(id):
		var texture=AtlasTexture.new();texture.atlas=FLOORS;texture.region=cell(FLOORS,maxi(0,R.ARENAS.find(id)),2,5);floor_cache[id]=texture
	return floor_cache[id]
static func boss_index(g:Node2D,e:Dictionary) -> int:
	if e.kind=='breaker_axel':return 0
	return int(e.get('boss_art',g.arena_definition.get('boss_art',4)))
static func draw_enemy(g:Node2D,e:Dictionary,decorative:bool=false):
	var boss=R.BOSS_KINDS.has(e.kind);var texture=BOSSES if boss else ENEMIES
	var index=boss_index(g,e) if boss else (19 if e.get('elite','')!='' else maxi(0,ENEMY_IDS.find(e.kind)))
	var region=cell(texture,index,5,3 if boss else 4)
	var size=Vector2.ONE*float(e.radius)*(3.2 if boss else 2.9)
	var clock:float=g.animation_clock if decorative else g.run_time
	var stride=sin(clock*(5 if boss else 9)+e.pos.x*.01)
	if e.kind=='breaker_axel' and g.breaker.stage=='hammer':stride=sin(clock*36)*4
	var face=-1.0 if g.player.position.x<e.pos.x else 1.0
	g.draw_set_transform(e.pos+Vector2(0,size.y*.24),0,Vector2(1,.26));g.draw_circle(Vector2.ZERO,e.radius*.9,Color(0,0,0,.3))
	g.draw_set_transform(e.pos,stride*.018,Vector2(face,1))
	var tint=Color(2,2,2) if float(e.get('hit',0))>0 else Color.WHITE
	if boss and g.united.bosses.rage(e):tint=Color(1.25,.8,.65) if float(e.get('hit',0))<=0 else tint
	g.draw_texture_rect_region(texture,Rect2(Vector2(-size.x*.5,-size.y*.72-absf(stride)*1.8),size),region,tint)
	g.draw_set_transform(Vector2.ZERO)
	if not boss and float(e.get('hp',1))<float(e.get('max_hp',1)):
		var at:Vector2=e.pos+Vector2(-e.radius,-size.y*.75-5)
		g.draw_line(at,at+Vector2(e.radius*2,0),Color('#100E1C'),6,true)
		g.draw_line(at,at+Vector2(e.radius*2*maxf(0,e.hp/e.max_hp),0),Color('#FF738A'),3,true)
static func draw_death(g:Node2D,e:Dictionary):
	var t=1-float(e.life)/float(e.full);var boss=R.BOSS_KINDS.has(e.kind)
	var texture=BOSSES if boss else ENEMIES
	var index=int(e.get('comic_art',4)) if boss else (19 if e.get('elite','')!='' else maxi(0,ENEMY_IDS.find(e.kind)))
	var size=Vector2.ONE*float(e.radius)*(3.2 if boss else 2.9)*Vector2(1+t*.2,1-t*.65)
	g.draw_set_transform(e.pos,0,Vector2(e.face,1));g.draw_texture_rect_region(texture,Rect2(-size*Vector2(.5,.72),size),cell(texture,index,5,3 if boss else 4),Color(1,1,1,1-t));g.draw_set_transform(Vector2.ZERO)

# Shoulder socket centers measured in the shared 360-unit portrait coordinate system.
# The same anchors drive both menu and combat rigs; no embedded extra arms.
static func shoulders(id:String) -> Array:
	var points={'bruiser':[Vector2(152,143),Vector2(258,139)],'sparky':[Vector2(155,145),Vector2(241,143)],'shade':[Vector2(118,145),Vector2(231,143)],'twinkle':[Vector2(140,145),Vector2(244,143)],'kicksy':[Vector2(173,143),Vector2(265,144)],'steelfist':[Vector2(134,130),Vector2(248,132)],'cinder':[Vector2(131,137),Vector2(238,137)],'frosty':[Vector2(139,146),Vector2(247,143)],'volt':[Vector2(139,133),Vector2(245,133)],'rook':[Vector2(122,127),Vector2(247,130)],'nyx':[Vector2(152,145),Vector2(250,144)]}
	return points.get(id,points.bruiser)
