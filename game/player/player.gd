extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_anim: AnimationPlayer = $AnimationFlash
@onready var invincible_timer: Timer = $Invincible
# Limits of map
const HORIZONTAL_BORDER_POS_LEFT := 10
const HORIZONTAL_BORDER_POS_RIGHT := 650
const VERTICAL_BORDER_POS_UP := 50
const VERTICAL_BORDER_POS_DOWN := 900
var current_frame := 3
@onready var bullet_spawn: Path2D = $BulletSpawn
const bullet = preload("res://game/player/player_projectile.tscn")
@onready var shoot_cooldown := $ShootCooldown
const player_explosion := preload("res://game/player/explosion/player_explosion.tscn")
@onready var death_anim := $AnimationDeath

func get_spawner_pos() -> Vector2:
	return Vector2(position.x+bullet_spawn.curve.get_point_position(0).x, position.x+bullet_spawn.curve.get_point_position(1).x)

func get_spawner_height() -> float:
	return position.y+bullet_spawn.curve.get_point_position(0).y

func _ready() -> void:
	PlayerStats.damaged.connect(on_damaged)
	PlayerStats.died.connect(on_died)
	PlayerStats.death_reset_requested.connect(death_reset)
	PlayerStats.shoot_cooldown_changed.connect(shoot_cooldown_update)

func _process(delta: float) -> void:
	handle_animation()
	
	handle_movement()
	
	handle_shooting()

func handle_animation():
	if Input.is_action_pressed("left"):
		current_frame = 0
	elif Input.is_action_pressed("right"):
		current_frame = 6
	else:
		current_frame = 3

func handle_movement():
	if Global.state != Global.STATE_LEVEL:
		return
	if Input.is_action_pressed("left"):
		if not position.x < HORIZONTAL_BORDER_POS_LEFT:
			position.x -= PlayerStats.speed
	if Input.is_action_pressed("right"):
		if not position.x > HORIZONTAL_BORDER_POS_RIGHT:
			position.x += PlayerStats.speed
	if Input.is_action_pressed("up"):
		if not position.y < VERTICAL_BORDER_POS_UP:
			position.y -= PlayerStats.speed
	if Input.is_action_pressed("down"):
		if not position.y > VERTICAL_BORDER_POS_DOWN:
			position.y += PlayerStats.speed

func handle_shooting():
	if Global.state != Global.STATE_LEVEL:
		return
	if Input.is_action_pressed("shoot"):
		if shoot_cooldown.is_stopped():
			shoot()
			shoot_cooldown.start()

func shoot():
	Audio.play_sound("player/shoot.wav", -10)
	var pos := get_spawn_pos(PlayerStats.bullet_amount)
	for p in pos:
		var b = bullet.instantiate()
		Global.view.level.add_child(b)
		b.position = p

func get_spawn_pos(n: int) -> Array[Vector2]:
	var spawner_pos := get_spawner_pos()
	var spawner_height := get_spawner_height()
	var part = abs(spawner_pos.x - spawner_pos.y) / (n+1)
	var out: Array[Vector2]
	for i in range(n):
		out.append(Vector2(spawner_pos.x + part*(i+1), spawner_height))
	return out

func on_died():
	Audio.stop_current_song(true)
	Global.view.ui_level.disappear()
	death_anim.play("death")
	Audio.play_sound("player/predeath.wav")
	await death_anim.animation_finished
	Global.death_ui_appear_request.emit()

func explode():
	Global.view.level.camera.start_shake(0.5)
	Global.explode.emit()
	var px = player_explosion.instantiate()
	Global.view.level.add_child(px)
	px.global_position = global_position

func on_damaged():
	Audio.play_sound("player/damaged.wav")
	PlayerStats.i_frames = true
	flash_anim.play("flash")
	invincible_timer.start()

func death_reset():
	shoot_cooldown.wait_time = PlayerStats.DEFAULT_STATS["shoot_cooldown"]
	death_anim.play("RESET")

func shoot_cooldown_update():
	shoot_cooldown.wait_time = PlayerStats.shoot_cooldown

func _on_turn_animation_timeout() -> void:
	if current_frame < sprite.frame:
		sprite.frame -= 1
	elif current_frame > sprite.frame:
		sprite.frame += 1

func _on_invincible_timeout() -> void:
	PlayerStats.i_frames = false
	flash_anim.play("RESET")
	flash_anim.stop()
