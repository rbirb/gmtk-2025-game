extends Enemy

const MAX_HEIGHT := 800
const MIN_HEIGHT := 80
const SIZE := Vector2(76, 81)
var clone := false
var tw_move: Tween
const cube := preload("res://game/enemies/cube/cube.tscn")
@onready var sprite := $AnimatedSprite2D
@onready var flash_anim := $AnimationFlash
const enemy_explosion := preload("res://game/enemies/explosion/enemy_explosion.tscn")
@onready var move_cd := $MoveCD

func _ready() -> void:
	enemy_ready()
	self.died.connect(on_died)
	self.damaged.connect(on_damaged)
	if Global.state == Global.STATE_NEXT_LEVEL_LOAD or force_die:
		die()
		return
	if not clone:
		move_cd.start()
	else:
		sprite.play("appear")

func move():
	if tw_move != null:
		if tw_move.is_running():
			await tw_move.finished
	tw_move = create_tween()
	tw_move.tween_property(self, "global_position:y", randi_range(MIN_HEIGHT, MAX_HEIGHT), randf_range(2, 3)).from_current().set_trans(Tween.TRANS_SINE)
	await tw_move.finished
	move_cd.wait_time = randf_range(2.0, 5.0)
	move_cd.start()

func on_damaged():
	flash_anim.play("flash")

func on_died():
	if not clone and Global.state != Global.STATE_NEXT_LEVEL_LOAD:
		if tw_move != null:
			tw_move.kill()
		for i in range(2): # DO NOT CHANGE THE 2
			var c = cube.instantiate()
			c.clone = true
			Global.view.level.add_child.call_deferred(c)
			var r := randi_range(0, 1)
			if i == 0:
				if r == 0:
					c.global_position = Vector2(global_position.x, global_position.y - SIZE.y)
				else:
					c.global_position = Vector2(global_position.x - SIZE.x, global_position.y)
			else:
				if r == 0:
					c.global_position = Vector2(global_position.x + SIZE.x, global_position.y)
				else:
					c.global_position = Vector2(global_position.x, global_position.y + SIZE.y)
	var ex = enemy_explosion.instantiate()
	Global.view.level.add_child(ex)
	if not force_die and Global.state != Global.STATE_NEXT_LEVEL_LOAD:
		ex.sound()
	ex.global_position = global_position
	if EnemyStats.current_type == Enemy.TYPES.CUBE:
		EnemyStats.kills_required -= 1
		Global.score += 1 + Global.loop
	queue_free()

func _process(delta: float) -> void:
	if global_position.y > 1200:
		queue_free()
