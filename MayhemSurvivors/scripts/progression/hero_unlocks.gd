extends RefCounted
static func kills(saved:Dictionary) -> int:
	var total=int(saved.get('kills',0))
	for r in saved.get('endless_records',{}).values():
		if r is Dictionary:total+=int(r.get('kills',0))
	return total
static func available(saved:Dictionary,id:String) -> bool:
	return id in ['bruiser','sparky','shade','twinkle','steelfist'] or (id=='kicksy' and saved.get('settings',{}).get('tutorial_complete',false) and kills(saved)>=500)
static func sync(saved:Dictionary) -> bool:
	if not available(saved,'kicksy') or saved.unlocked.has('kicksy'):return false
	saved.unlocked.append('kicksy');return true
