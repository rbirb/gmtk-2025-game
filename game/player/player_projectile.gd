extends Area2D

@export var speed: float
var pierce := PlayerStats.pierce

func _process(delta: float) -> void:
	global_position.y -= speed * delta
	if global_position.y < 30:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_damage"):
		if area.is_in_group("Enemy"):
			if not is_right_type(area):
				return
		area.get_damage(PlayerStats.damage)
		pierce -= 1
		if pierce <= 0:
			queue_free()

func is_right_type(enemy: Area2D):
	return (enemy.is_in_group("Circle") and EnemyStats.current_type == Enemy.TYPES.CIRCLE) or \
			(enemy.is_in_group("Triangle") and EnemyStats.current_type == Enemy.TYPES.TRIANGLE) or \
			(enemy.is_in_group("Cube") and EnemyStats.current_type == Enemy.TYPES.CUBE)
