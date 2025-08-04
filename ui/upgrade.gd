extends Control

enum PLAYER_UPGRADES {
	PLAYER_ADD_MAX_HEALTH,
	PLAYER_ADD_SPEED,
	PLAYER_ADD_BULLET_AMOUNT,
	PLAYER_SUBTRACT_SHOOT_COOLDOWN,
	PLAYER_ADD_DAMAGE,
	PLAYER_ADD_PIERCE,
}

enum ENEMY_UPGRADES {
	ENEMY_ADD_DAMAGE,
	EMEMY_ADD_COUNT,
	ENEMY_ADD_HEALTH,
}

@onready var player := $Player
@onready var enemy := $Enemy
@onready var player_first_text := $Player/Buttons/PlayerFirst/Label
@onready var player_second_text := $Player/Buttons/PlayerSecond/Label
@onready var enemy_first_text := $Enemy/Buttons/EnemyFirst/Label
@onready var enemy_second_text := $Enemy/Buttons/EnemySecond/Label
var player_upgrade_callable_1: Callable
var player_upgrade_callable_2: Callable
var enemy_upgrade_callable_1: Callable
var enemy_upgrade_callable_2: Callable

func _ready() -> void:
	player.visible = false
	enemy.visible = false

func generate():
	Global.view.main_menu.anim_trans.play("out2")
	await Global.view.main_menu.anim_trans.animation_finished
	visible = true
	Global.view.main_menu.anim_trans.play("in2")
	player.visible = false
	enemy.visible = false
	var player_upgrade_1
	var player_upgrade_2
	var enemy_upgrade_1
	var enemy_upgrade_2
	player_upgrade_1 = get_random_upgrade(PLAYER_UPGRADES)
	for i in range(5):
		player_upgrade_2 = get_random_upgrade(PLAYER_UPGRADES)
		if player_upgrade_2 == player_upgrade_1:
			continue
		else:
			break
	enemy_upgrade_1 = get_random_upgrade(ENEMY_UPGRADES)
	for i in range(5):
		enemy_upgrade_2 = get_random_upgrade(ENEMY_UPGRADES)
		if enemy_upgrade_2 == enemy_upgrade_1:
			continue
		else:
			break
	
	var player_upgrade_info_1 := get_player_upgrade_info(player_upgrade_1)
	var player_upgrade_info_2 := get_player_upgrade_info(player_upgrade_2)
	var enemy_upgrade_info_1 := get_enemy_upgrade_info(enemy_upgrade_1)
	var enemy_upgrade_info_2 := get_enemy_upgrade_info(enemy_upgrade_2)
	
	player_upgrade_callable_1 = player_upgrade_info_1["callable"]
	player_upgrade_callable_2 = player_upgrade_info_2["callable"]
	enemy_upgrade_callable_1 = enemy_upgrade_info_1["callable"]
	enemy_upgrade_callable_2 = enemy_upgrade_info_2["callable"]
	
	player_first_text.text = player_upgrade_info_1["text"]
	player_second_text.text = player_upgrade_info_2["text"]
	enemy_first_text.text = enemy_upgrade_info_1["text"]
	enemy_second_text.text = enemy_upgrade_info_2["text"]
	
	show_player()

func _on_player_first_pressed() -> void:
	if player_upgrade_callable_1 != null:
		player_upgrade_callable_1.call()
		show_enemy()

func _on_player_second_pressed() -> void:
	if player_upgrade_callable_2 != null:
		player_upgrade_callable_2.call()
		show_enemy()

func _on_enemy_first_pressed() -> void:
	if enemy_upgrade_callable_1 != null:
		enemy_upgrade_callable_1.call()
		quit()

func _on_enemy_second_pressed() -> void:
	if enemy_upgrade_callable_2 != null:
		enemy_upgrade_callable_2.call()
		quit()

func get_player_upgrade_info(upgrade: PLAYER_UPGRADES) -> Dictionary[String, Variant]:
	match upgrade:
		PLAYER_UPGRADES.PLAYER_ADD_MAX_HEALTH:
			return {"text":"+5\nmax\nhealth", "callable": func(): PlayerStats.max_health += 5}
		PLAYER_UPGRADES.PLAYER_ADD_SPEED:
			return {"text":"+3\nspeed", "callable": func(): PlayerStats.speed += 3}
		PLAYER_UPGRADES.PLAYER_ADD_BULLET_AMOUNT:
			return {"text":"+1\nbullet\namount", "callable": func(): PlayerStats.bullet_amount += 1}
		PLAYER_UPGRADES.PLAYER_SUBTRACT_SHOOT_COOLDOWN:
			return {"text":"-0.15\nshoot\ncooldown", "callable": func(): PlayerStats.shoot_cooldown -= 0.15}
		PLAYER_UPGRADES.PLAYER_ADD_DAMAGE:
			var rn = get_random_item([2,3,5])
			return {"text":"+"+str(rn)+"\ndamage", "callable": func(): PlayerStats.damage += rn}
		PLAYER_UPGRADES.PLAYER_ADD_PIERCE:
			return {"text":"+1\npiercing", "callable": func(): PlayerStats.pierce += 1}
		_:
			assert(true, "huh")
			return {}

func get_random_item(a: Array):
	return a[randi_range(0, a.size()-1)]

func get_enemy_upgrade_info(upgrade: ENEMY_UPGRADES) -> Dictionary[String, Variant]:
	match upgrade:
		ENEMY_UPGRADES.ENEMY_ADD_DAMAGE:
			var rn = randi_range(1,4)
			return {"text":"+"+str(rn)+"\ndamage", "callable": func(): EnemyStats.damage_add += rn}
		ENEMY_UPGRADES.EMEMY_ADD_COUNT:
			var rn = randi_range(1,3)
			return {"text":"+"+str(rn)+"\ncount", "callable": func(): EnemyStats.count_add += rn}
		ENEMY_UPGRADES.ENEMY_ADD_HEALTH:
			var rn = randi_range(1,10)
			return {"text":"+"+str(rn)+"\nhealth", "callable": func(): EnemyStats.health_add += rn}
		_:
			assert(true, "huh2")
			return {}

func get_random_upgrade(en: Dictionary):
	return en.values()[randi_range(0, en.values().size()-1)]

func show_player():
	player.visible = true
	enemy.visible = false

func show_enemy():
	player.visible = false
	enemy.visible = true

func quit():
	Global.view.main_menu.anim_trans.play("out2")
	await Global.view.main_menu.anim_trans.animation_finished
	visible = false
	Global.view.main_menu.anim_trans.play("in2")
	Global.upgrade_ui_disappeared.emit()
