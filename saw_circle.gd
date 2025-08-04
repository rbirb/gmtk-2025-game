extends Damager

@export var speed: float

func _process(delta: float) -> void:
	global_position.y += speed * delta
	if global_position.y > 1100:
		queue_free()
