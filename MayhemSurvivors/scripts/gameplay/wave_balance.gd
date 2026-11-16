extends RefCounted
# Optional per-wave modifiers. Missing fields preserve the established arena values.
static func spawn_count(wave:Dictionary,cycle:int) -> int:
	var every=int(wave.get('extra_spawn_every',0))
	return 2 if every>0 and cycle>0 and cycle%every==0 else 1
static func stats(data:Dictionary,wave:Dictionary,number:int,boss:bool=false) -> Dictionary:
	var health=float(data.hp)*(float(wave.get('boss_hp_factor',1.0)) if boss else (1.0+(number-1)*.09)*float(wave.get('hp_factor',1.0)))
	return {'hp':health,'speed':float(data.speed)*(1.0 if boss else float(wave.get('speed_factor',1.0))),'damage':float(data.damage)*(1.0 if boss else float(wave.get('damage_factor',1.0)))}
static func reward(base:int,wave:Dictionary,boss:bool=false) -> int:
	return base if boss else maxi(1,roundi(base*float(wave.get('reward_factor',1.0))))
