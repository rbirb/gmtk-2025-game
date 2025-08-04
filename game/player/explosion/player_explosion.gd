extends AnimatedSprite2D

func _ready() -> void:
	Audio.play_sound("player/explosion/"+str(randi_range(1, 2))+".wav", 0.0)

func _on_animation_finished() -> void:
	queue_free()
