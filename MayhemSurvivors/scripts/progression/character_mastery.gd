extends RefCounted
# Derived from validated lifetime character records: no duplicate progress counters.
const HEROES=['bruiser','sparky','shade']
const STYLES=['classic','neon','champion']
const NAMES={'classic':'ORIGINAL','neon':'NEON CREW','champion':'GOLD CHAMPION'}
const TITLES={'bruiser':'SCHROTTKÖNIG','sparky':'FUNKENKÖNIGIN','shade':'NACHTMEISTER'}
static func goals(saved:Dictionary, hero:String) -> Array:
	var r=saved.get('records',{}).get(hero,{})
	return [
		{'name':'ÜBERLEBENSKÜNSTLER','value':mini(5,int(r.get('best_wave',0))),'target':5,'description':'Welle 5 erreichen','reward':'Neon Crew Farbvariante'},
		{'name':'MONSTERJÄGER','value':mini(250,int(r.get('kills',0))),'target':250,'description':'250 Gegner insgesamt besiegen','reward':'Jägerabzeichen'},
		{'name':'BOSSBRECHER','value':mini(1,int(r.get('wins',0))),'target':1,'description':'Einen Durchlauf gewinnen','reward':'Gold Champion Farbvariante'}]
static func unlocked(saved:Dictionary, hero:String, style:String) -> bool:
	if not hero in HEROES:return false
	var g=goals(saved,hero)
	return style=='classic' or (style=='neon' and g[0].value>=5) or (style=='champion' and g[2].value>=1)
static func completed(saved:Dictionary,hero:String) -> int:
	var total=0
	for goal in goals(saved,hero):total+=int(goal.value>=goal.target)
	return total
static func selected(saved:Dictionary,hero:String) -> String:
	var style=saved.get('hero_styles',{}).get(hero,'classic')
	return style if unlocked(saved,hero,style) else 'classic'
static func equip(saved:Dictionary,hero:String,style:String) -> bool:
	if not unlocked(saved,hero,style):return false
	if not saved.has('hero_styles'):saved.hero_styles={}
	saved.hero_styles[hero]=style
	return true
static func sanitize(saved:Dictionary,source) -> Dictionary:
	var result={}
	for hero in HEROES:
		var style=source.get(hero,'classic') if source is Dictionary else 'classic'
		result[hero]=style if style is String and unlocked(saved,hero,style) else 'classic'
	return result
static func rewards(saved:Dictionary,hero:String) -> Array[String]:
	var result:Array[String]=[]
	if unlocked(saved,hero,'neon'):result.append('NEON CREW')
	if int(saved.get('records',{}).get(hero,{}).get('kills',0))>=250:result.append('JÄGERABZEICHEN')
	if unlocked(saved,hero,'champion'):result.append('GOLD CHAMPION')
	if completed(saved,hero)==3:result.append(TITLES[hero])
	return result
static func tint(style:String) -> Color:
	return Color('#9CFFF4') if style=='neon' else (Color('#FFE0A0') if style=='champion' else Color.WHITE)
static func accent(style:String) -> Color:
	return Color('#00F5E0') if style=='neon' else Color('#FFD166')
static func insignia(canvas:CanvasItem,at:Vector2,style:String,size:float):
	if style=='classic':return
	var c=accent(style)
	var points=PackedVector2Array([at+Vector2(-size,-size*.6),at+Vector2(0,-size),at+Vector2(size,-size*.6),at+Vector2(size*.7,size*.6),at+Vector2(0,size),at+Vector2(-size*.7,size*.6)])
	canvas.draw_colored_polygon(points,Color('#101326'))
	canvas.draw_polyline(points+PackedVector2Array([points[0]]),c,maxf(1,size*.12),true)
	if style=='hunter':
		for direction in [-1,1]:
			canvas.draw_line(at+Vector2(-size*.5,-size*.5*direction),at+Vector2(size*.5,size*.5*direction),c,maxf(1,size*.15),true)
		canvas.draw_circle(at,size*.18,c)
	elif style=='neon':
		canvas.draw_polyline(PackedVector2Array([at+Vector2(size*.3,-size*.6),at+Vector2(-size*.25,0),at+Vector2(size*.25,0),at+Vector2(-size*.3,size*.6)]),c,maxf(1,size*.18),true)
	else:
		canvas.draw_colored_polygon(PackedVector2Array([at+Vector2(-size*.5,size*.3),at+Vector2(-size*.65,-size*.4),at+Vector2(-size*.2,0),at+Vector2(0,-size*.55),at+Vector2(size*.2,0),at+Vector2(size*.65,-size*.4),at+Vector2(size*.5,size*.3)]),c)
