extends Camera2D

var ROTATION_RADIANS := deg_to_rad(15)
const ROTATION_LERP := 0.03

func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rotation = lerp_angle(rotation, ROTATION_RADIANS, ROTATION_LERP)
	elif Input.is_action_pressed("right"):
		rotation = lerp_angle(rotation, -ROTATION_RADIANS, ROTATION_LERP)
	else:
		rotation = lerp_angle(rotation, 0, ROTATION_LERP)
