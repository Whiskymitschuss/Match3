extends RefCounted
static func defaults() -> Dictionary:
	return {'left_handed':false,'dynamic':true,'size':1.0,'opacity':1.0,'deadzone':14.0/110.0,'joy_x':0.0,'joy_y':0.0,'ability_x':0.0,'ability_y':0.0}
static func clean(source) -> Dictionary:
	var d=defaults()
	if not source is Dictionary:return d
	for key in ['left_handed','dynamic']:
		if source.get(key) is bool:d[key]=source[key]
	for key in ['size','opacity','deadzone','joy_x','joy_y','ability_x','ability_y']:
		var v=source.get(key)
		if not (v is int or v is float) or not is_finite(float(v)):continue
		var bounds={'size':[.85,1.2],'opacity':[.45,1.0],'deadzone':[.08,.28],'joy_x':[-120.0,120.0],'joy_y':[-110.0,40.0],'ability_x':[-80.0,80.0],'ability_y':[-110.0,25.0]}[key]
		d[key]=clampf(float(v),bounds[0],bounds[1])
	return d
static func geometry(safe:Rect2,source) -> Dictionary:
	var d=clean(source);var scale:float=d.size
	var joy=Vector2(safe.position.x+220,safe.end.y-230)+Vector2(d.joy_x,d.joy_y)
	var center=Vector2(safe.end.x-260,safe.end.y-205)+Vector2(d.ability_x,d.ability_y)
	if d.left_handed:joy.x=safe.end.x-(joy.x-safe.position.x);center.x=safe.position.x+(safe.end.x-center.x)
	var joy_margin=Vector2.ONE*145*scale
	joy=joy.clamp(safe.position+joy_margin,safe.end-joy_margin)
	var button_size=Vector2(300,210)*scale
	center=center.clamp(safe.position+button_size*.5+Vector2(20,320),safe.end-button_size*.5-Vector2(20,50))
	var ability=Rect2(center-button_size*.5,button_size)
	var spell=Rect2(ability.position-Vector2(0,170*scale),Vector2(300,140)*scale)
	var zone=Rect2(Vector2(safe.end.x-700 if d.left_handed else safe.position.x,safe.end.y-540),Vector2(700,540))
	return {'joy':joy,'radius':110.0*scale,'visual_radius':140.0*scale,'ability':ability,'spell':spell,'zone':zone,'scale':scale,'opacity':d.opacity,'deadzone':d.deadzone,'dynamic':d.dynamic}
static func analog(offset:Vector2,radius:float,deadzone:float) -> Vector2:
	var length=clampf(offset.length()/maxf(1,radius),0,1)
	if length<=deadzone:return Vector2.ZERO
	return offset.normalized()*((length-deadzone)/(1.0-deadzone))
