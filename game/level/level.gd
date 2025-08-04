extends Node2D

@onready var camera := $Camera2D
@onready var enemy_spawn_top: Path2D = $EnemySpawnTop
@onready var enemy_spawn_side_left: Path2D = $EnemySpawnSideLeft
@onready var wall_spawn_side_left := $WallSpawnSideLeft
@onready var enemy_spawn_side_right: Path2D = $EnemySpawnSideRight
@onready var wall_spawn_side_right := $WallSpawnSideRight
@onready var spawner_top_pos := Vector2(enemy_spawn_top.curve.get_point_position(0).x, enemy_spawn_top.curve.get_point_position(1).x)
@onready var spawner_top_height := enemy_spawn_top.curve.get_point_position(0).y
@onready var spawner_side_left_pos := Vector2(enemy_spawn_side_left.curve.get_point_position(0).y, enemy_spawn_side_left.curve.get_point_position(1).y)
@onready var spawner_side_left_height := enemy_spawn_side_left.curve.get_point_position(0).x
@onready var spawner_side_right_pos := Vector2(enemy_spawn_side_right.curve.get_point_position(0).y, enemy_spawn_side_right.curve.get_point_position(1).y)
@onready var spawner_side_right_height := enemy_spawn_side_right.curve.get_point_position(0).x
@onready var player := get_tree().get_nodes_in_group("Player")[0]
@onready var spawn_pattern_cooldown := $SpawnPatternCooldown
@onready var spawn_damagers_cooldown := $SpawnDamagersCooldown
@onready var spawn_cooldown := $SpawnCooldown
@onready var damager_spawn_cooldown := $DamagerSpawnCooldown
const circle := preload("res://game/enemies/circle/circle.tscn")
const triangle := preload("res://game/enemies/triangle/triangle.tscn")
const cube := preload("res://game/enemies/cube/cube.tscn")
const saw := preload("res://game/enemies/saw/saw_circle.tscn")
const spike := preload("res://game/enemies/spike/spike_triangle.tscn")
const wall := preload("res://game/enemies/wall/wall_cube.tscn")
var spawn_cooldown_count := 0
var damager_spawn_cooldown_count := 0
var last_type := -1
var saw_spawn_x := 0.0

func _ready() -> void:
	PlayerStats.death_reset_requested.connect(death_reset)
	Global.upgrade_ui_disappeared.connect(next_level_load_post)
	EnemyStats.next_level_reset_requested.connect(next_level_reset)

func next_level_reset():
	spawn_cooldown.wait_time = clamp(0.6-EnemyStats.count_add*0.005, 0.1, 0.6)
	damager_spawn_cooldown.wait_time = clamp(0.8-EnemyStats.count_add*0.005, 0.15, 0.8)

func spawn_start():
	spawn_pattern_cooldown.start()
	spawn_damagers_cooldown.start()

func spawn_stop():
	spawn_pattern_cooldown.stop()
	spawn_damagers_cooldown.stop()
	spawn_cooldown.stop()
	damager_spawn_cooldown.stop()

func _on_spawn_pattern_cooldown_timeout() -> void:
	spawn_cooldown_count = EnemyStats.count_add + 1
	spawn_cooldown.start()

func _on_spawn_damagers_cooldown_timeout() -> void:
	damager_spawn_cooldown_count = Global.loop + 1
	if EnemyStats.killed_type == Enemy.TYPES.CIRCLE:
		saw_spawn_x = get_random_spawn_pos(spawner_top_pos, spawner_top_height, true).x
	damager_spawn_cooldown.start()

func _on_spawn_cooldown_timeout() -> void:
	if Global.state != Global.STATE_LEVEL:
		return
	if spawn_cooldown_count < 1:
		spawn_pattern_cooldown.start()
		return
	spawn_enemy()
	spawn_cooldown_count -= 1
	spawn_cooldown.start()

func _on_damager_spawn_cooldown_timeout() -> void:
	if Global.state != Global.STATE_LEVEL:
		return
	if damager_spawn_cooldown_count < 1:
		spawn_damagers_cooldown.start()
		return
	spawn_damager()
	damager_spawn_cooldown_count -= 1
	damager_spawn_cooldown.start()

func spawn_enemy():
	var e := get_random_enemy_type()
	last_type = e
	match e:
		Enemy.TYPES.CIRCLE:
			var pos := get_random_spawn_pos(spawner_top_pos, spawner_top_height, true)
			spawn_circle(pos)
		Enemy.TYPES.TRIANGLE:
			var pos := get_random_spawn_pos(spawner_top_pos, spawner_top_height, true)
			spawn_triangle(pos)
		Enemy.TYPES.CUBE:
			var pos := get_random_spawn_pos(spawner_top_pos, spawner_top_height, true)
			spawn_cube(pos)

func spawn_damager():
	if EnemyStats.killed_type == -1:
		return
	match EnemyStats.killed_type:
		Enemy.TYPES.CIRCLE:
			spawn_saw(Vector2(saw_spawn_x, spawner_top_height))
		Enemy.TYPES.TRIANGLE:
			var rs := randi_range(0, 2)
			match rs:
				0:
					var pos := get_random_spawn_pos(spawner_top_pos, spawner_top_height, true)
					spawn_spike(pos, false, false)
				1:
					var pos := get_random_spawn_pos(spawner_side_left_pos, spawner_side_left_height, false)
					spawn_spike(pos, true, true)
				2:
					var pos := get_random_spawn_pos(spawner_side_right_pos, spawner_side_right_height, false)
					spawn_spike(pos, true, false)
		Enemy.TYPES.CUBE:
			var rs := randi_range(0, 1)
			match rs:
				0:
					var pos :Vector2= wall_spawn_side_left.global_position
					spawn_wall(pos, false)
				1:
					var pos :Vector2= wall_spawn_side_right.global_position
					spawn_wall(pos, true)
		_:
			pass

func spawn_circle(pos: Vector2):
	var e_i = circle.instantiate()
	add_child(e_i)
	e_i.global_position = pos

func spawn_triangle(pos: Vector2):
	var e_i = triangle.instantiate()
	add_child(e_i)
	e_i.global_position = pos

func spawn_cube(pos: Vector2):
	var e_i = cube.instantiate()
	add_child(e_i)
	e_i.global_position = pos

func spawn_saw(pos: Vector2):
	var d_i = saw.instantiate()
	add_child(d_i)
	d_i.global_position = pos

func spawn_spike(pos: Vector2, horizontal: bool, left: bool):
	var d_i = spike.instantiate()
	d_i.horizontal = horizontal
	d_i.left = left
	add_child(d_i)
	d_i.global_position = pos

func spawn_wall(pos: Vector2, left: bool):
	var d_i = wall.instantiate()
	d_i.left = left
	add_child(d_i)
	d_i.global_position = pos

func next_level_load_pre():
	spawn_stop()
	last_type = -1
	level_load_out()

func next_level_load_post():
	if Global.resetted:
		Global.resetted = false
	else:
		EnemyStats.next_level_reset_requested.emit()
	
	cleanup()
	level_load_in()

func level_load_in():
	player.global_position = Global.PLAYER_START_POS
	var tw_player_move := create_tween()
	tw_player_move.tween_property(player, "global_position", Global.PLAYER_READY_POS, 2).from_current().set_trans(Tween.TRANS_SINE)
	await tw_player_move.finished
	Global.state = Global.STATE_LEVEL
	Global.view.ui_level.appear()
	spawn_start()

func level_load_out():
	Global.state = Global.STATE_NEXT_LEVEL_LOAD
	Global.view.ui_level.disappear()
	var tw_player_move_ready := create_tween()
	tw_player_move_ready.tween_property(player, "global_position", Global.PLAYER_READY_POS, 1).from_current().set_trans(Tween.TRANS_SINE)
	await tw_player_move_ready.finished
	var tw_player_move := create_tween()
	tw_player_move.tween_property(player, "global_position", Global.PLAYER_END_POS, 2).from_current().set_trans(Tween.TRANS_SINE)
	await tw_player_move.finished
	Global.upgrade_appear_request.emit()

func get_random_enemy_type() -> Enemy.TYPES:
	match EnemyStats.killed_type:
		Enemy.TYPES.CIRCLE:
			if last_type == Enemy.TYPES.TRIANGLE:
				return Enemy.TYPES.CUBE
			elif last_type == Enemy.TYPES.CUBE:
				return Enemy.TYPES.TRIANGLE
			else:
				return get_random_item([Enemy.TYPES.TRIANGLE, Enemy.TYPES.CUBE])
		Enemy.TYPES.TRIANGLE:
			if last_type == Enemy.TYPES.CIRCLE:
				return Enemy.TYPES.CUBE
			elif last_type == Enemy.TYPES.CUBE:
				return Enemy.TYPES.CIRCLE
			else:
				return get_random_item([Enemy.TYPES.CIRCLE, Enemy.TYPES.CUBE])
		Enemy.TYPES.CUBE:
			if last_type == Enemy.TYPES.TRIANGLE:
				return Enemy.TYPES.CIRCLE
			elif last_type == Enemy.TYPES.CIRCLE:
				return Enemy.TYPES.TRIANGLE
			else:
				return get_random_item([Enemy.TYPES.TRIANGLE, Enemy.TYPES.CIRCLE])
		_:
			if last_type == Enemy.TYPES.CIRCLE:
				return get_random_item([Enemy.TYPES.TRIANGLE, Enemy.TYPES.CUBE])
			elif last_type == Enemy.TYPES.CUBE:
				return get_random_item([Enemy.TYPES.CIRCLE, Enemy.TYPES.TRIANGLE])
			elif last_type == Enemy.TYPES.TRIANGLE:
				return get_random_item([Enemy.TYPES.CIRCLE, Enemy.TYPES.CUBE])
			else:
				return get_random_item([Enemy.TYPES.CIRCLE, Enemy.TYPES.TRIANGLE, Enemy.TYPES.CUBE])

func death_reset():
	cleanup()
	last_type = -1
	spawn_cooldown.wait_time = 0.6
	damager_spawn_cooldown.wait_time = 0.8

func cleanup():
	for n in get_tree().get_nodes_in_group("Enemy"):
		n.queue_free()
	for n in get_tree().get_nodes_in_group("Damager"):
		n.queue_free()
	for n in get_tree().get_nodes_in_group("Projectile"):
		n.queue_free()

func get_random_spawn_pos(spw_pos: Vector2, spw_height:float, horizontal:bool) -> Vector2:
	if horizontal:
		return Vector2(randf_range(spw_pos.x, spw_pos.y), spw_height)
	else:
		return Vector2(spw_height, randf_range(spw_pos.x, spw_pos.y))

func get_random_item(a: Array):
	return a[randi_range(0, a.size()-1)]
