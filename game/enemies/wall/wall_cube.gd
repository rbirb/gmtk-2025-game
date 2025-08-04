extends Damager

@export var speed:float
@onready var collision := $CollisionShape2D
@onready var sprite := $Sprite2D
const LERP_ROTATION := 0.15
var target_rotation := 0.0
var left := false
@onready var flash_anim := $AnimationFlash

func _process(delta: float) -> void:
	if left:
		collision.position.x = collision.shape.size.x / -2
		sprite.position.x = collision.position.x + 0.5
		rotation = lerp_angle(rotation, deg_to_rad(abs(target_rotation)), LERP_ROTATION)
	else:
		collision.position.x = collision.shape.size.x / 2
		sprite.position.x = collision.position.x - 0.5
		rotation = lerp_angle(rotation, deg_to_rad(-abs(target_rotation)), LERP_ROTATION)
	global_position.y += speed * delta
	if global_position.y > 1600:
		queue_free()

func get_damage(amount: int):
	Audio.play_sound("enemy/hit/2.wav", -6)
	target_rotation += clamp(randi_range(15, 25)-PlayerStats.damage/4, 0.5, 25)
	on_damaged()

func on_damaged():
	flash_anim.play("flash")
