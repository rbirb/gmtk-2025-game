# Global Script
# Write anything here you want to access from any script of the game
# To access it, write Global.name_of_something
extends Node
signal state_changed

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
var current_score := 0
