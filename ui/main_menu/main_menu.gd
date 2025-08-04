extends CanvasLayer

@onready var menu := $Menu
@onready var settings := $Settings
@onready var anim_trans := $AnimationTrans
@onready var anim_move := $Menu/AnimationMove
@onready var bg := $Background
@onready var start_button := $Menu/Buttons/Start

func disappear():
	bg.visible = false
	menu.visible = false
	settings.visible = false

func _ready() -> void:
	settings.visible = false
	menu.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_settings_pressed() -> void:
	settings.visible = true
	menu.visible = false

func _on_back_pressed() -> void:
	settings.visible = false
	menu.visible = true
