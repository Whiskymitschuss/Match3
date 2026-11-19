extends RefCounted
# Optional bounded analysis. Old runs remain valid without inventing measurements.
const MAX_WAVES=50
const KEYS=['seconds','kills','damage','received','hits','coins','abilities','procs','combo_damage']
const INTEGER_KEYS=['kills','hits','coins','abilities','procs']
const OUTCOMES=['cleared','defeat','timeout','abandoned','interrupted']
static func value(v,cap:float=1000000000.0) -> float:
	return clampf(float(v),0,cap) if (v is int or v is float) and is_finite(float(v)) else 0.0
static func empty_totals() -> Dictionary:
	var result={}
	for key in KEYS:result[key]=0
	return result
static func clean(data) -> Dictionary:
	if not data is Dictionary or data.get('version')!=1 or not data.get('waves') is Array:return {}
	var rows=[];var last=0
	for entry in data.waves:
		if not entry is Dictionary or not (entry.get('wave') is int or entry.get('wave') is float):continue
		var wave=int(value(entry.wave,1000000))
		if wave<=last or not entry.get('outcome') in OUTCOMES:continue
		var row={'wave':wave,'boss':entry.get('boss',false)==true,'outcome':entry.outcome,'boss_name':''}
		if row.boss and entry.get('boss_name') is String:row.boss_name=entry.boss_name.replace('\n',' ').replace('\r',' ').replace('\t',' ').substr(0,48)
		for key in KEYS:
			var n=value(entry.get(key),3600 if key=='seconds' else 1000000000.0)
			row[key]=int(n) if key in INTEGER_KEYS else n
		row.combo_damage=minf(row.damage,row.combo_damage);last=wave;rows.append(row)
	if rows.is_empty():return {}
	var omitted=int(value(data.get('omitted'),1000000))+maxi(0,rows.size()-MAX_WAVES)
	if rows.size()>MAX_WAVES:rows=rows.slice(rows.size()-MAX_WAVES)
	var totals=empty_totals()
	for row in rows:
		for key in KEYS:totals[key]+=row[key]
	if omitted>0 and data.get('totals') is Dictionary:
		for key in KEYS:totals[key]=maxf(totals[key],value(data.totals.get(key)))
	totals.combo_damage=minf(totals.damage,totals.combo_damage)
	return {'version':1,'waves':rows,'totals':totals,'omitted':omitted}
