extends Control

@onready var menu := $Menu
@onready var settings := $Settings

func _ready() -> void:
	settings.visible = false
	menu.visible = true

func _on_settings_pressed() -> void:
	settings.visible = true
	menu.visible = false

func _on_back_pressed() -> void:
	settings.visible = false
	menu.visible = true
