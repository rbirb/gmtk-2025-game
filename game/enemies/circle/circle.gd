extends Enemy

var target := Vector2(global_position.x, randi_range(1100, 2000))
var time = 0
var t = randf_range(0.2, 0.8) # influences moving towards target
var p = randf_range(0.2, 0.8) # influences oscillating
@onready var flash_anim := $AnimationFlash
const enemy_explosion := preload("res://game/enemies/explosion/enemy_explosion.tscn")

func _ready() -> void:
	enemy_ready()
	self.damaged.connect(on_damaged)
	self.died.connect(on_died)
	speed += randi_range(0, 300)

func on_died():
	var ex = enemy_explosion.instantiate()
	Global.view.level.add_child(ex)
	if not force_die and Global.state != Global.STATE_NEXT_LEVEL_LOAD:
		ex.sound()
	ex.global_position = global_position
	if EnemyStats.current_type == Enemy.TYPES.CIRCLE:
		EnemyStats.kills_required -= 1
		Global.score += 1 + Global.loop
	queue_free()

func on_damaged():
	flash_anim.play("flash")

func _process(delta: float) -> void:
	time += delta
	
	var towards_target = (target - global_position).normalized()
	
	var perpendicular = Vector2(towards_target.y, -towards_target.x)
	
	global_position += (t * towards_target + p * perpendicular * sin(time)) * speed * delta
	
	if global_position.y > 1200:
		queue_free()
