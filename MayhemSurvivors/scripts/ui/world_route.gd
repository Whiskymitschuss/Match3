extends Control
const W=preload('res://scripts/progression/world_progress.gd')
var game:Node2D
var clock=0.0
var floors:Array[Texture2D]=[]
var emblems:Array[Texture2D]=[]
static func card_rect(i:int) -> Rect2:return Rect2(Vector2(100+(i%5)*348,250+(i/5)*130),Vector2(330,115))
func _ready():
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	for id in W.ORDER:floors.append(game.Arenas.texture(id));emblems.append(load('res://assets/ui/worlds/'+id+'.svg'))
func _process(dt:float):
	if game.saved.settings.reduced_motion or game.saved.settings.quality=='LOW':return
	clock+=dt;queue_redraw()
func _draw():
	for i in range(W.ORDER.size()):
		var id:String=W.ORDER[i];var color=Color(W.rewards()[id].color);var open=W.available(game.saved,id);var cleared=game.saved.world_progress.cleared.has(id);var rect=card_rect(i);var at=rect.position
		draw_style_box(game.UISkin.box(Color('#292038'),color if i==game.arena_cursor else Color('#624974')),rect)
		if i<floors.size():
			var texture=floors[i];var source=Vector2(texture.get_size());var crop=Vector2(source.x,minf(source.y,source.x/3))
			draw_texture_rect_region(texture,Rect2(at+Vector2(6,6),Vector2(318,103)),Rect2((source-crop)*.5,crop),Color(.65,.65,.7) if open else Color(.23,.21,.3))
			draw_texture_rect(emblems[i],Rect2(at+Vector2(12,22),Vector2(64,64)),false,Color.WHITE if open else Color(.6,.6,.65))
		draw_string(game.UISkin.HEADING,at+Vector2(87,30),'WELT %02d / %s' % [i+1,'SIEG' if cleared else ('BEREIT' if open else 'GESPERRT')],HORIZONTAL_ALIGNMENT_LEFT,-1,21,Color('#FFD166') if cleared else Color('#D6C9E3'))
		draw_string(game.UISkin.HEADING,at+Vector2(87,66),game.Arenas.definition(id).name,HORIZONTAL_ALIGNMENT_LEFT,-1,25,color if open else Color('#AAA0B3'))
		if W.eligible(game.saved,id):draw_circle(at+Vector2(305,91),5+sin(clock*3),Color('#FFD166'))
		if i==game.arena_cursor:draw_line(at+Vector2(14,105),at+Vector2(312,105),color,3,true)
	if game.run_mode=='endless':return
	var id:String=W.ORDER[game.arena_cursor];var highest=clampi(int(game.saved.arena_records[id].highest_wave),0,10)
	for i in range(10):
		var at=Vector2(120+i*70,858);draw_rect(Rect2(at,Vector2(62,12)),Color(W.rewards()[id].color) if i<highest else Color('#4D3B5C'))
		if (i+1)%2==0:draw_circle(at+Vector2(31,6),4,Color('#FFD166'))
