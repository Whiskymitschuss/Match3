extends RefCounted
const MAX_PROJECTILES = 320
var items: Array = []
func acquire(pos: Vector2, direction: Vector2, power: float, hostile: bool, speed: float, life: float):
	var shot = null
	for item in items:
		if not item.active: shot=item; break
	if shot==null:
		if items.size()>=MAX_PROJECTILES: return
		shot={}
		items.append(shot)
	shot.merge({'active':true,'pos':pos,'vel':direction*speed,'damage':power,'hostile':hostile,'life':life,'spec':'','hit_enemies':[],'hits_left':1,'splash_power':0.0},true)
	return shot
func clear():
	for item in items:
		item.active=false
		item.hit_enemies.clear()
