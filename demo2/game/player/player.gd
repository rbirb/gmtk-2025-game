extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var flash_anim: AnimationPlayer = $AnimationFlash
@onready var invincible_timer: Timer = $Invincible
# Limits of map
const HORIZONTAL_BORDER_POS_LEFT := 50
const HORIZONTAL_BORDER_POS_RIGHT := 610
const VERTICAL_BORDER_POS_UP := 50
const VERTICAL_BORDER_POS_DOWN := 900
var current_frame := 3

var bullet_scene = preload("res://demo2/game/player/player_bullet.tscn")

@onready var bullet_container = $BulletContainer

func _ready() -> void:
	PlayerStats.damaged.connect(on_damaged)

func _process(delta: float) -> void:
	handle_animation()
	
	handle_movement()
	
	shoot()

func handle_animation():
	if Input.is_action_pressed("left"):
		current_frame = 0
	elif Input.is_action_pressed("right"):
		current_frame = 6
	else:
		current_frame = 3

func handle_movement():
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

func on_damaged():
	Audio.play_sound("player/damaged.wav")
	PlayerStats.i_frames = true
	flash_anim.play("flash")
	invincible_timer.start()

func _on_turn_animation_timeout() -> void:
	if current_frame < sprite.frame:
		sprite.frame -= 1
	elif current_frame > sprite.frame:
		sprite.frame += 1

func _on_invincible_timeout() -> void:
	PlayerStats.i_frames = false
	flash_anim.play("RESET")
	flash_anim.stop()

func shoot():
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet_scene.instantiate()
		bullet_container.add_child(bullet_instance)
		bullet_instance.global_position = global_position
		bullet_instance.global_position.y -= 50
