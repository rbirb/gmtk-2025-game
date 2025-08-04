extends CanvasLayer

@onready var level := $SVContainer/SViewport/Level
@onready var ui := $SVContainer/SViewport/UI
@onready var ui_level := $SVContainer/SViewport/UI/Level
@onready var ui_upgrade := $SVContainer/SViewport/UI/Upgrade
@onready var ui_death := $SVContainer/SViewport/UI/Death
@onready var ui_paused := $SVContainer/SViewport/UI/Paused
@onready var main_menu := $SVContainer/SViewport/MainMenu

func _ready() -> void:
	EnemyStats.kills_updated.connect(check_kills_required)
	Global.upgrade_appear_request.connect(upgrade_ui_show)
	Global.upgrade_ui_disappeared.connect(upgrade_ui_hide)
	Global.death_ui_appear_request.connect(death_ui_show)
	PlayerStats.death_reset_requested.connect(death_reset)
	Audio.play_song("music/menu.wav", 0, true, 1.0)
	ui.visible = false
	main_menu.visible = true
	ui_level.visible = true
	ui_upgrade.visible = false
	ui_death.visible = false
	ui_paused.visible = false

func upgrade_ui_show():
	ui_level.visible = false
	ui_upgrade.generate()

func upgrade_ui_hide():
	ui_level.visible = true

func death_ui_show():
	ui_level.visible = false
	ui_death.appear()

func death_reset():
	Global.state = Global.STATE_NEXT_LEVEL_LOAD
	level.process_mode = Node.PROCESS_MODE_INHERIT
	ui_level.visible = true
	Audio.play_song("music/main.wav", -17, true, 1.0)
	level.next_level_load_post()

func check_kills_required():
	if EnemyStats.kills_required == 0 and Global.state == Global.STATE_LEVEL:
		level.next_level_load_pre()

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
	main_menu.start_button.disabled = true
	main_menu.anim_move.play("move_2")
	main_menu.anim_trans.play("out")
	await main_menu.anim_trans.animation_finished
	Audio.play_song("music/main.wav", -17, true, 2.0)
	Global.state = Global.STATE_NEXT_LEVEL_LOAD
	level.process_mode = Node.PROCESS_MODE_INHERIT
	level.next_level_load_post()
	main_menu.disappear()
	ui.visible = true
	main_menu.anim_trans.play("in")
	await main_menu.anim_trans.animation_finished

func _on_resume_pressed() -> void:
	resume()

func _on_exit_pressed() -> void:
	get_tree().quit()
