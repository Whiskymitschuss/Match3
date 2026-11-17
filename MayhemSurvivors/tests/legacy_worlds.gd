extends RefCounted
# Explicit pre-map arena access for existing combat/UI fixtures. No wins or rewards.
static func unlock_all(saved:Dictionary):
	var w=preload('res://scripts/progression/world_progress.gd')
	saved.world_progress.unlocked=w.ORDER.duplicate()
	saved.unlocked_arenas=w.ORDER.duplicate()
