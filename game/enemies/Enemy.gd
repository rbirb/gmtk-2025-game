class_name Enemy extends Area2D
signal damaged
signal died

enum TYPES {
	CIRCLE,
	TRIANGLE,
	CUBE
}

@export var speed: float
@export var damage: int
@export var health: int
var force_die := false

func _ready() -> void:
	enemy_ready()

func enemy_ready():
	self.body_entered.connect(on_body_entered)
	Global.state_changed.connect(on_state_change)
	Global.explode.connect(func(): force_die = true; die())
	add_to_group("Enemy")
	health += EnemyStats.health_add

func on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		PlayerStats.get_damage(damage+EnemyStats.damage_add)

func get_damage(amount:int):
	health -= amount
	if health <= 0:
		die()
	else:
		Audio.play_sound("enemy/hit/"+str(randi_range(1,2))+".wav", -6)
		damaged.emit()

func die():
	died.emit()

func on_state_change():
	if Global.state == Global.STATE_NEXT_LEVEL_LOAD:
		die()
