extends Control
class_name Settings

@export var _window_mode_option: HorizontalSpin
@export var _apply_button: Button
@export var _back_button: Button

var selected_window_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED

func _ready() -> void:
	var current_mode = DisplayServer.window_get_mode()
	_window_mode_option.current_index = 0 if current_mode == DisplayServer.WINDOW_MODE_WINDOWED else 1

	_window_mode_option.option_changed.connect(_on_window_mode_option_changed)
	_apply_button.pressed.connect(_on_apply_button_pressed)
	_back_button.pressed.connect(_on_back_button_pressed)

func _on_window_mode_option_changed(_index: int, value: Variant) -> void:
	selected_window_mode = value as DisplayServer.WindowMode

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")

func _on_apply_button_pressed() -> void:
	DisplayServer.window_set_mode(selected_window_mode)

	if selected_window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
