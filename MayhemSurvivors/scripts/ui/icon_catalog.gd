extends RefCounted
static var cache:Dictionary={}
const IDS=['play','characters','stats','settings','back','next','pause','check','close','help','coins','xp','vital','damage','rapid','speed','crit','armor','magnet','projectile','heal','multi','shop','reroll','weapon','items','sets','upgrade','salvage','lock','clock','trophy','skull','volume','music','haptic','fx','world','history','grip','plate','battery','coolant','boots','lens','pack','shockwave','impulse','shadow_step']
static func get_icon(id:String) -> Texture2D:
	if not IDS.has(id):return null
	if not cache.has(id):cache[id]=load('res://assets/ui/icons/'+id+'.svg')
	return cache[id]
static func button_id(text:String) -> String:
	if text.is_empty():return ''
	var t=text.to_upper()
	if t.contains('VERWERTEN'):return 'salvage'
	if t.contains('ERREICHT'):return 'check'
	if t=='ZUM LADEN':return 'shop'
	if t=='ÜBERSICHT':return 'stats'
	for pair in [['PAUSE','pause'],['Ⅱ','pause'],['FORTSETZEN','play'],['SPIELEN','play'],['LOS GEHT','play'],['CHARAKTER','characters'],['BRUISER','characters'],['SPARKY','characters'],['SHADE','characters'],['TWINKLE','characters'],['KICKSY','characters'],['STEELFIST','characters'],['STATISTIK','stats'],['WERTE','stats'],['EINSTELLUNG','settings'],['ZURÜCK','back'],['VORHERIGE','back'],['HAUPTMENÜ','world'],['HILFE','help'],['REROLL','reroll'],['KAUFEN','coins'],['VERWERTEN','salvage'],['AUFRÜSTEN','upgrade'],['ENTWICKELN','upgrade'],['WAFFEN','weapon'],['GEGENSTÄNDE','items'],['SETS','sets'],['ZIELE','trophy'],['RING','trophy'],['ARENA','world'],['RUN BEENDEN','close'],['GESPERRT','lock'],['LETZTE WAFFE','lock'],['ERSTER SIEG','lock'],['LETZTE RUNDEN','history'],['VIBRATION','haptic'],['SPLATTER','fx'],['SCHADENSZAHLEN','damage'],['LOW','settings'],['MEDIUM','settings'],['HIGH','settings']]:
		if t.contains(pair[0]):return pair[1]
	return 'check' if t.contains('AKTIV') or t.contains('BEHALTEN') or t.contains('VERSTANDEN') or t.contains('GEKAUFT') else 'next'
