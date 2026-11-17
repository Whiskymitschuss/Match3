extends RefCounted
const IDS=['comet','circuit','flame','mini_bot','bomb_buddy','chaos_title']
static func definition() -> Dictionary:return JSON.parse_string(FileAccess.get_file_as_string('res://data/meta/rewards.json'))
static func period(key:int) -> Dictionary:return {'key':key,'kills':0,'waves':0,'skills':0,'wins':0,'arenas':[],'claimed':[]}
static func defaults(now:int=-1) -> Dictionary:
	var day=int(Time.get_unix_time_from_system()/86400) if now<0 else int(now/86400)
	return {'version':1,'coins':0,'earned':0,'owned':[],'equipped':{'ring':'','buddy':'','title':''},'daily':period(day),'weekly':period(floori((day+3)/7.0)),'pass':{'cycle':1,'xp':0,'claimed':[]}}
static func clean(data,now:int=-1) -> Dictionary:
	var result=defaults(now)
	if not data is Dictionary:return result
	for key in ['coins','earned']:result[key]=integer(data.get(key))
	if data.get('owned') is Array:
		for id in data.owned:
			if id in IDS and not result.owned.has(id):result.owned.append(id)
	var catalog=definition().shop
	if data.get('equipped') is Dictionary:
		for item in catalog:
			if data.equipped.get(item.group)==item.id and result.owned.has(item.id):result.equipped[item.group]=item.id
	for scope in ['daily','weekly']:
		var source=data.get(scope)
		if not source is Dictionary or integer(source.get('key'),-999)!=result[scope].key:continue
		for key in ['kills','waves','skills','wins']:result[scope][key]=integer(source.get(key))
		if source.get('arenas') is Array:
			for id in source.arenas:
				if id in ['scrapyard','reactor','docks','foundry'] and not result[scope].arenas.has(id):result[scope].arenas.append(id)
		if source.get('claimed') is Array:
			for task in definition()[scope]:
				if source.claimed.has(task.id):result[scope].claimed.append(task.id)
	var pass_data=data.get('pass')
	if pass_data is Dictionary:
		result.pass.cycle=maxi(1,integer(pass_data.get('cycle'),1));result.pass.xp=integer(pass_data.get('xp'))
		if pass_data.get('claimed') is Array:
			for i in range(7):
				if pass_data.claimed.has(i) or pass_data.claimed.has(float(i)):result.pass.claimed.append(i)
	return result
static func integer(value,fallback:int=0) -> int:
	if not (value is int or value is float) or not is_finite(float(value)):return fallback
	return clampi(int(value),0,1000000000)
static func refresh(meta:Dictionary,now:int=-1):
	var current=defaults(now)
	for key in ['daily','weekly']:
		if meta[key].key!=current[key].key:meta[key]=current[key]
static func record(meta:Dictionary,run:Dictionary,now:int=-1):
	if run.get('mode')=='tutorial':return
	refresh(meta,now)
	for key in ['daily','weekly']:
		var progress=meta[key]
		for stat in ['kills','waves','skills']:progress[stat]=mini(1000000000,progress[stat]+integer(run.get(stat)))
		progress.wins+=int(run.get('won',false) and run.get('mode')=='campaign')
		if integer(run.get('waves'))>0 and run.get('arena') in ['scrapyard','reactor','docks','foundry'] and not progress.arenas.has(run.arena):progress.arenas.append(run.arena)
static func value(meta:Dictionary,scope:String,task:Dictionary) -> int:
	return meta[scope].arenas.size() if task.stat=='arenas' else int(meta[scope].get(task.stat,0))
static func claim(meta:Dictionary,scope:String,id:String,now:int=-1) -> bool:
	if not scope in ['daily','weekly']:return false
	refresh(meta,now)
	for task in definition()[scope]:
		if task.id!=id:continue
		if meta[scope].claimed.has(id) or value(meta,scope,task)<task.target:return false
		meta[scope].claimed.append(id);meta.coins=mini(1000000000,meta.coins+int(task.coins));meta.earned=mini(1000000000,meta.earned+int(task.coins));meta.pass.xp=mini(1000000000,meta.pass.xp+int(task.xp));return true
	return false
static func claim_pass(meta:Dictionary,index:int) -> bool:
	if index<0 or index>=7 or meta.pass.claimed.has(index) or meta.pass.xp<(index+1)*100:return false
	meta.pass.claimed.append(index);var coins=int(definition().pass_rewards[index]);meta.coins=mini(1000000000,meta.coins+coins);meta.earned=mini(1000000000,meta.earned+coins);return true
static func renew_pass(meta:Dictionary) -> bool:
	if meta.pass.claimed.size()!=7:return false
	meta.pass={'cycle':meta.pass.cycle+1,'xp':maxi(0,meta.pass.xp-700),'claimed':[]};return true
static func buy(meta:Dictionary,id:String) -> bool:
	for item in definition().shop:
		if item.id!=id:continue
		if meta.owned.has(id) or meta.coins<int(item.price):return false
		meta.coins-=int(item.price);meta.owned.append(id);meta.equipped[item.group]=id;return true
	return false
static func equip(meta:Dictionary,id:String) -> bool:
	if not meta.owned.has(id):return false
	for item in definition().shop:
		if item.id==id:meta.equipped[item.group]=id;return true
	return false
