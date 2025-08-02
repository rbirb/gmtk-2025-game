class_name Enemy extends Area2D

enum TYPES {
	CIRCLE,
	TRIANGLE,
}

@export var speed: float
@export var damage: int

func _ready() -> void:
	enemy_ready()

func enemy_ready():
	self.body_entered.connect(on_body_entered)
	add_to_group("Enemy")

func _process(delta: float) -> void:
	move_down()

func move_down():
	position.y += speed

func on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		PlayerStats.get_damage(damage)
		print(PlayerStats.health)
