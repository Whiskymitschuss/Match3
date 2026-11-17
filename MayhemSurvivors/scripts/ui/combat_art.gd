extends RefCounted
const Comic=preload('res://scripts/expansion/comic_art.gd')
const TEXTURE = preload('res://assets/weapons/combat_atlas.png')
const WEAPONS = {'blaster':Vector2(0,0),'hammer':Vector2(1,0),'splitgun':Vector2(2,0),'arc':Vector2(0,1),'orbit':Vector2(1,1)}
const COLORS = [Color('#FFB547'),Color('#00E4FF'),Color('#C547FF')]
static func cell(coords: Vector2) -> Rect2:
	var step = Vector2(TEXTURE.get_size())/3.0
	return Rect2(coords*step,step)
static func weapon(id:String) -> Rect2:return Comic.weapon(id)
static func projectile(skin: int, hostile: bool = false) -> Rect2:
	return cell(Vector2(2,1) if hostile else Vector2(clampi(skin,0,2),2))
static func color_for(skin: int) -> Color:
	if skin>=3:return Color(['#A55EEA','#FF9F1C','#5DDCFF','#FF943D','#98EDFF','#7CFFE5','#8EAFFF','#F36FE4'][clampi(skin-3,0,7)])
	return COLORS[clampi(skin,0,2)]

static func weapon_texture(_id:String) -> Texture2D:return Comic.WEAPONS
