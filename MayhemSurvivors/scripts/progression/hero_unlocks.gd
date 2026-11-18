extends RefCounted
const Roster=preload('res://scripts/core/roster.gd')
static func kills(saved:Dictionary) -> int:
	var total=int(saved.get('kills',0))
	for r in saved.get('endless_records',{}).values():
		if r is Dictionary:total+=int(r.get('kills',0))
	return total
static func available(saved:Dictionary,id:String) -> bool:
	return id=='bruiser' or (id in Roster.HEROES.slice(1) and saved.get('collection',{}).get('heroes',[]).has(id))
static func sync(saved:Dictionary) -> bool:
	saved.unlocked=['bruiser']
	for id in Roster.HEROES.slice(1):
		if available(saved,id):saved.unlocked.append(id)
	return false
