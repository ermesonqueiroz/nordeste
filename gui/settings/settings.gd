extends Control
class_name Settings

@export var _window_mode_option: HorizontalSpin
@export var _apply_button: Button
@export var _back_button: Button
@export var _master_volume_slider: HSlider

var selected_window_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED
var selected_master_volume: float = 1.0

func _ready() -> void:
	if _master_volume_slider:
		_master_volume_slider.min_value = 0.0
		_master_volume_slider.max_value = 1.0
		_master_volume_slider.step = 0.05

		var bus_index = AudioServer.get_bus_index("Master")
		var current_db = AudioServer.get_bus_volume_db(bus_index)
		_master_volume_slider.value = db_to_linear(current_db) if current_db > -80.0 else 0.0

		_master_volume_slider.value_changed.connect(_on_master_volume_changed)

	var current_mode = DisplayServer.window_get_mode()
	_window_mode_option.current_index = 0 if current_mode == DisplayServer.WINDOW_MODE_WINDOWED else 1

	_window_mode_option.option_changed.connect(_on_window_mode_option_changed)
	_apply_button.pressed.connect(_on_apply_button_pressed)
	_back_button.pressed.connect(_on_back_button_pressed)

func _on_master_volume_changed(value: float) -> void:
	selected_master_volume = value

func _on_window_mode_option_changed(_index: int, value: Variant) -> void:
	selected_window_mode = value as DisplayServer.WindowMode

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")

func _apply_audio_volume(linear_value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Master")

	if linear_value <= 0.0:
		AudioServer.set_bus_volume_db(bus_index, -80.0)
	else:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(linear_value))

func _on_apply_button_pressed() -> void:
	_apply_audio_volume(selected_master_volume)
	DisplayServer.window_set_mode(selected_window_mode)

	if selected_window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
