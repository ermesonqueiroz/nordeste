extends Node2D
class_name GameLevel

@export var _character: BaseCharacter

@onready var _game_over: ColorRect = $GUI/GameOver
@onready var _level_up: ColorRect = $GUI/LevelUp
@onready var _boss_healthbar: PackedScene = preload("res://gui/boss_healthbar/boss_healthbar.tscn")

var pending_level_ups: int = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	GameManager.reset_stats()
	_game_over.hide()
	_level_up.hide()

	_character.health_updated.connect(_on_character_health_updated)
	_character.level_updated.connect(_on_character_level_updated)
	$BossSpawner.boss_spawned.connect(_on_boss_spawned)

	if _level_up.has_signal("upgrade_selected"):
		_level_up.upgrade_selected.connect(_on_upgrade_selected)

func _on_character_level_updated():
	pending_level_ups += 1

	if not _level_up.visible and not get_tree().paused:
		trigger_next_level_up()

func trigger_next_level_up():
	if pending_level_ups > 0:
		_level_up.reset_deck()

		if _level_up.available_upgrades.is_empty():
			pending_level_ups = 0
			return

		pending_level_ups -= 1
		_level_up.show_screen()
		get_tree().paused = true
	else:
		get_tree().paused = false

func _on_upgrade_selected():
	_level_up.hide()

	if pending_level_ups > 0:
		trigger_next_level_up()
	else:
		get_tree().paused = false

func _on_character_health_updated() -> void:
	if _character.current_health <= 0:
		_game_over.show_screen()
		get_tree().paused = true

func _on_boss_spawned(boss: BaseEnemy):
	var new_boss_healthbar: BossHealthbar = _boss_healthbar.instantiate()
	new_boss_healthbar.boss = boss
	$GUI.add_child(new_boss_healthbar)
	$EnemySpawner.enabled = false
	boss.took_damage.connect(_on_boss_took_damage)

func _on_boss_took_damage():
	print($BossSpawner.last_boss.health <= 0)
	$EnemySpawner.enabled = $BossSpawner.last_boss.health <= 0
