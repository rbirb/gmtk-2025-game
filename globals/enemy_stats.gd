extends Node
signal kills_updated
signal next_level_reset_requested
signal current_type_changed

var current_type := random_type():
	set(value):
		current_type = value
		current_type_changed.emit()
var killed_type = -1

var damage_add := 0
var count_add := 0
var health_add := 0
var kills_required := 3:
	set(value):
		if value > -1:
			kills_required = value
		kills_updated.emit()

func random_type() -> Enemy.TYPES:
	match killed_type:
		Enemy.TYPES.CIRCLE:
			return get_random_item([Enemy.TYPES.TRIANGLE, Enemy.TYPES.CUBE])
		Enemy.TYPES.TRIANGLE:
			return get_random_item([Enemy.TYPES.CIRCLE, Enemy.TYPES.CUBE])
		Enemy.TYPES.CUBE:
			return get_random_item([Enemy.TYPES.CIRCLE, Enemy.TYPES.TRIANGLE])
		_:
			return get_random_item([Enemy.TYPES.CIRCLE, Enemy.TYPES.TRIANGLE, Enemy.TYPES.CUBE])

func _ready() -> void:
	PlayerStats.death_reset_requested.connect(death_reset)
	next_level_reset_requested.connect(next_level_reset)

func next_level_reset():
	killed_type = current_type
	current_type = random_type()
	kills_required = 5 * randi_range(1, 2) + Global.loop

func death_reset():
	current_type = random_type()
	killed_type = -1
	damage_add = 0
	health_add = 0
	count_add = 0
	kills_required = 3

func get_random_item(a: Array):
	return a[randi_range(0, a.size()-1)]
