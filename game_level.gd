extends Node2D
class_name GameLevel

@onready var _gameOver: ColorRect = $GUI/GameOver

func _ready() -> void:
	_gameOver.hide()

func showGameOver():
	_gameOver.show()
	get_tree().paused = true
