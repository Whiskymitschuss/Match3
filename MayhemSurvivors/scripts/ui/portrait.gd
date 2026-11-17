extends Control
const Mastery=preload('res://scripts/progression/character_mastery.gd')
var outfit='classic'
var gear:Dictionary={}
var decor:Dictionary={}
var hunter=false
var motion_enabled=true
const Art = preload('res://scripts/ui/character_art.gd')
var color = Color('#00d9d0')
var kind = 'sparky'
var mode = 'portrait'
var clock = 0.0
func _process(dt):
	if not motion_enabled:return
	clock+=dt
	queue_redraw()
func _draw():
	var floor_pos = Vector2(180,349)
	var pulse = .5+.5*sin(clock*2)
	# Subdued halo and shadow preserve a clean silhouette on dark panels.
	draw_set_transform(floor_pos,0,Vector2(1,.2))
	draw_circle(Vector2.ZERO,135,Color(0,0,0,.35))
	draw_arc(Vector2.ZERO,123+3*pulse,0,TAU,64,Color(color,.25+.12*pulse),5,true)
	draw_set_transform(Vector2.ZERO)
	if decor.get('ring','')!='':
		draw_set_transform(floor_pos,0,Vector2(1,.2))
		var c=Color('#FF9F1C') if decor.ring=='flame' else Color('#A0F6FF')
		for i in range(6):draw_arc(Vector2.ZERO,126,i*TAU/6+clock,i*TAU/6+clock+.7,12,c,6,true)
		draw_set_transform(Vector2.ZERO)
	var bob = sin(clock*2.5)*3
	var tint = Mastery.tint(outfit)
	if mode=='defeat':
		tint*=Color(.7,.7,.8)
		bob=absf(sin(clock*1.8))*3
	if mode=='victory':
		for i in range(35):
			var at=Vector2(fmod(i*173.0,500)-70,fmod(i*113+clock*90,520)-100)
			draw_rect(Rect2(at,Vector2(5,11)),[color,Color('#ffd166'),Color('#e54cff')][i%3])
		draw_arc(Vector2(180,170),157+sin(clock*4)*6,0,TAU,64,Color(1,.82,.4,.15),8,true)
	if mode=='wardrobe' or gear.get('head','')!='' or gear.get('body','')!='' or gear.get('feet','')!='' or gear.get('skin','')!='':
		draw_set_transform(Vector2(0,bob))
		preload('res://scripts/ui/gear_art.gd').preview(self,kind,gear,tint)
		draw_set_transform(Vector2.ZERO)
	else:draw_texture_rect_region(Art.texture(kind),Rect2(Vector2(0,bob),Vector2(360,360)),Art.region(kind),tint)

	Mastery.insignia(self,Vector2(312,305+bob),outfit,25)

	if hunter:Mastery.insignia(self,Vector2(48,305+bob),'hunter',23)

	if decor.get('buddy','')!='':
		var at=Vector2(310,120+sin(clock*2)*8)
		if decor.buddy=='mini_bot':
			draw_circle(at,24,Color('#14213D'));draw_rect(Rect2(at-Vector2(20,15),Vector2(40,30)),Color('#80DEFF'));draw_circle(at+Vector2(-8,0),4,Color('#14213D'));draw_circle(at+Vector2(8,0),4,Color('#14213D'))
		else:
			var w=preload('res://scripts/ui/combat_art.gd');draw_texture_rect_region(w.weapon_texture('bomb'),Rect2(at-Vector2(30,30),Vector2(60,60)),w.weapon('bomb'))
	if decor.get('title','')!='':draw_string(preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf'),Vector2(65,378),'CHAOS-LEGENDE',HORIZONTAL_ALIGNMENT_CENTER,230,22,Color('#FFD166'))
