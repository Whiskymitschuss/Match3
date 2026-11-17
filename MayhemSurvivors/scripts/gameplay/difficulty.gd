extends RefCounted
const IDS=['normal','veteran','mayhem']
static var cached:Dictionary={}
static func all() -> Dictionary:
	if cached.is_empty():cached=JSON.parse_string(FileAccess.get_file_as_string('res://data/difficulty/presets.json'))
	return cached
static func definition(id:String) -> Dictionary:return all().get(id,all().normal)
static func current(game:Node2D) -> Dictionary:return definition('normal' if game.run_mode=='tutorial' else game.run_difficulty)
static func stats(game:Node2D,base:Dictionary,boss:bool) -> Dictionary:
	var result=base.duplicate();var d=current(game)
	result.hp*=float(d.boss_hp if boss else d.hp);result.speed*=float(d.speed);result.damage*=float(d.damage)
	return result
static func reward(game:Node2D,base:int) -> int:return maxi(1,roundi(base*float(current(game).reward)))
