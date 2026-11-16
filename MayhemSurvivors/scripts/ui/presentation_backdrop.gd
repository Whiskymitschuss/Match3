extends Control
# Decorative geometry is independent of gameplay RNG and ignores all input.
var game:Node2D
var clock=0.0
func _ready():mouse_filter=Control.MOUSE_FILTER_IGNORE
func _process(delta):
	clock+=delta
	if game.saved.settings.quality!='LOW':queue_redraw()
func _draw():
	if not is_instance_valid(game):return
	var rect=Rect2(Vector2.ZERO,size)
	draw_rect(rect,Color('#0B101A'))
	var right=rect.end.x;var left=rect.position.x
	draw_colored_polygon(PackedVector2Array([Vector2(right-900,rect.position.y),Vector2(right,rect.position.y),rect.end,Vector2(right-1300,rect.end.y)]),Color('#151C2A'))
	for i in range(12):
		var x=left+i*260
		draw_line(Vector2(x,rect.position.y),Vector2(x-700,rect.end.y),Color('#202B3A'),2,true)
	# Hazard stripe edges frame the UI without competing with card text.
	for y in [rect.position.y,rect.end.y-12]:
		draw_rect(Rect2(left,y,rect.size.x,12),Color('#2C1D12'))
		for i in range(int(rect.size.x/45)+1):
			var x=left+i*45
			draw_colored_polygon(PackedVector2Array([Vector2(x,y),Vector2(x+23,y),Vector2(x+10,y+12),Vector2(x-13,y+12)]),Color('#B77222'))
	for i in range(6):
		var y=rect.position.y+95+i*(rect.size.y-190)/5
		for x in [left+23,right-23]:
			draw_circle(Vector2(x,y),8,Color('#303B49'));draw_line(Vector2(x-4,y),Vector2(x+4,y),Color('#89929D'),2)
	var count=10 if game.saved.settings.quality=='LOW' else (18 if game.saved.settings.quality=='MEDIUM' else 28)
	for i in range(count):
		var p=Vector2(left+fmod(i*173.0+sin(i)*100,rect.size.x),rect.end.y-fmod(i*137.0+clock*(16+i%5*7),rect.size.y))
		draw_line(p,p+Vector2(-3,-7),Color(1,.35,.06,.13+.18*(.5+.5*sin(clock+i))),2,true)
	draw_line(Vector2(100,219),Vector2(1820,219),Color('#55402B'),2,true)
	draw_line(Vector2(100,219),Vector2(370,219),Color('#FF9F1C'),5,true)
