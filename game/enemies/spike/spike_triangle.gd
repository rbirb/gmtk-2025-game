extends Damager

@onready var player := get_tree().get_nodes_in_group("Player")[0]
@export var speed:float
@onready var sprite:=$Sprite2D
var horizontal := false
var left := false

func _process(delta: float) -> void:
	if horizontal:
		if left:
			global_position.x += speed * delta
			sprite.rotation_degrees = -90
			if global_position.x > 700:
				queue_free()
		else:
			global_position.x -= speed * delta
			sprite.rotation_degrees = 90
			if global_position.x < -60:
				queue_free()
	else:
		global_position.y += speed * delta
		sprite.rotation_degrees = 0
		if global_position.y > 1100:
			queue_free()
