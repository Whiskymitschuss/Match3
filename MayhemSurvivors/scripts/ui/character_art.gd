extends RefCounted
# One shared RGBA atlas: detailed portraits above, small gameplay figures below.
# Artwork is visual only. Collision, weapons and stats are independent.
const TEXTURE = preload('res://assets/characters/heroes_atlas.png')
const CELL_SIZE = Vector2(512,512)
const INDICES = {'bruiser':0,'sparky':1,'shade':2}
static func region(kind: String, gameplay: bool = false) -> Rect2:
	return Rect2(Vector2(INDICES.get(kind,0)*512,512 if gameplay else 0),CELL_SIZE)
