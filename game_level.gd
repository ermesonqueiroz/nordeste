extends Node2D
class_name GameLevel

@export var _character: BaseCharacter

@onready var _game_over: ColorRect = $GUI/GameOver
@onready var _level_up: ColorRect = $GUI/LevelUp

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	_game_over.hide()
	_character.level_updated.connect(_on_character_level_updated)

func _on_character_level_updated():
	_level_up.show_screen()
	get_tree().paused = true

func showGameOver():
	_game_over.show()
	get_tree().paused = true
