extends RefCounted
const Records=preload('res://scripts/progression/run_records.gd')
const Data=preload('res://scripts/progression/recap_data.gd')
static func compatible(a:Dictionary,b:Dictionary) -> bool:
	return a.arena==b.arena and a.get('mode','campaign')==b.get('mode','campaign') and a.get('difficulty','normal')==b.get('difficulty','normal')
static func same_run(a:Dictionary,b:Dictionary) -> bool:
	return compatible(a,b) and a.character==b.character and a.time==b.time and a.get('analysis',{})==b.get('analysis',{}) and a.weapons==b.weapons
static func candidates(history:Array,reference:Dictionary) -> Array:
	var result=[];var skipped=false;var clean=Records.clean_run(reference)
	if clean.is_empty() or Data.clean(clean.get('analysis')).is_empty():return result
	for source in history.slice(0,20):
		var run=Records.clean_run(source)
		if run.is_empty() or Data.clean(run.get('analysis')).is_empty() or not compatible(clean,run):continue
		if not skipped and same_run(clean,run):skipped=true;continue
		result.append(run)
	return result
static func metrics(run:Dictionary) -> Dictionary:
	var data=Data.clean(run.get('analysis'))
	if data.is_empty():return {}
	var t=data.totals;var bosses=0
	for row in data.waves:
		if row.boss and row.outcome=='cleared':bosses+=1
	return {'seconds':float(t.seconds),'received':float(t.received),'dps':float(t.damage)/float(t.seconds) if t.seconds>0 else 0.0,'kills':int(t.kills),'coins':int(t.coins),'bosses':bosses,'omitted':int(data.omitted)}
