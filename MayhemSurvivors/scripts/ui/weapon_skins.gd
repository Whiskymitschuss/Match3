extends RefCounted
const C=preload('res://scripts/progression/collection.gd')
static func definition(loadout:Dictionary) -> Dictionary:
	var id=loadout.get('skin','');var d=C.catalog().items.get(id,{})
	return d if d.get('slot','')=='skin' else {}
static func color(loadout:Dictionary,fallback:Color=Color.WHITE) -> Color:
	var d=definition(loadout);return Color(d.color) if not d.is_empty() else fallback
static func tint(loadout:Dictionary) -> Color:
	return Color.WHITE.lerp(color(loadout),.72) if not definition(loadout).is_empty() else Color.WHITE
static func livery(canvas:CanvasItem,rect:Rect2,loadout:Dictionary,clock:float=0):
	var id=loadout.get('skin','')
	if definition(loadout).is_empty():return
	var c=color(loadout);var center=rect.position+rect.size*Vector2(.52,.48);var step=rect.size.x*.12
	var width=maxf(1.0,minf(rect.size.x,rect.size.y)*.035)
	if id=='void_steel':
		for i in range(3):
			var at=center+Vector2((i-1)*step,0);var r=width*1.8
			canvas.draw_colored_polygon(PackedVector2Array([at+Vector2(0,-r),at+Vector2(r,0),at+Vector2(0,r),at-Vector2(r,0)]),Color('#EBD9FF'))
	elif id in ['ember_edge','toxic_stripe']:
		for i in range(4):
			var at=center+Vector2((i-1.5)*step,0);canvas.draw_line(at-Vector2(width,width*1.7),at+Vector2(width,width*1.7),Color('#17121F'),width*1.6,true)
	else:
		for side in [-1,1]:canvas.draw_line(center+Vector2(-step*1.7,side*width*1.7),center+Vector2(step*1.7,side*width*1.7),c.lightened(.55),width,true)
	canvas.draw_circle(center+Vector2(step*2.1,0),width*(1.3+.3*sin(clock*4)),Color(c,.7))
