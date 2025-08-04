extends Enemy

@onready var player := get_tree().get_nodes_in_group("Player")[0]
const bullet := preload("res://game/enemies/triangle/triangle_projectile.tscn")
@onready var move_cooldown := $MoveCooldown
var direction: Vector2
@onready var flash_anim := $AnimationFlash
const enemy_explosion := preload("res://game/enemies/explosion/enemy_explosion.tscn")

func _ready() -> void:
	enemy_ready()
	self.damaged.connect(on_damaged)
	self.died.connect(on_died)

func on_died():
	var ex = enemy_explosion.instantiate()
	Global.view.level.add_child(ex)
	if not force_die and Global.state != Global.STATE_NEXT_LEVEL_LOAD:
		ex.sound()
	ex.global_position = global_position
	if EnemyStats.current_type == Enemy.TYPES.TRIANGLE:
		EnemyStats.kills_required -= 1
		Global.score += 1 + Global.loop
	queue_free()

func on_damaged():
	flash_anim.play("flash")

func _process(delta: float) -> void:
	look_at(player.global_position)
	if global_position.distance_to(player.global_position) < 600 or \
			global_position.x > 0 \
			or global_position.x < 580 \
			or global_position.y > 50 \
			or global_position.y < 900:
		if move_cooldown.is_stopped():
			move()
			move_cooldown.start()
	else:
		global_position = global_position.move_toward(player.global_position, delta * speed)

func move():
	var tw_move := create_tween()
	tw_move.tween_property(self, "global_position", get_random_pos(), move_cooldown.wait_time / 2.0).from_current().set_trans(Tween.TRANS_SINE)
	await tw_move.finished
	shoot()

func shoot():
	Audio.play_sound("enemy/triangle_shoot/"+str(randi_range(2,3))+".wav", -15)
	var b = bullet.instantiate()
	Global.view.level.add_child(b)
	b.position = position
	b.look_at(player.global_position * randf_range(0.7, 1.3))

func get_random_pos() -> Vector2:
	return Vector2(global_position.x + randi_range(-350, 350), global_position.y + randi_range(-350, 350))
