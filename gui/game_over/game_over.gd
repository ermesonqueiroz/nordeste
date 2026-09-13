extends ColorRect

@onready var _restart_button: Button = $Column/RestartButton

func _ready() -> void:
	visible = false
	_restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
