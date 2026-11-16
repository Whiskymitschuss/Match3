extends RefCounted
const Arenas=preload('res://scripts/core/arena_catalog.gd')
const Records=preload('res://scripts/progression/run_records.gd')
static func defaults() -> Dictionary:
	var result={}
	for id in Arenas.IDS:result[id]={'runs':0,'highest_wave':0,'kills':0,'time':0.0}
	return result
static func sanitize(data) -> Dictionary:
	var result=defaults()
	if not data is Dictionary:return result
	for id in result:
		var entry=data.get(id)
		if not entry is Dictionary:continue
		for key in result[id]:result[id][key]=Records.number(entry.get(key)) if key=='time' else int(Records.number(entry.get(key)))
	return result
static func add(saved:Dictionary,arena:String,wave:int,kills:int,time:float):
	if not saved.has('endless_records'):saved.endless_records=defaults()
	var r=saved.endless_records[arena];r.runs+=1;r.highest_wave=maxi(r.highest_wave,wave);r.kills+=kills;r.time+=time
