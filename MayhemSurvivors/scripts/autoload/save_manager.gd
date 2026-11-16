extends RefCounted
# Versioned, atomic local persistence. Never trust parsed JSON types or ranges.
static func defaults() -> Dictionary:
	return {'version':1,'unlocked':['bruiser','sparky','shade'],'highest_wave':0,'games':0,'wins':0,'kills':0,'time':0.0,'settings':{'master':.8,'music':.35,'sfx':.8,'quality':'HIGH'}}

static func load_local() -> Dictionary:
	var result = defaults()
	if not FileAccess.file_exists('user://save.json'): return result
	var raw = FileAccess.get_file_as_string('user://save.json')
	var parser = JSON.new()
	var valid = parser.parse(raw)==OK
	var data = parser.data if valid else null
	if not data is Dictionary or data.get('version')!=1 or not data.get('settings') is Dictionary:
		var backup = FileAccess.open('user://save.corrupt.json',FileAccess.WRITE)
		if backup: backup.store_string(raw)
		return result
	for key in ['highest_wave','games','wins','kills','time']:
		var value = data.get(key)
		if (value is float or value is int) and is_finite(float(value)) and float(value)>=0:
			result[key] = float(value) if key=='time' else int(value)
	result.highest_wave = mini(result.highest_wave,10)
	for key in ['master','music','sfx']:
		var value = data.settings.get(key)
		if (value is float or value is int) and is_finite(float(value)): result.settings[key]=clampf(float(value),0,1)
	if data.settings.get('quality') in ['LOW','MEDIUM','HIGH']: result.settings.quality=data.settings.quality
	return result

static func save_local(data: Dictionary) -> Error:
	var f = FileAccess.open('user://save.tmp',FileAccess.WRITE)
	if not f: return FileAccess.get_open_error()
	f.store_string(JSON.stringify(data))
	f.close()
	return DirAccess.rename_absolute('user://save.tmp','user://save.json')
