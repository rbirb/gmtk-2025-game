extends TextureRect

const types: Dictionary[Enemy.TYPES, Texture2D] = {
	Enemy.TYPES.CIRCLE: preload("res://ui/level/types/circle.png"),
	Enemy.TYPES.TRIANGLE: preload("res://ui/level/types/triangle.png"),
	Enemy.TYPES.CUBE: preload("res://ui/level/types/cube.png"),
}
@onready var icon := $Icon

func _ready() -> void:
	EnemyStats.current_type_changed.connect(update_type)
	update_type()

func update_type():
	icon.texture = types[EnemyStats.current_type]
