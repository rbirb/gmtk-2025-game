extends Node2D

@onready var enemy_spawn: Path2D = $EnemySpawn
@onready var spawner_pos := Vector2(enemy_spawn.curve.get_point_position(0).x, enemy_spawn.curve.get_point_position(1).x)
@onready var spawner_height := enemy_spawn.curve.get_point_position(0).y

func get_random_spawn_pos() -> Vector2:
	return Vector2(randf_range(spawner_pos.x, spawner_pos.y), spawner_height)
