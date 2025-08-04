class_name Damager extends Area2D

@export var damage:int

func _ready() -> void:
	damager_ready()

func damager_ready():
	self.body_entered.connect(on_body_entered)
	add_to_group("Damager")

func on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		PlayerStats.get_damage(damage+EnemyStats.damage_add*0.05)
