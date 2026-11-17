extends RefCounted
const C=preload('res://scripts/progression/collection.gd')
const Hero=preload('res://scripts/ui/character_art.gd')
const Weapon=preload('res://scripts/ui/combat_art.gd')
const WEARABLES=preload('res://assets/ui/garage/wearables.png')
const WEAR_IDS=['hard_hat','neon_visor','skull_mask','scrap_vest','reactor_plate','mayhem_jacket','steel_boots','neon_soles','raider_boots']
const CASES=preload('res://assets/ui/garage/cases.png')
static var icons:Dictionary={}
static func icon(id:String) -> Texture2D:
	if not icons.has(id):
		if WEAR_IDS.has(id):
			var i=WEAR_IDS.find(id);var row=i/3;var size=Vector2(WEARABLES.get_size());var y=[0,.31,.65][row];var h=[.31,.34,.35][row]
			var atlas=AtlasTexture.new();atlas.atlas=WEARABLES;atlas.region=Rect2(Vector2((i%3)/3.0,y)*size,Vector2(1.0/3,h)*size);icons[id]=atlas;return atlas
		var path='res://assets/ui/meta/'+id+'.svg' if id in ['comet','circuit','flame','mini_bot','bomb_buddy','chaos_title'] else 'res://assets/ui/garage/'+id+'.svg'
		icons[id]=load(path)
	return icons[id]
static func case_region(id:String) -> Rect2:return Rect2(['crew','arsenal','style'].find(id)*CASES.get_width()/3.0,0,CASES.get_width()/3.0,CASES.get_height())
static func skin_color(loadout:Dictionary) -> Color:
	var id:String=loadout.get('skin','')
	return Color(C.catalog().items[id].color) if C.catalog().items.has(id) else Color.WHITE
static func weapon_tint(loadout:Dictionary) -> Color:
	return Color.WHITE.lerp(skin_color(loadout),.45) if loadout.get('skin','')!='' else Color.WHITE
static func dress(canvas:CanvasItem,hero:String,loadout:Dictionary,rect:Rect2):
	var modern=hero in ['twinkle','kicksy','steelfist']
	var eye=float({'bruiser':.15,'sparky':.22,'shade':.17,'twinkle':.20,'kicksy':.20,'steelfist':.10}.get(hero,.15))
	for slot in ['body','feet','head']:
		var id:String=loadout.get(slot,'')
		if not C.catalog().items.has(id):continue
		var boxes:Array=[]
		if slot=='body':boxes=[Rect2(.33,.30 if not modern else .32,.33,.28)]
		elif slot=='feet':
			if hero=='bruiser':boxes=[Rect2(.17,.79,.34,.19),Rect2(.50,.79,.34,.19)]
			elif hero=='steelfist':boxes=[Rect2(.25,.81,.28,.18),Rect2(.55,.81,.28,.18)]
			else:boxes=[Rect2(.21,.81,.30,.18),Rect2(.53,.81,.30,.18)]
		elif id=='hard_hat':boxes=[Rect2(.29,eye-.18,.41,.20)]
		elif id=='neon_visor':boxes=[Rect2(.31,eye-.09,.37,.16)]
		else:boxes=[Rect2(.34,eye-.09,.32,.24)]
		for box in boxes:canvas.draw_texture_rect(icon(id),Rect2(rect.position+box.position*rect.size,box.size*rect.size),false)
static func preview(canvas:CanvasItem,hero:String,loadout:Dictionary,tint:Color=Color.WHITE):
	canvas.draw_texture_rect_region(Hero.texture(hero,true),Rect2(0,0,360,360),Hero.body_region(hero),tint)
	dress(canvas,hero,loadout,Rect2(0,0,360,360))
	var id:String=loadout.get('weapon',C.STARTERS[hero]);var hands=[Vector2(200,220),Vector2(260,215)]
	if id in ['tools','orbit']:hands=[Vector2(108,233),Vector2(254,233)]
	var shoulders=[Vector2(143,113 if hero in ['twinkle','kicksy','steelfist'] else 128),Vector2(220,113 if hero in ['twinkle','kicksy','steelfist'] else 128)]
	for i in range(2):
		var elbow=(shoulders[i]+hands[i])*.5+Vector2(-20 if i==0 else 20,0)
		arm(canvas,shoulders[i],elbow,18,Color('#292537'))
		arm(canvas,elbow,hands[i],15,Color('#B38462') if hero!='shade' else Color('#363049'))
	if id=='tools':
		for i in range(2):canvas.draw_texture_rect_region(Weapon.weapon_texture('wrench'),Rect2(hands[i]-Vector2(24,130),Vector2(48,160)),Weapon.weapon('wrench' if i==0 else 'pliers'),weapon_tint(loadout))
	elif id=='orbit':canvas.draw_texture_rect_region(Weapon.weapon_texture(id),Rect2(270,160,90,90),Weapon.weapon(id),weapon_tint(loadout))
	else:canvas.draw_texture_rect_region(Weapon.weapon_texture(id),Rect2(155,155,160,120),Weapon.weapon(id),weapon_tint(loadout))
	for i in range(2):canvas.draw_texture_rect_region(Hero.texture(hero,true),Rect2(hands[i]-Vector2(18,18),Vector2(36,36)),Hero.hand_region(hero),tint)

static func arm(canvas:CanvasItem,a:Vector2,b:Vector2,width:float,color:Color):
	canvas.draw_line(a,b,Color('#10121C'),width+5,true)
	for at in [a,b]:canvas.draw_circle(at,width*.5+2.5,Color('#10121C'))
	canvas.draw_line(a,b,color,width,true)
	for at in [a,b]:canvas.draw_circle(at,width*.5,color)
	var side=(b-a).normalized().orthogonal()*width*.2
	canvas.draw_line(a+side,b+side,color.lightened(.3),width*.23,true)
