extends RefCounted
const D=preload('res://scripts/gameplay/difficulty.gd')
const A=preload('res://scripts/core/arena_catalog.gd')
const R=preload('res://scripts/progression/run_records.gd')
static func defaults() -> Dictionary:
	var result={}
	for id in D.IDS:
		result[id]={}
		for mode in ['campaign','endless']:
			result[id][mode]={}
			for arena in A.IDS:result[id][mode][arena]={'runs':0,'wins':0,'highest_wave':0,'kills':0,'time':0.0,'fastest_victory':0.0}
	return result
static func load_records(saved:Dictionary,source) -> Dictionary:
	var result=defaults()
	if not source is Dictionary:
		for arena in A.IDS:
			var c=saved.arena_records[arena];var e=saved.endless_records[arena]
			result.normal.campaign[arena].merge({'runs':c.games,'wins':c.wins,'highest_wave':c.highest_wave,'kills':c.kills,'time':c.time,'fastest_victory':R.aggregate(c.records).fastest_victory},true)
			result.normal.endless[arena].merge(e,true)
		return result
	for id in D.IDS:
		if not source.get(id) is Dictionary:continue
		for mode in ['campaign','endless']:
			if not source[id].get(mode) is Dictionary:continue
			for arena in A.IDS:
				var entry=source[id][mode].get(arena)
				if not entry is Dictionary:continue
				var r=result[id][mode][arena]
				for key in r:r[key]=R.number(entry.get(key)) if key in ['time','fastest_victory'] else int(R.number(entry.get(key)))
				r.wins=mini(r.runs,r.wins) if mode=='campaign' else 0
				if mode=='campaign':r.highest_wave=mini(10,r.highest_wave)
	return result
static func add(saved:Dictionary,id:String,mode:String,arena:String,wave:int,kills:int,time:float,won:bool) -> bool:
	if not id in D.IDS or not mode in ['campaign','endless'] or not arena in A.IDS:return false
	if not saved.has('difficulty_records'):saved.difficulty_records=load_records(saved,null)
	var r=saved.difficulty_records[id][mode][arena];var best=wave>r.highest_wave
	r.runs+=1;r.wins+=int(won and mode=='campaign');r.highest_wave=maxi(r.highest_wave,wave);r.kills+=kills;r.time+=time
	if won and mode=='campaign' and time>0 and (r.fastest_victory<=0 or time<r.fastest_victory):r.fastest_victory=time;best=true
	return best
