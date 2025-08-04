extends TextureRect

@onready var label := $Label
@onready var anim_hit := $AnimationHit

func _ready() -> void:
	PlayerStats.damaged.connect(update_health)
	PlayerStats.damaged.connect(hit)
	PlayerStats.death_reset_requested.connect(update_health)
	#PlayerStats.health_changed.connect(update_health)
	EnemyStats.next_level_reset_requested.connect(update_health)
	update_health()

func update_health():
	label.text = str(PlayerStats.health)

func hit():
	anim_hit.play("hit")
