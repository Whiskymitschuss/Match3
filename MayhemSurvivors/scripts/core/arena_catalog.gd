extends RefCounted
const IDS = ['scrapyard','reactor']
static func definition(id: String) -> Dictionary:
	var data=JSON.parse_string(FileAccess.get_file_as_string('res://data/arenas/arenas.json'))
	return data.get(id,data.scrapyard)
static func unlocked(saved: Dictionary, id: String) -> bool:
	return id=='scrapyard' or (id=='reactor' and (int(saved.get('wins',0))>0 or saved.get('unlocked_arenas',[]).has(id)))
static func sync(saved: Dictionary) -> Array[String]:
	var added:Array[String]=[]
	if not saved.has('unlocked_arenas'):saved.unlocked_arenas=['scrapyard']
	if int(saved.get('wins',0))>0 and not saved.unlocked_arenas.has('reactor'):
		saved.unlocked_arenas.append('reactor')
		added.append('REAKTORZONE')
	if not saved.has('unlocked_styles'):saved.unlocked_styles=['class']
	var rules={'gold':int(saved.get('wins',0))>=1,'mayhem':int(saved.get('kills',0))>=1000,'reactor':saved.get('arena_records',{}).get('reactor',{}).get('wins',0)>=1}
	for id in rules:
		if rules[id] and not saved.unlocked_styles.has(id):
			saved.unlocked_styles.append(id)
			added.append({'gold':'CHAMPIONRING','mayhem':'MAYHEMRING','reactor':'REAKTORSIEGEL'}[id])
	return added
