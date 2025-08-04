extends AnimatedSprite2D

func sound() -> void:
	Audio.play_sound("enemy/explosion/"+str(randi_range(1, 3))+".wav", -10.0)

func _on_animation_finished() -> void:
	queue_free()
