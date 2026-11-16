extends RefCounted
# Menu illustrations remain complete; the gameplay bases contain NO arms/hands.
# Exactly two arms and glove components are attached by CombatVisuals at runtime.
const TEXTURE = preload('res://assets/characters/heroes_atlas.png')
const GAMEPLAY_TEXTURE = preload('res://assets/characters/hero_rig.png')
const CELL_SIZE = Vector2(512,512)
const INDICES = {'bruiser':0,'sparky':1,'shade':2}
static func region(kind: String, gameplay: bool = false) -> Rect2:
	return Rect2(Vector2(INDICES.get(kind,0)*512,512 if gameplay else 0),CELL_SIZE)
static func body_region(kind: String) -> Rect2:
	var size=GAMEPLAY_TEXTURE.get_size()
	return Rect2(Vector2(INDICES.get(kind,0)*size.x/3,0),Vector2(size.x/3,size.y*.625))
static func hand_region(kind: String) -> Rect2:
	var size=GAMEPLAY_TEXTURE.get_size()
	return Rect2(Vector2(INDICES.get(kind,0)*size.x/3,size.y*.625),Vector2(size.x/3,size.y*.375))
