extends RefCounted
const Graph=preload('res://scripts/progression/variant_graph.gd')
static var last_error=''
static var definitions:Dictionary={}
const Roster=preload('res://scripts/core/roster.gd')
const CORE=['spawn_serial','run_mode','run_difficulty','selected','arena_id','run_gear','run_loadout','hp','max_hp','speed','damage_mult','attack_mult','crit','armor','magnet','projectile_speed','multishot','level','xp','coins','earned','kills','dealt','run_time','wave_number','remaining','spawn_cycle','spawn_clock','hurt_clock','orbit_angle','animation_clock','facing','axel_shop_pending','boss_clock','boss_phase','boss_charging','boss_target','boss_warning','rerolls','offers','upgrade_counts','run_waves','run_abilities','run_events','studio_reward','enemies','loot','weapons','level_choices']
const MODULES={
 'rules':['progressive'],
 'run_items':['owned','applied'],
 'recap':['rows','current','baseline','totals','omitted'],
 'crew':['cloud','drone_left','drone_clock','heal_clock','drone_phase','sonic_flash','shield','shield_left'],
 'synergies':['armed','cooldown','procs'],
 'united':['enabled'],
 'united.heroes':['fire_fields','fire_clock','burn_tick','overcharge','shield','shield_time','invulnerability','decoy_time','decoy'],
 'united.enemies':['counts','hazards','slow_time'],
 'united.bosses':['stage','clock','tier','pattern','attack','origin','target','hit'],
 'hero_ability':['cooldown','grenade','dash','rings','afterimages','activations'],
 'equipped_spell':['id','rank','cooldown','invulnerability'],
 'twinkle':['puddles','sweeps','tornado_left','tornado_age','tick_clock'],
 'steelfist':['attacks','regen_clock','buff_left','buff_extension','sweeps','pressure'],
 'bombs':['pool','queued','fields','burn_clock'],
 'arena_hazards':['items','clock','pattern'],
 'arena_events':['enabled','active','triggered','age','pulse'],
 'scrapyard_salvage':['phase','position','held','age','pulses','completed','total_coins'],
 'arena_mechanics':['enabled','hazards','cores','charge','killed_for_cores','dropped','terminal','stage','held','drop_index','groups','serial','total_coins','arena_kills','maneuvers'],
 'arena_mechanics.valves':['stations'],
 'arena_mechanics.worlds':['nodes','hazards','stage','step','held','kills','warmth_left','warmth_at'],
 'encounters':['enabled','promoted','run_serial','elite_kills','rewards','hazards','boss_tier','special_clock','recovery','boss_lock','special_number','first_special','notice','notice_time'],
 'reactor_guardian':['stage','clock','pattern','burst','origin','angle'],
 'breaker':['enabled','stage','attack','clock','tier','pattern','origin','target','direction','beats','dash_hit','combo','rings','cracks','stagger_left','slow_left','push_velocity'],
 'ravox':['spawned','enabled'],
 'enemy_pack':['enabled'],
 'enemy_roles':['drones']
}
static func module(game:Node,path:String):
	var result=game
	for part in path.split('.'):result=result.get(part)
	return result
static func gather(game:Node,owner:String,run_id:String) -> Dictionary:
	var core={};var modules={}
	for key in CORE:core[key]=game.get(key)
	for path in MODULES:
		var object=module(game,path);var fields={}
		for key in MODULES[path]:fields[key]=object.get(key)
		modules[path]=fields
	var phase={game.State.COMBAT:'combat',game.State.PAUSED:'combat',game.State.LEVEL_UP:'level',game.State.SHOP:'shop',game.State.WAVE_PREPARATION:'preparation'}.get(game.state,'')
	if phase=='' or game.run_mode=='tutorial' or game.result_recorded:return {}
	var raw={'core':core,'modules':modules,'shots':game.shots.map(func(s):return s if s.active else {'active':false,'hit_enemies':[]}),'player':{'position':game.player.position,'velocity':game.player.velocity},'rng':{'seed':str(game.rng.seed),'state':str(game.rng.state)}}
	var envelope={'version':1,'ruleset':1,'owner':owner,'run_id':run_id,'phase':phase,'saved_at':int(Time.get_unix_time_from_system()),'summary':{'hero':game.characters[game.selected].id,'arena':game.arena_id,'mode':game.run_mode,'wave':game.wave_number,'level':game.level,'time':game.run_time}}
	return {'raw':raw,'envelope':envelope}
static func capture(game:Node,owner:String,run_id:String) -> Dictionary:
	var packet=gather(game,owner,run_id)
	return encode(packet) if not packet.is_empty() else {}
static func encode(packet:Dictionary) -> Dictionary:
	var codec=Graph.new();var graph=codec.pack(packet.raw,true)
	if graph.is_empty():return {}
	var payload=JSON.stringify(graph)
	var envelope:Dictionary=packet.envelope.duplicate(true);envelope.payload=payload;envelope.sha256=payload.sha256_text()
	return envelope
static func unpack(data) -> Dictionary:
	if not data is Dictionary or data.get('version')!=1 or data.get('ruleset')!=1 or not data.get('owner') is String or not data.get('run_id') is String or data.run_id.length()<8 or data.get('phase') not in ['combat','level','shop','preparation'] or not data.get('payload') is String or data.payload.length()>6*1024*1024 or data.get('sha256')!=data.payload.sha256_text():return {}
	var parser=JSON.new()
	if parser.parse(data.payload)!=OK:return {}
	var codec=Graph.new();var decoded=codec.unpack(parser.data)
	if decoded.is_empty() or not decoded.value is Dictionary:return {}
	var d:Dictionary=decoded.value
	if not d.get('core') is Dictionary or not d.get('modules') is Dictionary or not d.get('shots') is Array or not d.get('player') is Dictionary or not d.get('rng') is Dictionary:return {}
	var c=d.core
	if c.size()!=CORE.size() or d.modules.size()!=MODULES.size():return {}
	for key in CORE:
		if not c.has(key):return {}
	for path in MODULES:
		if not d.modules.get(path) is Dictionary or d.modules[path].size()!=MODULES[path].size():return {}
		for key in MODULES[path]:
			if not d.modules[path].has(key):return {}
	if c.run_mode not in ['campaign','endless'] or c.run_difficulty not in ['normal','veteran','mayhem'] or not c.selected is int or c.selected<0 or c.selected>=Roster.HEROES.size() or c.arena_id not in Roster.ARENAS:return {}
	for key in ['hp','max_hp','speed','damage_mult','attack_mult','crit','armor','magnet','projectile_speed','multishot','level','xp','coins','earned','kills','dealt','run_time','wave_number','remaining','spawn_clock','hurt_clock','orbit_angle','spawn_cycle','animation_clock','facing','boss_clock','boss_phase','rerolls','run_waves','run_abilities','run_events','studio_reward','spawn_serial']:
		if not Graph.number(c[key]):return {}
	if c.hp<=0 or c.max_hp<c.hp or c.max_hp>1.0e9 or c.level<1 or c.level>999 or c.wave_number<1 or c.wave_number>1000000 or (c.run_mode=='campaign' and c.wave_number>10) or c.remaining<0 or c.remaining>120 or c.run_time<0:return {}
	for key in ['enemies','loot','weapons','offers','level_choices']:
		if not c[key] is Array:return {}
	if c.enemies.size()>180 or d.shots.size()>320 or c.loot.size()>4096 or c.weapons.is_empty() or c.weapons.size()>4 or c.offers.size()>4 or c.level_choices.size()>3:return {}
	for key in ['run_gear','run_loadout','upgrade_counts']:
		if not c[key] is Dictionary:return {}
	if not d.player.get('position') is Vector2 or not d.player.get('velocity') is Vector2 or d.player.position.x<0 or d.player.position.x>2400 or d.player.position.y<0 or d.player.position.y>1600:return {}
	for key in ['seed','state']:
		if not d.rng.get(key) is String or not d.rng[key].is_valid_int() or str(int(d.rng[key]))!=d.rng[key]:return {}
	if not valid_contents(d,data):return {}
	return d
static func compatible(data,saved:Dictionary) -> bool:
	var d=unpack(data)
	if d.is_empty():return false
	return saved.collection.heroes.has(Roster.HEROES[d.core.selected]) and saved.world_progress.unlocked.has(d.core.arena_id)

static func definitions_for(name:String):
	if not definitions.has(name):definitions[name]=JSON.parse_string(FileAccess.get_file_as_string('res://data/'+name+'.json'))
	return definitions[name]
static func valid_contents(d:Dictionary,envelope:Dictionary) -> bool:
	var c:Dictionary=d.core;var weapons=definitions_for('weapons/weapons');var specs=definitions_for('specializations/specializations');var upgrades=definitions_for('upgrades/upgrades');var item_defs=definitions_for('items/items')
	for key in ['level','xp','coins','earned','kills','wave_number','rerolls','run_waves','run_abilities','run_events','multishot']:
		if not c[key] is int or c[key]<0:return false
	if c.coins>1000000000 or c.speed<=0 or c.damage_mult<=0 or c.attack_mult<=0 or c.projectile_speed<=0:return false
	if not c.axel_shop_pending is bool or not c.boss_charging is bool or not c.boss_target is Vector2 or not c.boss_warning is String:return false
	var known_upgrades=[]
	for u in upgrades:known_upgrades.append(u[0])
	for u in c.level_choices:
		if not u is Array or u.size()!=4 or not u[0] in known_upgrades:return false
		for value in u:
			if not value is String:return false
	if envelope.phase=='level' and c.level_choices.is_empty():return false
	for id in c.upgrade_counts:
		if not known_upgrades.has(id) or not c.upgrade_counts[id] is int or c.upgrade_counts[id]<0 or c.upgrade_counts[id]>999:return false
	var seen=[]
	for w in c.weapons:
		if not w is Dictionary or w.get('id') not in Roster.ALLOWED[Roster.HEROES[c.selected]] or seen.has(w.id) or not w.get('level') is int or w.level<1 or w.level>5 or not Graph.number(w.get('clock')):return false
		if w.has('spec') and (not specs.has(w.spec) or specs[w.spec].weapon!=w.id or w.level!=5):return false
		seen.append(w.id)
	for offer in c.offers:
		if not offer is Dictionary or offer.get('type') not in ['weapon','item','upgrade'] or not offer.get('id') is String or not Graph.number(offer.get('price')) or offer.price<0 or offer.price>1000000000:return false
		if (offer.type=='weapon' and not weapons.has(offer.id)) or (offer.type=='item' and not item_defs.has(offer.id)) or (offer.type=='upgrade' and offer.id not in known_upgrades):return false
		for key in ['name','description','rarity']:
			if not offer.get(key) is String:return false
		if offer.has('sold') and not offer.sold is bool:return false
	var actor_ids=[]
	for e in c.enemies:
		if not valid_enemy(e) or actor_ids.has(e.save_actor) or e.save_actor>c.spawn_serial:return false
		actor_ids.append(e.save_actor)
	for loot in c.loot:
		if not loot is Dictionary or not loot.get('pos') is Vector2 or not Graph.number(loot.get('xp')) or loot.xp<0:return false
	for shot in d.shots:
		if shot is Dictionary and shot.get('active')==false and shot.get('hit_enemies') is Array:continue
		if not shot is Dictionary or shot.get('active')!=true or not shot.get('pos') is Vector2 or not shot.get('vel') is Vector2 or not shot.get('hostile') is bool or not shot.get('weapon') is String:return false
		for key in ['damage','life','hits_left','splash_power']:
			if not Graph.number(shot.get(key)):return false
		if not shot.get('hit_enemies') is Array:return false
		for e in shot.hit_enemies:
			if not valid_enemy(e):return false
	var summary=envelope.get('summary')
	if not summary is Dictionary or summary.get('hero')!=Roster.HEROES[c.selected] or summary.get('arena')!=c.arena_id or summary.get('mode')!=c.run_mode or summary.get('wave')!=c.wave_number or summary.get('level')!=c.level:return false
	return true
static func valid_enemy(e) -> bool:
	if not e is Dictionary or not e.get('save_actor') is int or e.save_actor<1 or not e.get('kind') is String or not e.get('pos') is Vector2:return false
	if not definitions_for('enemies/enemies').has(e.kind) and not definitions_for('enemies/reactor_roles').has(e.kind) and e.kind not in ['champion','breaker_axel']:return false
	for key in ['hp','max_hp','speed','damage','radius','hit','orbit_cd','coin_reward','xp_reward']:
		if not Graph.number(e.get(key)):return false
	return e.max_hp>0 and e.radius>0
