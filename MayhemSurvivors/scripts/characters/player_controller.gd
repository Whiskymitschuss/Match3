extends CharacterBody2D
# Touch input is supplied by the mobile layer; no keyboard action map exists.
func move_analog(axis: Vector2, speed: float, impulse:Vector2=Vector2.ZERO):
	velocity = axis.limit_length(1)*speed+impulse
	move_and_slide()
	position = position.clamp(Vector2(45,45),Vector2(2355,1555))
