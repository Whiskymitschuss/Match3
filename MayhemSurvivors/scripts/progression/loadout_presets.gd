extends RefCounted
const C=preload('res://scripts/progression/collection.gd')
const LIMIT=3
static func clean(source,collection:Dictionary) -> Dictionary:
	var result={}
	if not source is Dictionary:return result
	for hero in collection.heroes:
		var rows=source.get(hero)
		if not rows is Array:continue
		var entries=[]
		for i in range(mini(LIMIT,rows.size())):
			var row=rows[i]
			if not row is Dictionary or row.is_empty():entries.append({});continue
			var gear=C.empty_loadout(hero)
			for slot in C.SLOTS:
				var id=row.get(slot)
				if id is String and collection.levels.has(id) and C.catalog().items.get(id,{}).get('slot')==slot and (slot!='weapon' or C.ALLOWED[hero].has(id)):gear[slot]=id
			entries.append(gear)
		while entries.size()<LIMIT:entries.append({})
		result[hero]=entries
	return result
static func rows(saved:Dictionary,hero:String) -> Array:
	return saved.get('loadout_presets',{}).get(hero,[{},{},{}])
static func store(saved:Dictionary,hero:String,index:int) -> bool:
	if hero not in saved.collection.heroes or index<0 or index>=LIMIT:return false
	if not saved.has('loadout_presets'):saved.loadout_presets={}
	var entries=rows(saved,hero).duplicate(true);entries[index]=saved.collection.loadouts[hero].duplicate(true)
	saved.loadout_presets[hero]=entries;return true
static func apply(saved:Dictionary,hero:String,index:int) -> bool:
	if hero not in saved.collection.heroes or index<0 or index>=LIMIT:return false
	var entries=rows(saved,hero)
	if entries[index].is_empty():return false
	var verified=clean({hero:entries},saved.collection)
	if verified[hero][index]!=entries[index]:return false
	saved.collection.loadouts[hero]=entries[index].duplicate(true);return true
static func remove(saved:Dictionary,hero:String,index:int) -> bool:
	if hero not in saved.collection.heroes or index<0 or index>=LIMIT or rows(saved,hero)[index].is_empty():return false
	saved.loadout_presets[hero][index]={};return true
