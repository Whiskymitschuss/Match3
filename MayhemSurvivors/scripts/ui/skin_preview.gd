extends Control
const Art=preload('res://scripts/ui/combat_art.gd')
const Skins=preload('res://scripts/ui/weapon_skins.gd')
var weapon='blaster'
var finish='cyan_core'
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _draw():
	var rect=Rect2(Vector2.ZERO,size);var loadout={'skin':finish}
	draw_circle(size*.5,minf(size.x,size.y)*.44,Color(Skins.color(loadout),.10))
	draw_texture_rect_region(Art.weapon_texture(weapon),rect,Art.weapon(weapon),Skins.tint(loadout));Skins.livery(self,rect,loadout)
