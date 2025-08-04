extends Area2D

@export var damage: int
@export var speed: float
var distance := 0.0

func _process(delta: float) -> void:
	global_position += transform.x * speed * delta
	distance += speed * delta
	if distance > 1100:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		PlayerStats.get_damage(damage+int(EnemyStats.damage_add/2))
		queue_free()
