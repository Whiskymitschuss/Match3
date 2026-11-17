extends RefCounted
const Rewards=preload('res://scripts/progression/daily_rewards.gd')
const DifficultyRecords=preload('res://scripts/progression/difficulty_records.gd')
const Endless=preload('res://scripts/progression/endless_records.gd')
const Mastery = preload('res://scripts/progression/character_mastery.gd')
const Records = preload('res://scripts/progression/run_records.gd')
const Arenas = preload('res://scripts/core/arena_catalog.gd')
# Schema 3 adds arena attribution and cosmetic unlocks. Older runs were scrapyard-only.
static func defaults() -> Dictionary:
	return {'meta':Rewards.defaults(),'difficulty_records':DifficultyRecords.defaults(),'endless_records':Endless.defaults(),'hero_styles':{'bruiser':'classic','sparky':'classic','shade':'classic','twinkle':'classic','kicksy':'classic','steelfist':'classic'},'version':3,'unlocked':['bruiser','sparky','shade','twinkle','steelfist'],'highest_wave':0,'games':0,'wins':0,'kills':0,'time':0.0,'settings':{'master':.8,'music':.35,'sfx':.8,'quality':'HIGH','aura':'class','haptics':'OFF','damage_numbers':true,'splatter':true,'shop_help_seen':false,'tutorial_complete':false,'tilt':true,'reduced_motion':false},'records':Records.defaults(),'recent_runs':[],'arena_records':Records.arena_defaults(),'unlocked_arenas':['scrapyard'],'unlocked_styles':['class']}
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
	if not data is Dictionary or not (data.get('version')==1 or data.get('version')==2 or data.get('version')==3) or not data.get('settings') is Dictionary:
		backup(raw,sidecar(path,'corrupt'))
		return result
	if data.version<3:
		var suffix='v%d.backup' % int(data.version)
		if not FileAccess.file_exists(sidecar(path,suffix)):backup(raw,sidecar(path,suffix))
	for key in ['highest_wave','games','wins','kills','time']:
		var value=data.get(key)
		if (value is float or value is int) and is_finite(float(value)) and float(value)>=0:
			result[key]=float(value) if key=='time' else int(value)
	result.highest_wave=mini(result.highest_wave,10)
	for key in ['master','music','sfx']:
		var value=data.settings.get(key)
		if (value is float or value is int) and is_finite(float(value)):result.settings[key]=clampf(float(value),0,1)
	if data.settings.get('quality') in ['LOW','MEDIUM','HIGH']:result.settings.quality=data.settings.quality
	if data.settings.get('haptics') in ['OFF','LOW','HIGH']:result.settings.haptics=data.settings.haptics
	if data.settings.get('damage_numbers') is bool:result.settings.damage_numbers=data.settings.damage_numbers
	if data.settings.get('shop_help_seen') is bool:result.settings.shop_help_seen=data.settings.shop_help_seen
	if data.settings.get('splatter') is bool:result.settings.splatter=data.settings.splatter
	for key in ['tutorial_complete','tilt','reduced_motion']:
		if data.settings.get(key) is bool:result.settings[key]=data.settings[key]
	result.endless_records=Endless.sanitize(data.get('endless_records'))
	result.meta=Rewards.clean(data.get('meta'))
	result.records=Records.sanitize_records(data.get('records'))
	result.recent_runs=Records.sanitize_history(data.get('recent_runs'))
	result.arena_records=Records.sanitize_arenas(data.get('arena_records'))
	if data.version<3:
		for key in ['games','wins','kills','time','highest_wave']:result.arena_records.scrapyard[key]=result[key]
		result.arena_records.scrapyard.records=result.records.duplicate(true)
	for key in ['unlocked_arenas','unlocked_styles']:
		var ids=data.get(key)
		if ids is Array:
			for id in ids:
				if id in (Arenas.IDS if key=='unlocked_arenas' else ['class','gold','mayhem','reactor']) and not result[key].has(id):result[key].append(id)
	result.difficulty_records=DifficultyRecords.load_records(result,data.get('difficulty_records'))
	Arenas.sync(result)
	if result.unlocked_styles.has(data.settings.get('aura')):result.settings.aura=data.settings.aura
	preload('res://scripts/progression/hero_unlocks.gd').sync(result)
	result.hero_styles=Mastery.sanitize(result,data.get('hero_styles'))
	return result
static func save_local(data: Dictionary, path: String = 'user://save.json') -> Error:
	var temp=path+'.tmp'
	var f=FileAccess.open(temp,FileAccess.WRITE)
	if not f:return FileAccess.get_open_error()
	f.store_string(JSON.stringify(data))
	f.close()
	return DirAccess.rename_absolute(temp,path)
