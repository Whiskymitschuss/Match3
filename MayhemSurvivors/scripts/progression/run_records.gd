extends RefCounted
const Arenas = preload('res://scripts/core/arena_catalog.gd')
const Specs=preload('res://scripts/weapons/specializations.gd')
const CHARACTERS = ['bruiser','sparky','shade']
const WEAPONS = ['blaster','hammer','splitgun','arc','orbit']
const MAX_HISTORY = 20
static func character_defaults() -> Dictionary:
	return {'games':0,'wins':0,'kills':0,'coins':0,'time':0.0,'best_wave':0,'best_kills':0,'best_level':0,'best_damage':0.0,'longest_run':0.0,'fastest_victory':0.0}
static func defaults() -> Dictionary:
	var result={}
	for id in CHARACTERS:result[id]=character_defaults()
	return result
static func number(value, fallback: float = 0.0, maximum: float = 1000000000.0) -> float:
	if not (value is int or value is float) or not is_finite(float(value)):return fallback
	return clampf(float(value),0,maximum)
static func sanitize_records(data) -> Dictionary:
	var result=defaults()
	if not data is Dictionary:return result
	for id in CHARACTERS:
		var source=data.get(id)
		if not source is Dictionary:continue
		for key in result[id]:
			var value=number(source.get(key))
			result[id][key]=value if key in ['time','best_damage','longest_run','fastest_victory'] else int(value)
		result[id].best_wave=mini(10,result[id].best_wave)
		result[id].wins=mini(result[id].games,result[id].wins)
		result[id].best_level=mini(999,result[id].best_level)
		result[id].fastest_victory=minf(7200,result[id].fastest_victory)
	return result
static func clean_run(data) -> Dictionary:
	if not data is Dictionary or not CHARACTERS.has(data.get('character')):return {}
	if not Arenas.IDS.has(data.get('arena','scrapyard')):return {}
	var result={'arena':data.get('arena','scrapyard'),'character':data.character,'won':data.get('won',false)==true,'wave':clampi(int(number(data.get('wave'),1)),1,10),'time':number(data.get('time'),0,7200),'kills':int(number(data.get('kills'))),'level':clampi(int(number(data.get('level'),1)),1,999),'damage':number(data.get('damage')),'coins':int(number(data.get('coins'))),'weapons':[]}
	var weapons=data.get('weapons')
	if weapons is Array:
		for item in weapons:
			if not item is Dictionary or not WEAPONS.has(item.get('id')):continue
			var weapon={'id':item.id,'level':clampi(int(number(item.get('level'),1)),1,5)}
			if weapon.level==5 and Specs.valid(weapon.id,item.get('spec','')):weapon.spec=item.spec
			result.weapons.append(weapon)
			if result.weapons.size()==4:break
	return result
static func sanitize_history(data) -> Array:
	var result:Array=[]
	if not data is Array:return result
	for entry in data:
		var clean=clean_run(entry)
		if not clean.is_empty():result.append(clean)
		if result.size()>=MAX_HISTORY:break
	return result
static func add_run(saved: Dictionary, data: Dictionary) -> Array[String]:
	var run=clean_run(data)
	var improvements:Array[String]=[]
	if run.is_empty():return improvements
	if not saved.has('records'):saved.records=defaults()
	if not saved.has('recent_runs'):saved.recent_runs=[]
	if not saved.has('arena_records'):saved.arena_records=arena_defaults()
	var arena=saved.arena_records[run.arena]
	arena.games+=1
	arena.wins+=int(run.won)
	arena.kills+=run.kills
	arena.time+=run.time
	arena.highest_wave=maxi(arena.highest_wave,run.wave)
	for record in [saved.records[run.character],arena.records[run.character]]:
		record.games+=1
		record.wins+=int(run.won)
		record.kills+=run.kills
		record.coins+=run.coins
		record.time+=run.time
		for pair in [['best_wave','wave'],['best_kills','kills'],['best_level','level'],['best_damage','damage']]:
				if run[pair[1]]>record[pair[0]]:
						record[pair[0]]=run[pair[1]]
						improvements.append(pair[0])
		record.longest_run=maxf(record.longest_run,run.time)
		if run.won and run.time>0 and (record.fastest_victory<=0 or run.time<record.fastest_victory):
				record.fastest_victory=run.time
				improvements.append('fastest_victory')
	saved.recent_runs.push_front(run)
	if saved.recent_runs.size()>MAX_HISTORY:saved.recent_runs.resize(MAX_HISTORY)
	return improvements
static func aggregate(records: Dictionary) -> Dictionary:
	var result=character_defaults()
	for id in CHARACTERS:
		var record=records[id]
		for key in ['best_wave','best_kills','best_level','best_damage','longest_run']:result[key]=maxf(result[key],record[key])
		if record.fastest_victory>0 and (result.fastest_victory<=0 or record.fastest_victory<result.fastest_victory):result.fastest_victory=record.fastest_victory
	return result

static func arena_defaults() -> Dictionary:
	var result={}
	for id in Arenas.IDS:result[id]={'games':0,'wins':0,'kills':0,'time':0.0,'highest_wave':0,'records':defaults()}
	return result
static func sanitize_arenas(data) -> Dictionary:
	var result=arena_defaults()
	if not data is Dictionary:return result
	for id in Arenas.IDS:
		var source=data.get(id)
		if not source is Dictionary:continue
		for key in ['games','wins','kills','highest_wave']:result[id][key]=int(number(source.get(key)))
		result[id].wins=mini(result[id].wins,result[id].games)
		result[id].highest_wave=mini(10,result[id].highest_wave)
		result[id].time=number(source.get('time'))
		result[id].records=sanitize_records(source.get('records'))
	return result
