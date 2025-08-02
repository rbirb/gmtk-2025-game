extends Node
signal damaged

const DEFAULT_STATS: Dictionary[String, Variant] = {
	"max_health": 5,
	"speed": 6.0,
	"bullet_amount": 1,
	"shoot_cooldown": 0.75,
}

var max_health := DEFAULT_STATS["max_health"]
var health := max_health
var speed := DEFAULT_STATS["speed"]
var bullet_amount := DEFAULT_STATS["bullet_amount"]
var shoot_cooldown := DEFAULT_STATS["shoot_cooldown"]
var i_frames := false

func get_damage(amount: int):
	if i_frames or Global.state != Global.STATE_LEVEL:
		return
	health -= amount
	if health < 0:
		health = 0
		die()
	else:
		damaged.emit()

func death_reset():
	max_health = DEFAULT_STATS["max_health"]
	health = max_health
	speed = DEFAULT_STATS["speed"]
	bullet_amount = DEFAULT_STATS["bullet_amount"]
	shoot_cooldown = DEFAULT_STATS["shoot_cooldown"]
	i_frames = false

func die():
	Audio.play_sound("player/death.wav")
	pass
