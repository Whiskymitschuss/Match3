extends RefCounted
# Explicit fixture for pre-garage combat/UI regression suites. No production bypass.
static func unlock_all(saved:Dictionary):
	var c=preload('res://scripts/progression/collection.gd')
	saved.collection.heroes=c.HEROES.duplicate()
	for id in c.catalog().items:
		if c.catalog().items[id].slot=='weapon':saved.collection.levels[id]=1
	saved.unlocked=c.HEROES.duplicate()
