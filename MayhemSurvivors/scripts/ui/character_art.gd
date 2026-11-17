extends RefCounted
const Comic=preload('res://scripts/expansion/comic_art.gd')
# Menu illustrations remain complete; the gameplay bases contain NO arms/hands.
# Exactly two arms and glove components are attached by CombatVisuals at runtime.
const TEXTURE = preload('res://assets/characters/heroes_atlas.png')
const GAMEPLAY_TEXTURE = preload('res://assets/characters/hero_rig.png')
const CELL_SIZE = Vector2(512,512)
const INDICES = {'bruiser':0,'sparky':1,'shade':2}
static func region(kind:String,_gameplay:bool=false) -> Rect2:return Comic.hero(kind)
static func body_region(kind:String) -> Rect2:return Comic.hero(kind)
static func hand_region(_kind:String) -> Rect2:return Comic.glove()
const TWINKLE=preload('res://assets/characters/twinkle_atlas.png')
const KICKSY=preload('res://assets/characters/kicksy_atlas.png')
const STEELFIST=preload('res://assets/characters/steelfist_atlas.png')
static func texture(_kind:String,_gameplay:bool=false) -> Texture2D:return Comic.HEROES
