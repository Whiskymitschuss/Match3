extends Control
# Four existing arena paintings, original metal emblems and a single bounded route.
const W=preload('res://scripts/progression/world_progress.gd')
var game:Node2D
var clock=0.0
var floors:Array[Texture2D]=[]
var emblems:Array[Texture2D]=[]
func _ready():
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	for id in W.ORDER:
		floors.append(load('res://assets/environments/'+game.Arenas.definition(id).floor+'.png'))
		emblems.append(load('res://assets/ui/worlds/'+id+'.svg'))
func _process(dt:float):
	if game.saved.settings.reduced_motion or game.saved.settings.quality=='LOW':return
	clock+=dt;queue_redraw()
func _draw():
	for i in range(4):
		var id:String=W.ORDER[i];var color=Color(W.rewards()[id].color);var open=W.available(game.saved,id)
		var cleared=game.saved.world_progress.cleared.has(id);var at=Vector2(100+i*435,260)
		if i<3:
			var a=at+Vector2(400,110);var b=a+Vector2(35,0)
			draw_line(a,b,Color('#573F6B'),8,true)
			if cleared:draw_line(a,b,Color('#FFD166'),4,true)
		draw_style_box(game.UISkin.box(Color('#292038'),color if i==game.arena_cursor else Color('#624974')),Rect2(at,Vector2(400,235)))
		if i<floors.size():
			var texture=floors[i];var source=Vector2(texture.get_size());var crop=Vector2(source.x,source.x/2.7)
			draw_texture_rect_region(texture,Rect2(at+Vector2(10,10),Vector2(380,141)),Rect2((source-crop)*.5,crop),Color.WHITE if open else Color(.34,.31,.41))
			draw_texture_rect(emblems[i],Rect2(at+Vector2(25,35),Vector2(90,90)),false,Color.WHITE if open else Color(.6,.6,.65))
		var state='ERLEDIGT' if cleared else ('BEREIT' if open else 'GESPERRT')
		draw_string(game.UISkin.HEADING,at+Vector2(135,63),'WELT %02d' % (i+1),HORIZONTAL_ALIGNMENT_LEFT,-1,28,Color('#F6E7F9'))
		draw_string(game.UISkin.HEADING,at+Vector2(135,110),state,HORIZONTAL_ALIGNMENT_LEFT,-1,34,Color('#FFD166') if cleared else (color if open else Color('#B3A5BD')))
		draw_string(game.UISkin.HEADING,at+Vector2(22,191),game.Arenas.definition(id).name,HORIZONTAL_ALIGNMENT_LEFT,-1,34,color if open else Color('#AAA0B3'))
		if W.eligible(game.saved,id):draw_circle(at+Vector2(365,181),7+sin(clock*3),Color('#FFD166'))
		if i==game.arena_cursor:draw_line(at+Vector2(22,220),at+Vector2(378,220),color,4,true)
	# Campaign progress remains explicit even when viewing the Endless mode.
	if game.run_mode=='endless':return
	var id:String=W.ORDER[game.arena_cursor]
	var highest=clampi(int(game.saved.arena_records[id].highest_wave),0,10)
	for i in range(10):
		var at=Vector2(120+i*70,858)
		draw_rect(Rect2(at,Vector2(62,12)),Color(W.rewards()[id].color) if i<highest else Color('#4D3B5C'))
		if i in [4,9]:draw_circle(at+Vector2(31,6),4,Color('#FFD166'))
