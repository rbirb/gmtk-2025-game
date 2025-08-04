# Global Script
# Write anything here you want to access from any script of the game
# To access it, write Global.name_of_something
# ! do not add class_name, it's already global
extends Node
signal state_changed
signal upgrade_appear_request
signal upgrade_ui_disappeared
signal death_ui_appear_request
signal explode

enum {
	STATE_MAIN_MENU,
	STATE_LEVEL,
	STATE_PAUSED,
	STATE_DEATH,
	STATE_NEXT_LEVEL_LOAD
}

var state := STATE_MAIN_MENU:
	set(value):
		state = value
		state_changed.emit()
var loop := 0
var score := 0
var resetted := true

@onready var view := $/root/View
const PLAYER_START_POS := Vector2(338.0, 1161.0)
const PLAYER_READY_POS := Vector2(338.0, 492.0)
const PLAYER_END_POS := Vector2(338.0, -100.0)
const LEVEL_TOP_LEFT := Vector2.ZERO
const LEVEL_TOP_RIGHT := Vector2(670, 0)
const LEVEL_BOTTOM_LEFT := Vector2(0, 925)
const LEVEL_BOTTOM_RIGHT := Vector2(670, 925)

func _ready() -> void:
	PlayerStats.death_reset_requested.connect(death_reset)
	EnemyStats.next_level_reset_requested.connect(next_level_reset)

func next_level_reset():
	loop += 1

func death_reset():
	loop = 0
	score = 0
	resetted = true
