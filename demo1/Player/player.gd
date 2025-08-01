class_name Player
extends CharacterBody2D

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left"):
		position.x -= 10
	elif Input.is_action_just_pressed("right"):
		position.x += 10
