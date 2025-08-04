extends Control

@onready var score := $Score
@onready var loop := $Loop
@onready var anim_bg := $AnimationBG
@onready var anim_title := $AnimationTitle
@onready var anim_button := $AnimationButton
@onready var anim_text := $AnimationText
@onready var anim_numbers := $AnimationNumbers

func title_sound():
	Audio.play_sound("ui/failed.wav")

func appear():
	score.text = "0"
	loop.text = "0"
	anim_bg.play("act")
	anim_title.play("act")
	anim_button.play("act")
	anim_text.play("act")
	anim_numbers.play("act")
	visible = true

func _on_restart_pressed() -> void:
	restart()

func restart():
	anim_bg.stop()
	anim_title.stop()
	anim_button.stop()
	anim_text.stop()
	anim_numbers.stop()
	anim_bg.play("RESET")
	anim_title.play("RESET")
	anim_button.play("RESET")
	anim_text.play("RESET")
	anim_numbers.play("RESET")
	score.reset()
	loop.reset()
	visible = false
	PlayerStats.death_reset_requested.emit()
