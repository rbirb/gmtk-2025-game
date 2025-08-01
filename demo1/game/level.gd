class_name World #So we can do stuff like World.Build() later
extends Node

@onready var PlayerScence := preload("res://demo1/Player/Player.tscn")

func _ready() -> void:
	var player: Player = PlayerScence.instantiate()
	add_child(player)
	init_player(player)

func init_player(player: Player) -> void:
	player.position.x = 648/2
	player.position.y = 1152 * 2/3
	player.scale.x = 3.0
	player.scale.y = 3.0

func build() -> World:
	return self
