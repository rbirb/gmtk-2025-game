extends TextureButton

@onready var anim_shadow: AnimationPlayer = $AnimationShadow
@onready var anim_button: AnimationPlayer = $AnimationButton

func _on_pressed() -> void:
	Audio.play_sound("ui/button/click.mp3", 18)
	anim_shadow.play("press")
	anim_button.play("press")

func _on_mouse_entered() -> void:
	Audio.play_sound("ui/button/hover.mp3")
	anim_shadow.play("hover")
	anim_button.play("hover")

func _on_mouse_exited() -> void:
	anim_shadow.play("unhover")
	anim_button.play("unhover")
