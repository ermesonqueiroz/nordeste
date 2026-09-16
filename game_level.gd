extends Node2D
class_name GameLevel

@export var _character: BaseCharacter

@onready var _game_over: ColorRect = $GUI/GameOver
@onready var _level_up: ColorRect = $GUI/LevelUp

var pending_level_ups: int = 0

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	_game_over.hide()
	_level_up.hide()

	_character.healthUpdated.connect(_on_character_health_updated)
	_character.level_updated.connect(_on_character_level_updated)

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
	if _character.currentHealth <= 0:
		_game_over.show()
		get_tree().paused = true
