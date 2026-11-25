extends RefCounted
const Roster=preload('res://scripts/core/roster.gd')
# Persistent collection model. Case RNG is independent from combat RNG.
const HEROES=Roster.HEROES
const STARTERS=Roster.STARTERS
const ALLOWED=Roster.ALLOWED
const SLOTS=['head','body','feet','weapon','item','spell','skin']
static var cache:Dictionary={}
static func catalog() -> Dictionary:
	if cache.is_empty():cache=JSON.parse_string(FileAccess.get_file_as_string('res://data/collection/catalog.json'))
	return cache
static func number(value,fallback:int=0,maximum:int=1000000000) -> int:
	if not (value is int or value is float) or not is_finite(float(value)):return fallback
	return clampi(int(value),0,maximum)
static func empty_loadout(hero:String) -> Dictionary:return {'head':'','body':'','feet':'','weapon':STARTERS[hero],'item':'','spell':'','skin':''}
static func defaults() -> Dictionary:
	var loadouts={}
	for hero in HEROES:loadouts[hero]=empty_loadout(hero)
	return {'version':1,'heroes':['bruiser'],'levels':{'hammer':1},'loadouts':loadouts,'parts':0,'tickets':{'crew':1,'arsenal':1,'style':1},'pity':0,'opened':0,'seed':maxi(1,int(Time.get_unix_time_from_system()*1000+Time.get_ticks_usec())%2147483646),'history':[],'pending':{}}
static func clean(source) -> Dictionary:
	var result=defaults()
	if not source is Dictionary:return result
	for key in ['parts','opened']:result[key]=number(source.get(key))
	result.seed=maxi(1,number(source.get('seed'),result.seed,2147483646));result.pity=number(source.get('pity'),0,2)
	if source.get('heroes') is Array:
		for id in HEROES:
			if source.heroes.has(id) and not result.heroes.has(id):result.heroes.append(id)
	if source.get('levels') is Dictionary:
		for id in catalog().items:
			var rank=number(source.levels.get(id),0,5)
			if rank>0:result.levels[id]=rank if catalog().items[id].ranked else 1
	for hero in result.heroes:result.levels[STARTERS[hero]]=maxi(1,int(result.levels.get(STARTERS[hero],1)))
	if source.get('tickets') is Dictionary:
		for id in result.tickets:result.tickets[id]=number(source.tickets.get(id))
	if source.get('loadouts') is Dictionary:
		for hero in HEROES:
			var loadout=source.loadouts.get(hero)
			if not loadout is Dictionary:continue
			for slot in SLOTS:
				var id=loadout.get(slot)
				if id=='' and slot!='weapon':result.loadouts[hero][slot]='';continue
				if id is String and result.levels.has(id) and catalog().items[id].slot==slot and (slot!='weapon' or ALLOWED[hero].has(id)):result.loadouts[hero][slot]=id
	var entries=source.get('history',[])
	if entries is Array:
		for entry in entries:
			var receipt=clean_receipt(entry)
			if not receipt.is_empty():result.history.append(receipt)
			if result.history.size()>=20:break
	result.pending=clean_receipt(source.get('pending'))
	return result
static func clean_receipt(data) -> Dictionary:
	if not data is Dictionary or not catalog().cases.has(data.get('case')):return {}
	var id=data.get('id');var hero=data.get('hero',false)==true
	if not id is String or not (catalog().heroes.has(id) if hero else catalog().items.has(id)):return {}
	return {'id':id,'case':data.case,'hero':hero,'duplicate':data.get('duplicate',false)==true,'parts':number(data.get('parts'),0,100),'serial':number(data.get('serial'))}
static func candidates(saved:Dictionary,case_id:String) -> Array:
	var result:Array=[];var state=saved.collection;var source=catalog().heroes if case_id=='crew' else catalog().items
	var missing=false
	for id in catalog().heroes:
		if not state.heroes.has(id):missing=true
	for id in source:
		if case_id!='crew' and source[id].case!=case_id:continue
		if case_id=='crew' and state.pity>=2 and missing and state.heroes.has(id):continue
		result.append({'id':id,'weight':float(source[id].weight)})
	var sum=0.0
	for item in result:sum+=item.weight
	for item in result:item.chance=item.weight/sum if sum>0 else 0.0
	return result
static func open_case(saved:Dictionary,case_id:String) -> Dictionary:
	if not catalog().cases.has(case_id) or not saved.collection.pending.is_empty():return {}
	var state=saved.collection;var ticket=int(state.tickets[case_id])>0;var price=int(catalog().cases[case_id].price)
	if not ticket and saved.meta.coins<price:return {}
	var pool=candidates(saved,case_id)
	if pool.is_empty():return {}
	var rng=RandomNumberGenerator.new();rng.seed=state.seed;var roll=rng.randf();var picked=pool.back().id
	for entry in pool:
		roll-=entry.chance
		if roll<=0:picked=entry.id;break
	var hero=case_id=='crew';var duplicate=state.heroes.has(picked) if hero else (state.levels.has(picked) or saved.meta.owned.has(picked))
	var definition=catalog().heroes[picked] if hero else catalog().items[picked]
	var parts=int({'STANDARD':20,'SELTEN':35,'EPISCH':60}.get(definition.rarity,35)) if duplicate else 0
	if ticket:state.tickets[case_id]-=1
	else:saved.meta.coins-=price
	if duplicate:state.parts=mini(1000000000,state.parts+parts)
	elif hero:state.heroes.append(picked);state.levels[STARTERS[picked]]=maxi(1,int(state.levels.get(STARTERS[picked],1)))
	else:
		state.levels[picked]=1
		if definition.slot=='deco' and not saved.meta.owned.has(picked):saved.meta.owned.append(picked)
	if hero:state.pity=mini(2,state.pity+1) if duplicate else 0
	state.seed=rng.randi_range(1,2147483646);state.opened+=1
	var receipt={'id':picked,'case':case_id,'hero':hero,'duplicate':duplicate,'parts':parts,'serial':state.opened}
	state.pending=receipt.duplicate(true);state.history.push_front(receipt.duplicate(true))
	if state.history.size()>20:state.history.resize(20)
	saved.unlocked=state.heroes.duplicate()
	return receipt
static func acknowledge(saved:Dictionary,serial:int) -> bool:
	if saved.collection.pending.is_empty() or int(saved.collection.pending.serial)!=serial:return false
	saved.collection.pending.clear();return true
static func upgrade(saved:Dictionary,id:String) -> bool:
	if not catalog().items.has(id) or not saved.collection.levels.has(id) or not catalog().items[id].ranked:return false
	var rank=int(saved.collection.levels[id])
	if rank>=5:return false
	var cost=int(catalog().upgrade_costs[rank-1])
	if saved.collection.parts<cost:return false
	saved.collection.parts-=cost;saved.collection.levels[id]=rank+1;return true
static func equip(saved:Dictionary,hero:String,id:String) -> bool:
	if not HEROES.has(hero) or not saved.collection.heroes.has(hero) or not saved.collection.levels.has(id) or not catalog().items.has(id):return false
	var slot:String=catalog().items[id].slot
	if slot=='deco':
		if not saved.meta.owned.has(id):return false
		saved.meta.equipped[catalog().items[id].group]=id;return true
	if slot=='weapon' and not ALLOWED[hero].has(id):return false
	saved.collection.loadouts[hero][slot]=id;return true
static func starter(saved:Dictionary,hero:String) -> String:
	var id:String=saved.collection.loadouts[hero].weapon
	return id if saved.collection.levels.has(id) and ALLOWED[hero].has(id) else STARTERS[hero]
static func snapshot(saved:Dictionary,hero:String) -> Dictionary:
	var result={'hp':0.0,'armor':0.0,'speed':0.0,'magnet':0.0,'weapon_bonus':{},'spell':'','spell_rank':0,'skin':''}
	var loadout=saved.collection.loadouts[hero]
	for slot in ['head','body','feet','item']:
		var id:String=loadout[slot]
		if not saved.collection.levels.has(id):continue
		var definition=catalog().items[id]
		for key in definition.get('mods',{}):result[key]+=float(definition.mods[key])*int(saved.collection.levels[id])
	for id in ALLOWED[hero]:result.weapon_bonus[id]=.02*maxi(0,int(saved.collection.levels.get(id,1))-1)
	result.spell=loadout.spell;result.spell_rank=int(saved.collection.levels.get(loadout.spell,0));result.skin=loadout.skin
	return result
static func run_reward(saved:Dictionary,mode:String,waves:int,kills:int,won:bool) -> int:
	if mode=='tutorial':return 0
	var coins=int(reward_breakdown(mode,waves,kills,won).total)
	saved.meta.coins=mini(1000000000,saved.meta.coins+coins);saved.meta.earned=mini(1000000000,saved.meta.earned+coins);return coins
static func reward_breakdown(mode:String,waves:int,kills:int,won:bool) -> Dictionary:
	var result={'waves':0,'kills':0,'victory':0,'total':0}
	if mode=='tutorial':return result
	result.waves=clampi(waves*5,0,500)
	result.kills=mini(500-result.waves,mini(10,maxi(0,kills)/50))
	result.victory=mini(500-result.waves-result.kills,20 if won and mode=='campaign' else 0)
	result.total=result.waves+result.kills+result.victory
	return result
