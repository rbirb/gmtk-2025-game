extends Camera2D

@export var random_strength: float = 30.0
@export var shaking: bool = false
@export var shake_fade: float = 5.0
@onready var timer := $Timer
var rng = RandomNumberGenerator.new()
var shake_strength = 0.0
var ROTATION_RADIANS := deg_to_rad(15)
const ROTATION_LERP := 0.03

func start_shake(time:=1.0):
	timer.wait_time = time
	timer.start()
	shaking = true

func _process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		rotation = lerp_angle(rotation, ROTATION_RADIANS, ROTATION_LERP)
	elif Input.is_action_pressed("right"):
		rotation = lerp_angle(rotation, -ROTATION_RADIANS, ROTATION_LERP)
	else:
		rotation = lerp_angle(rotation, 0, ROTATION_LERP)

	if shaking:
		apply_shake()

	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)

		offset = randomOffset()

func apply_shake():
	shake_strength = random_strength

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func _on_timer_timeout() -> void:
	shaking = false
