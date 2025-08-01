extends TextureRect

@onready var label := $Label

func _ready() -> void:
	PlayerStats.damaged.connect(update_health)
	update_health()

func update_health():
	label.text = str(PlayerStats.health)
