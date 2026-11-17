extends RefCounted
# Profile-wide, once per arena across all campaign difficulties. No combat/case RNG.
const ORDER=['scrapyard','reactor','docks','foundry']
const MAX_VALUE=1000000000
static var cache:Dictionary={}
static func rewards() -> Dictionary:
	if cache.is_empty():cache=JSON.parse_string(FileAccess.get_file_as_string('res://data/arenas/world_progress.json'))
	return cache
static func defaults() -> Dictionary:return {'version':1,'unlocked':['scrapyard'],'cleared':[],'claimed':[]}
static func valid_list(value) -> Array:
	var result=[]
	if value is Array:
		for id in ORDER:
			if value.has(id):result.append(id)
	return result
static func positive(value) -> bool:
	return (value is int or value is float) and is_finite(float(value)) and value>0
static func historical_win(saved:Dictionary,id:String) -> bool:
	var arenas=saved.get('arena_records',{})
	if arenas is Dictionary and arenas.get(id) is Dictionary and positive(arenas[id].get('wins')):return true
	var difficulties=saved.get('difficulty_records',{})
	if difficulties is Dictionary:
		for key in ['normal','veteran','mayhem']:
			var d=difficulties.get(key,{})
			if not d is Dictionary or not d.get('campaign') is Dictionary:continue
			var record=d.campaign.get(id,{})
			if record is Dictionary and positive(record.get('wins')):return true
	return false
static func visited(saved:Dictionary,id:String) -> bool:
	for pair in [['arena_records','games'],['endless_records','runs']]:
		var records=saved.get(pair[0],{})
		if records is Dictionary and records.get(id) is Dictionary and positive(records[id].get(pair[1])):return true
	var difficulties=saved.get('difficulty_records',{})
	if difficulties is Dictionary:
		for d in difficulties.values():
			if not d is Dictionary:continue
			for mode in ['campaign','endless']:
				if d.get(mode) is Dictionary and d[mode].get(id) is Dictionary and positive(d[mode][id].get('runs')):return true
	return false
static func migrate(saved:Dictionary,source) -> Dictionary:
	var result=defaults()
	var modern=source is Dictionary and source.get('version')==1
	if modern:
		result.unlocked=valid_list(source.get('unlocked'))
		result.cleared=valid_list(source.get('cleared'))
		result.claimed=valid_list(source.get('claimed'))
	else:
		# Keep explicit unlocks and every actually visited world; unused worlds follow the route.
		for id in valid_list(saved.get('unlocked_arenas')):
			if not result.unlocked.has(id):result.unlocked.append(id)
		if positive(saved.get('wins')) and not result.unlocked.has('reactor'):result.unlocked.append('reactor')
	for id in ORDER:
		if visited(saved,id) and not result.unlocked.has(id):result.unlocked.append(id)
		if historical_win(saved,id) and not result.cleared.has(id):result.cleared.append(id)
	if not modern and result.cleared.is_empty() and positive(saved.get('wins')):result.cleared.append('scrapyard')
	if not result.unlocked.has('scrapyard'):result.unlocked.push_front('scrapyard')
	for id in result.cleared:
		for opened in [id,next_world(id)]:
			if opened!='' and not result.unlocked.has(opened):result.unlocked.append(opened)
	result.claimed=result.claimed.filter(func(id):return result.cleared.has(id))
	return result
static func available(saved:Dictionary,id:String) -> bool:
	if not ORDER.has(id):return false
	var progress=saved.get('world_progress')
	if not progress is Dictionary:return migrate(saved,null).unlocked.has(id)
	return id=='scrapyard' or valid_list(progress.get('unlocked')).has(id)
static func next_world(id:String) -> String:
	var i=ORDER.find(id)
	return ORDER[i+1] if i>=0 and i<ORDER.size()-1 else ''
static func previous_world(id:String) -> String:
	var i=ORDER.find(id)
	return ORDER[i-1] if i>0 else ''
static func sync(saved:Dictionary) -> Array[String]:
	if not saved.get('world_progress') is Dictionary:saved.world_progress=migrate(saved,null)
	var added:Array[String]=[];var progress=saved.world_progress
	if not progress.unlocked.has('scrapyard'):progress.unlocked.push_front('scrapyard')
	for id in progress.cleared:
		for opened in [id,next_world(id)]:
			if opened!='' and not progress.unlocked.has(opened):progress.unlocked.append(opened);added.append(opened)
	saved.unlocked_arenas=progress.unlocked.duplicate()
	return added
static func complete(saved:Dictionary,id:String,mode:String,won:bool,wave:int) -> bool:
	if mode!='campaign' or not won or wave!=10 or not available(saved,id):return false
	sync(saved)
	if saved.world_progress.cleared.has(id):return false
	saved.world_progress.cleared.append(id)
	sync(saved)
	return true
static func eligible(saved:Dictionary,id:String) -> bool:
	var p=saved.get('world_progress',{})
	return ORDER.has(id) and p is Dictionary and valid_list(p.get('cleared')).has(id) and not valid_list(p.get('claimed')).has(id)
static func claim(saved:Dictionary,id:String) -> bool:
	if not eligible(saved,id):return false
	var r=rewards()[id];var state=saved.collection
	if saved.meta.coins>MAX_VALUE-int(r.coins) or saved.meta.earned>MAX_VALUE-int(r.coins) or state.parts>MAX_VALUE-int(r.parts):return false
	for key in r.tickets:
		if state.tickets[key]>MAX_VALUE-int(r.tickets[key]):return false
	saved.meta.coins+=int(r.coins);saved.meta.earned+=int(r.coins);state.parts+=int(r.parts)
	for key in r.tickets:state.tickets[key]+=int(r.tickets[key])
	saved.world_progress.claimed.append(id)
	return true
static func reward_text(id:String) -> String:
	if not ORDER.has(id):return ''
	var r=rewards()[id];var result='%d Studio-Coins + %d Teile' % [r.coins,r.parts]
	for key in r.tickets:result+=' + %d %s-Case' % [r.tickets[key],{'crew':'Crew','arsenal':'Arsenal','style':'Style'}[key]]
	return result
