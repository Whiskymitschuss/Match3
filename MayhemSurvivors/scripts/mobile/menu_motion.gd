extends RefCounted
var game:Node2D
var center=Vector2.ZERO
var filtered=Vector2.ZERO
var calibrated=false
func _init(g:Node2D):game=g
func reset():calibrated=false;filtered=Vector2.ZERO
func apply(raw:Vector2,dt:float) -> Vector2:
	if not raw.is_finite():return filtered
	if not calibrated:center=raw;calibrated=true
	var target=(raw-center).limit_length(.7)
	filtered=filtered.lerp(target,1-exp(-maxf(0,dt)*5))
	return filtered
func sample(dt:float) -> Vector2:
	if not game.saved.settings.get('tilt',true) or game.saved.settings.get('reduced_motion',false):filtered=Vector2.ZERO;return filtered
	if not OS.has_feature('android'):return Vector2.ZERO
	var gravity=Input.get_gravity()
	if gravity.length_squared()<1:gravity=Input.get_accelerometer()
	if gravity.length_squared()<1:return Vector2.ZERO
	return apply(Vector2(-gravity.y,gravity.x)/9.81,dt)
