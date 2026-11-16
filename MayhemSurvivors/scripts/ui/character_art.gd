extends RefCounted
# Menu illustrations remain complete; the gameplay bases contain NO arms/hands.
# Exactly two arms and glove components are attached by CombatVisuals at runtime.
const TEXTURE = preload('res://assets/characters/heroes_atlas.png')
const GAMEPLAY_TEXTURE = preload('res://assets/characters/hero_rig.png')
const CELL_SIZE = Vector2(512,512)
const INDICES = {'bruiser':0,'sparky':1,'shade':2}
static func region(kind: String, gameplay: bool = false) -> Rect2:
	if kind=='kicksy':return Rect2(Vector2.ZERO,Vector2(KICKSY.get_size())*.5)
	if kind=='twinkle':return Rect2(Vector2.ZERO,Vector2(TWINKLE.get_size())*.5)
	return Rect2(Vector2(INDICES.get(kind,0)*512,512 if gameplay else 0),CELL_SIZE)
static func body_region(kind: String) -> Rect2:
	if kind=='kicksy':return Rect2(Vector2(KICKSY.get_width()*.5,0),Vector2(KICKSY.get_size())*.5)
	if kind=='twinkle':return Rect2(Vector2(TWINKLE.get_width()*.5,0),Vector2(TWINKLE.get_size())*.5)
	var size=GAMEPLAY_TEXTURE.get_size()
	return Rect2(Vector2(INDICES.get(kind,0)*size.x/3,0),Vector2(size.x/3,size.y*.625))
static func hand_region(kind: String) -> Rect2:
	if kind=='kicksy':return Rect2(Vector2(KICKSY.get_width()*.07,KICKSY.get_height()*.64),Vector2(KICKSY.get_width()*.21,KICKSY.get_height()*.24))
	if kind=='twinkle':return Rect2(Vector2(TWINKLE.get_width()*.075,TWINKLE.get_height()*.68),Vector2(TWINKLE.get_width()*.19,TWINKLE.get_height()*.19))
	var size=GAMEPLAY_TEXTURE.get_size()
	return Rect2(Vector2(INDICES.get(kind,0)*size.x/3,size.y*.625),Vector2(size.x/3,size.y*.375))
const TWINKLE=preload('res://assets/characters/twinkle_atlas.png')
const KICKSY=preload('res://assets/characters/kicksy_atlas.png')
static func texture(kind:String,gameplay:bool=false) -> Texture2D:
	if kind=='kicksy':return KICKSY
	return TWINKLE if kind=='twinkle' else (GAMEPLAY_TEXTURE if gameplay else TEXTURE)
