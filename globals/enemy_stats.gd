extends Node
signal kills_updated

const DEFAULT_STATS: Dictionary[Enemy.TYPES, Dictionary] = {
	Enemy.TYPES.CIRCLE: {},
}

var current_type := random_type()
var killed_type = null

var speed_add := 0
var damage_add := 0
var count_add := 0
var spawn_cooldown_subtract := 0.0
var kills_required := 0:
	set(value):
		kills_required = value
		kills_updated.emit()

func random_type() -> Enemy.TYPES:
	return randi_range(0, Enemy.TYPES.keys().size()-1)

func next_level_reset():
	if kills_required == 0:
		current_type = random_type()
		killed_type

func death_reset():
	current_type = random_type()
	killed_type = null
	speed_add = 0
	damage_add = 0
	count_add = 0
	spawn_cooldown_subtract = 0
	kills_required = 0
