extends Area2D

@export var bullet_speed = 500

func _physics_process(delta):
	global_position.y -= bullet_speed * delta

func _on_visible_notifier_2d_screen_exited():
	queue_free()
