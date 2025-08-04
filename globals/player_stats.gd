extends Node
signal damaged
signal death_reset_requested
signal died
signal shoot_cooldown_changed
#signal health_changed

const DEFAULT_STATS: Dictionary[String, Variant] = {
	"max_health": 5,
	"speed": 6.0,
	"bullet_amount": 1,
	"shoot_cooldown": 0.75,
	"damage": 3,
	"pierce": 1
}

var max_health := DEFAULT_STATS["max_health"]
var health := max_health#:
#	set(value):
#		health = value
#		health_changed.emit()
var speed := DEFAULT_STATS["speed"]
var bullet_amount := DEFAULT_STATS["bullet_amount"]
var shoot_cooldown := DEFAULT_STATS["shoot_cooldown"]:
	set(value):
		shoot_cooldown = value
		shoot_cooldown_changed.emit()
var damage := DEFAULT_STATS["damage"]
var pierce := DEFAULT_STATS["pierce"]
var i_frames := false

func _ready() -> void:
	EnemyStats.next_level_reset_requested.connect(next_level_reset)
	death_reset_requested.connect(death_reset)

func get_damage(amount: int):
	if i_frames or Global.state != Global.STATE_LEVEL:
		return
	health -= amount
	if health <= 0:
		health = 0
		die()
	else:
		damaged.emit()

func next_level_reset():
	health = max_health

func death_reset():
	max_health = DEFAULT_STATS["max_health"]
	health = max_health
	speed = DEFAULT_STATS["speed"]
	bullet_amount = DEFAULT_STATS["bullet_amount"]
	shoot_cooldown = DEFAULT_STATS["shoot_cooldown"]
	damage = DEFAULT_STATS["damage"]
	pierce = DEFAULT_STATS["pierce"]
	i_frames = false

func die():
	Global.state = Global.STATE_DEATH
	died.emit()
	pass
