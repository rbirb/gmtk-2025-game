extends TextureRect

@onready var label := $Label

func _ready() -> void:
	EnemyStats.kills_updated.connect(update_kills)
	update_kills()

func update_kills():
	label.text = str(EnemyStats.kills_required)
