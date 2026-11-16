extends RefCounted
const Records = preload('res://scripts/progression/run_records.gd')
# Schema 2 adds optional run records; schema 1 totals/settings migrate without attribution.
static func defaults() -> Dictionary:
	return {'version':2,'unlocked':['bruiser','sparky','shade'],'highest_wave':0,'games':0,'wins':0,'kills':0,'time':0.0,'settings':{'master':.8,'music':.35,'sfx':.8,'quality':'HIGH'},'records':Records.defaults(),'recent_runs':[]}
static func sidecar(path: String, suffix: String) -> String:
	return path.get_basename()+'.'+suffix+'.json'
static func backup(raw: String, path: String):
	var f=FileAccess.open(path,FileAccess.WRITE)
	if f:f.store_string(raw)
static func load_local(path: String = 'user://save.json') -> Dictionary:
	var result=defaults()
	if not FileAccess.file_exists(path):return result
	var raw=FileAccess.get_file_as_string(path)
	var parser=JSON.new()
	var valid=parser.parse(raw)==OK
	var data=parser.data if valid else null
	if not data is Dictionary or not (data.get('version')==1 or data.get('version')==2) or not data.get('settings') is Dictionary:
		backup(raw,sidecar(path,'corrupt'))
		return result
	if data.version==1 and not FileAccess.file_exists(sidecar(path,'v1.backup')):backup(raw,sidecar(path,'v1.backup'))
	for key in ['highest_wave','games','wins','kills','time']:
		var value=data.get(key)
		if (value is float or value is int) and is_finite(float(value)) and float(value)>=0:
			result[key]=float(value) if key=='time' else int(value)
	result.highest_wave=mini(result.highest_wave,10)
	for key in ['master','music','sfx']:
		var value=data.settings.get(key)
		if (value is float or value is int) and is_finite(float(value)):result.settings[key]=clampf(float(value),0,1)
	if data.settings.get('quality') in ['LOW','MEDIUM','HIGH']:result.settings.quality=data.settings.quality
	result.records=Records.sanitize_records(data.get('records'))
	result.recent_runs=Records.sanitize_history(data.get('recent_runs'))
	return result
static func save_local(data: Dictionary, path: String = 'user://save.json') -> Error:
	var temp=path+'.tmp'
	var f=FileAccess.open(temp,FileAccess.WRITE)
	if not f:return FileAccess.get_open_error()
	f.store_string(JSON.stringify(data))
	f.close()
	return DirAccess.rename_absolute(temp,path)
