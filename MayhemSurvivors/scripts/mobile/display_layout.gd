extends RefCounted
const REFERENCE=Vector2(1920,1080)
static func calculate(viewport_size:Vector2,device_size:Vector2=Vector2.ZERO,device_safe:Rect2=Rect2()) -> Dictionary:
	var safe=Rect2(Vector2.ZERO,viewport_size)
	if device_size.x>0 and device_size.y>0 and device_safe.size.x>0 and device_safe.size.y>0:
		var clipped=device_safe.intersection(Rect2(Vector2.ZERO,device_size))
		if clipped.has_area():safe=Rect2(clipped.position/device_size*viewport_size,clipped.size/device_size*viewport_size)
	var factor=maxf(.001,minf(safe.size.x/REFERENCE.x,safe.size.y/REFERENCE.y))
	var position=safe.position+(safe.size-REFERENCE*factor)*.5
	var logical_safe=Rect2((safe.position-position)/factor,safe.size/factor)
	return {'scale':factor,'position':position,'safe':logical_safe,'bleed':Rect2(-position/factor,viewport_size/factor)}
static func camera_zoom(viewport_size:Vector2) -> float:
	return maxf(1.15,maxf(viewport_size.x/2400.0,viewport_size.y/1600.0))
