extends RefCounted
const Roster=preload('res://scripts/core/roster.gd')
const Worlds=preload('res://scripts/progression/world_progress.gd')
const IDS=Roster.ARENAS
static func definition(id: String) -> Dictionary:
	var data=JSON.parse_string(FileAccess.get_file_as_string('res://data/arenas/arenas.json'))
	return data.get(id,data.scrapyard)
static func unlocked(saved: Dictionary, id: String) -> bool:
	return Worlds.available(saved,id)
static func sync(saved: Dictionary) -> Array[String]:
	var added:Array[String]=[]
	for id in Worlds.sync(saved):added.append(definition(id).name)
	if not saved.has('unlocked_styles'):saved.unlocked_styles=['class']
	var rules={'gold':int(saved.get('wins',0))>=1,'mayhem':int(saved.get('kills',0))>=1000,'reactor':saved.get('arena_records',{}).get('reactor',{}).get('wins',0)>=1}
	for id in rules:
		if rules[id] and not saved.unlocked_styles.has(id):
			saved.unlocked_styles.append(id)
			added.append({'gold':'CHAMPIONRING','mayhem':'MAYHEMRING','reactor':'REAKTORSIEGEL'}[id])
	return added

static func texture(id:String) -> Texture2D:return preload('res://scripts/expansion/comic_art.gd').floor_texture(id)
