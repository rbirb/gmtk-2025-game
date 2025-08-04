extends TextureRect

@onready var label := $Label
@onready var anim_flick := $AnimationFlick

func _ready() -> void:
	EnemyStats.kills_updated.connect(update_kills)
	update_kills()

func update_kills():
	anim_flick.play("flick")
	label.text = str(EnemyStats.kills_required)
