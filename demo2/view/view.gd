extends CanvasLayer

@onready var level := $SVContainer/SViewport/Level
@onready var ui := $SVContainer/SViewport/UI
@onready var ui_level := $SVContainer/SViewport/UI/Level
@onready var ui_upgrade := $SVContainer/SViewport/UI/Upgrade
@onready var ui_paused := $SVContainer/SViewport/UI/Paused
@onready var main_menu := $SVContainer/SViewport/MainMenu

func _ready() -> void:
	Audio.play_song("music/menu.wav", 0, true, 2.0)
	ui.visible = false
	main_menu.visible = true
	ui_level.visible = true
	ui_upgrade.visible = false
	ui_paused.visible = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if Global.state == Global.STATE_LEVEL:
			pause()
		else:
			resume()

func pause():
	if Global.state != Global.STATE_LEVEL:
		return
	Global.state = Global.STATE_PAUSED
	level.process_mode = Node.PROCESS_MODE_DISABLED
	ui_level.visible = false
	ui_paused._on_back_pressed()
	ui_paused.visible = true

func resume():
	if Global.state != Global.STATE_PAUSED:
		return
	Global.state = Global.STATE_LEVEL
	level.process_mode = Node.PROCESS_MODE_INHERIT
	ui_level.visible = true
	ui_paused.visible = false

func _on_start_pressed() -> void:
	Global.state = Global.STATE_LEVEL
	level.process_mode = Node.PROCESS_MODE_INHERIT
	ui.visible = true
	main_menu.visible = false
	Audio.play_song("music/main.wav", -17, true, 2.0)

func _on_resume_pressed() -> void:
	resume()

func _on_exit_pressed() -> void:
	get_tree().quit()
