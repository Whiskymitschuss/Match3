extends RefCounted
const Store=preload('res://scripts/autoload/local_store.gd')
static var last_load:Dictionary={}
const Checkpoint=preload('res://scripts/progression/run_checkpoint.gd')
const Worlds=preload('res://scripts/progression/world_progress.gd')
const Rewards=preload('res://scripts/progression/daily_rewards.gd')
const Collection=preload('res://scripts/progression/collection.gd')
const DifficultyRecords=preload('res://scripts/progression/difficulty_records.gd')
const Endless=preload('res://scripts/progression/endless_records.gd')
const Mastery = preload('res://scripts/progression/character_mastery.gd')
const Records = preload('res://scripts/progression/run_records.gd')
const Arenas = preload('res://scripts/core/arena_catalog.gd')
# Schema 3 adds arena attribution and cosmetic unlocks. Older runs were scrapyard-only.
static func defaults() -> Dictionary:
	return {'online_scores':preload('res://scripts/progression/online_scores.gd').defaults(),'loadout_presets':{},'active_run':{},'selection':{'character':'bruiser','arena':'scrapyard','difficulty':'normal','mode':'campaign'},'world_progress':Worlds.defaults(),'collection':Collection.defaults(),'meta':Rewards.defaults(),'difficulty_records':DifficultyRecords.defaults(),'endless_records':Endless.defaults(),'hero_styles':Mastery.style_defaults(),'version':3,'unlocked':['bruiser'],'highest_wave':0,'games':0,'wins':0,'kills':0,'time':0.0,'settings':{'master':.8,'music':.35,'sfx':.8,'quality':'HIGH','aura':'class','haptics':'OFF','damage_numbers':true,'splatter':true,'shop_help_seen':false,'tutorial_complete':false,'onboarding_seen':false,'arena_briefings':[],'tilt':true,'reduced_motion':false,'show_fps':false,'touch_layout':preload('res://scripts/mobile/touch_layout.gd').defaults()},'records':Records.defaults(),'recent_runs':[],'arena_records':Records.arena_defaults(),'unlocked_arenas':['scrapyard'],'unlocked_styles':['class']}
static func sidecar(path: String, suffix: String) -> String:
	return path.get_basename()+'.'+suffix+'.json'
static func backup(raw: String, path: String):
	var f=FileAccess.open(path,FileAccess.WRITE)
	if f:f.store_string(raw)
static func load_local(path: String = 'user://save.json') -> Dictionary:
	var loaded=Store.read(path,valid_file);last_load={'path':path,'status':loaded.status,'repair':loaded.repair}
	return sanitize(loaded.data,loaded.raw,path) if not loaded.data.is_empty() else defaults()
static func sanitize(data:Dictionary,raw:String='',path:String='') -> Dictionary:
	var result=defaults()
	if not valid_file(data):return result
	if data.version<3 and path!='':
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
	for key in ['tutorial_complete','onboarding_seen','tilt','reduced_motion','show_fps']:
		if data.settings.get(key) is bool:result.settings[key]=data.settings[key]
	if data.settings.get('arena_briefings') is Array:
		for id in ['reactor','docks','foundry','gardens','frost','storm','crystal','carnival','void']:
			if data.settings.arena_briefings.has(id):result.settings.arena_briefings.append(id)
	result.settings.touch_layout=preload('res://scripts/mobile/touch_layout.gd').clean(data.settings.get('touch_layout'))
	result.endless_records=Endless.sanitize(data.get('endless_records'))
	result.meta=Rewards.clean(data.get('meta'))
	result.collection=Collection.clean(data.get('collection'))
	if path!='' and not data.has('collection') and not FileAccess.file_exists(sidecar(path,'pre_garage')):backup(raw,sidecar(path,'pre_garage'))
	for id in result.meta.owned:
		if Collection.catalog().items.has(id):result.collection.levels[id]=1
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
	result.world_progress=Worlds.migrate(result,data.get('world_progress') if data.version==3 else null)
	if path!='' and not data.has('world_progress') and not FileAccess.file_exists(sidecar(path,'pre_world_map')):backup(raw,sidecar(path,'pre_world_map'))
	Arenas.sync(result)
	if result.unlocked_styles.has(data.settings.get('aura')):result.settings.aura=data.settings.aura
	preload('res://scripts/progression/hero_unlocks.gd').sync(result)
	result.hero_styles=Mastery.sanitize(result,data.get('hero_styles'))
	var selection=data.get('selection',{})
	if selection is Dictionary:
		if selection.get('character') in result.collection.heroes:result.selection.character=selection.character
		if Worlds.available(result,str(selection.get('arena',''))):result.selection.arena=selection.arena
		if selection.get('difficulty') in ['normal','veteran','mayhem']:result.selection.difficulty=selection.difficulty
		if selection.get('mode') in ['campaign','endless']:result.selection.mode=selection.mode
	result.online_scores=preload('res://scripts/progression/online_scores.gd').clean(data.get('online_scores'))
	result.loadout_presets=preload('res://scripts/progression/loadout_presets.gd').clean(data.get('loadout_presets'),result.collection)
	if Checkpoint.compatible(data.get('active_run'),result):result.active_run=data.active_run.duplicate(true)
	return result
static func valid_file(data:Dictionary) -> bool:return (data.get('version')==1 or data.get('version')==2 or data.get('version')==3) and data.get('settings') is Dictionary
static func save_local(data: Dictionary, path: String = 'user://save.json') -> Error:
	return Store.write(data,path,valid_file)
