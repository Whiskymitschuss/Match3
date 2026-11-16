extends Control
# One full-screen illustration, bounded particles, no gameplay RNG or input interception.
const ART=preload('res://assets/branding/neon_city.png')
var game:Node2D
var clock=0.0
var motion=false
var is_home=false
var picture:TextureRect
func _ready():
	mouse_filter=Control.MOUSE_FILTER_IGNORE
	motion=game.saved.settings.quality!='LOW' and not game.saved.settings.get('reduced_motion',false)
	set_process(motion)
	picture=TextureRect.new();picture.name='BackdropArt';picture.texture=ART
	picture.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;picture.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
	picture.mouse_filter=Control.MOUSE_FILTER_IGNORE;picture.show_behind_parent=true;add_child(picture)
	if motion:
		var effect=ShaderMaterial.new();effect.shader=preload('res://assets/ui/shaders/menu_soft_focus.gdshader');picture.material=effect
	resized.connect(update_picture);update_picture()
func update_picture():
	if not is_instance_valid(picture):return
	picture.size=size*1.07
	var pan=(Vector2(sin(clock*.13)*7,cos(clock*.11)*4)+game.menu_motion.filtered*35) if motion else Vector2.ZERO
	picture.position=(size-picture.size)*.5+pan
func _process(delta):
	if not motion:return
	game.menu_motion.sample(delta)
	clock+=delta
	if picture.material:picture.material.set_shader_parameter('blur_px',3.0*maxf(0,1-clock/.35))
	update_picture();queue_redraw()
func _draw():
	if not is_instance_valid(game):return
	var rect=Rect2(Vector2.ZERO,size)
	var main=is_home
	draw_rect(rect,Color(.025,.01,.07,.16 if main else .64))
	# Readability scrim is strongest underneath navigation and softens toward artwork.
	var opacity=.48 if main else .22
	var corners=PackedVector2Array([Vector2.ZERO,Vector2(size.x,0),size,Vector2(0,size.y)])
	var colors=PackedColorArray([Color(.025,.008,.07,opacity),Color(.025,.008,.07,0),Color(.025,.008,.07,0),Color(.025,.008,.07,opacity)])
	draw_polygon(corners,colors)
	for y in [0,size.y-2]:draw_line(Vector2(0,y),Vector2(size.x,y),Color(.85,.2,1,.35),2,true)
	var count=8 if not motion else (14 if game.saved.settings.quality=='MEDIUM' else 24)
	for i in range(count):
		var p=Vector2(fmod(i*173.0+sin(i)*100+size.x,size.x),size.y-fmod(i*137.0+clock*(10+i%5*5),size.y))
		draw_circle(p,1.5+i%2,Color(1,.42,.87,.15+.18*(.5+.5*sin(clock+i))))
	if not main:
		draw_rect(Rect2(60-position.x,48-position.y,1800,170),Color(.04,.025,.10,.62))
		draw_line(Vector2(100-position.x,220-position.y),Vector2(1810-position.x,220-position.y),Color(.65,.23,.86,.45),2,true)
