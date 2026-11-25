extends RefCounted
const FAMILIES={'assault':{'name':'BRECHER','color':'#FF9F1C','two':'+8 % Schaden','three':'+1 Rüstung'},'flux':{'name':'STROMKREIS','color':'#00D9D0','two':'+8 % Angriffstempo','three':'+15 % Projektiltempo'},'shadow':{'name':'NACHTLAUF','color':'#A55EEA','two':'+8 % Bewegungstempo','three':'+5 % Krit-Chance'}}
var game:Node2D
var data:Dictionary
var owned:Array[String]=[]
var applied:Dictionary={}
var textures:Dictionary={}
func _init(g:Node2D):game=g;data=game.read_data('items/items')
func clear():owned.clear();applied.clear()
func family(weapon:String) -> String:
	return 'flux' if weapon in ['arc','mop','cryo','tesla'] else ('shadow' if weapon in ['orbit','chakram'] else 'assault')
func counts() -> Dictionary:
	var result={'assault':0,'flux':0,'shadow':0}
	for w in game.weapons:result[family(w.id)]+=1
	for id in owned:
		if result.has(data[id].family):result[data[id].family]+=1
	return result
func valid(id:String) -> bool:
	if not data.has(id) or owned.has(id):return false
	var item=data[id]
	if item.has('hero') and (game.characters[game.selected].id!=item.hero or game.weapon_level(item.weapon)==0 or game.run_mode=='tutorial'):return false
	var mods=item.mods
	if game.max_hp+float(mods.get('hp',0))<30:return false
	if mods.has('crit') and game.crit>=.75:return false
	if mods.has('armor') and float(mods.armor)>0 and game.armor>=20:return false
	return true
func add(id:String) -> bool:
	if not valid(id):return false
	owned.append(id);sync();return true
func modifiers() -> Dictionary:
	var result={}
	for id in owned:
		for stat in data[id].mods:result[stat]=float(result.get(stat,0))+float(data[id].mods[stat])
	var pieces=counts()
	if pieces.assault>=2:result.damage=float(result.get('damage',0))+.08
	if pieces.assault>=3:result.armor=float(result.get('armor',0))+1
	if pieces.flux>=2:result.attack=float(result.get('attack',0))+.08
	if pieces.flux>=3:result.projectile=float(result.get('projectile',0))+.15
	if pieces.shadow>=2:result.speed=float(result.get('speed',0))+.08
	if pieces.shadow>=3:result.crit=float(result.get('crit',0))+.05
	return result
func sync():
	var desired=modifiers()
	for pair in [['damage','damage_mult'],['attack','attack_mult'],['armor','armor'],['crit','crit']]:
		var stat:String=pair[0];var property:String=pair[1]
		var base=float(game.get(property))-float(applied.get(stat,0))
		var total=base+float(desired.get(stat,0))
		if stat=='crit':total=clampf(total,0,.75)
		elif stat=='armor':total=clampf(total,-10,20)
		else:total=maxf(.1,total)
		game.set(property,int(total) if stat=='armor' else total)
		applied[stat]=total-base
	for pair in [['speed','speed'],['projectile','projectile_speed'],['magnet','magnet']]:
		var stat:String=pair[0];var property:String=pair[1]
		game.set(property,float(game.get(property))/(1+float(applied.get(stat,0)))*(1+float(desired.get(stat,0))))
		applied[stat]=float(desired.get(stat,0))
	var delta=float(desired.get('hp',0))-float(applied.get('hp',0))
	game.max_hp+=delta;game.hp=minf(game.max_hp,game.hp+maxf(0,delta))
	applied.hp=float(desired.get('hp',0))
func icon(id:String) -> Texture2D:
	if not textures.has(id):textures[id]=load('res://assets/ui/items/'+id+'.svg')
	return textures[id]
func upgrade_price(w:Dictionary) -> int:return int((18+game.wave_number*5)*(1+int(w.level)*.3))
func upgrade(id:String) -> bool:
	if game.state!=game.State.SHOP or not game.encounters.rewards.is_empty() or not game.pending_specialization().is_empty():return false
	for w in game.weapons:
		if w.id!=id or w.level>=5:continue
		var cost=upgrade_price(w)
		if game.coins<cost:return false
		game.coins-=cost;w.level+=1;game.sound('buy');game.show_shop();return true
	return false
func salvage_price(w:Dictionary) -> int:
	# Kept well below the cheapest acquisition and upgrade costs; no buy/sell profit loop.
	return int((8+game.wave_number*2)*int(w.level)*.4)
func salvage(id:String) -> bool:
	if game.state!=game.State.SHOP or not game.encounters.rewards.is_empty() or game.weapons.size()<=1 or not game.pending_specialization().is_empty():return false
	for i in range(game.weapons.size()):
		if game.weapons[i].id!=id:continue
		game.coins+=salvage_price(game.weapons[i]);game.weapons.remove_at(i);sync()
		game.combat_visuals.clear();game.sound('buy');game.show_shop();return true
	return false
