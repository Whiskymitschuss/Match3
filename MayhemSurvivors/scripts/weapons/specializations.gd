extends RefCounted
const DATA_PATH='res://data/specializations/specializations.json'
static var cache:Dictionary={}
static func all() -> Dictionary:
	if cache.is_empty():cache=JSON.parse_string(FileAccess.get_file_as_string(DATA_PATH))
	return cache
static func valid(weapon:String,id) -> bool:
	if not id is String:return false
	return all().has(id) and all()[id].weapon==weapon
static func definition(w:Dictionary) -> Dictionary:
	var id=w.get('spec','')
	return all()[id] if int(w.level)==5 and valid(w.id,id) else {}
static func choices(weapon:String) -> Array:
	var result:Array=[]
	for id in all():
		if all()[id].weapon==weapon:result.append(id)
	return result
static func label(w:Dictionary) -> String:
	var d=definition(w)
	return d.name if not d.is_empty() else ''
static var icons:Dictionary={}
static func icon(id:String) -> Texture2D:
	if not all().has(id):return null
	if not icons.has(id):icons[id]=load('res://assets/ui/specializations/'+id+'.svg')
	return icons[id]
