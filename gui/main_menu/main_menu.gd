extends Control

@export var _start_button: Button
@export var _settings_button: Button
@export var _quit_button: Button
@onready var _pop_sfx = preload("res://gui/sfx/pop.wav")

func _ready() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	_start_button.pressed.connect(_on_start_button_pressed)
	_settings_button.pressed.connect(_on_settings_button_pressed)
	_quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed() -> void:
	SoundManager.play(_pop_sfx, -8.0)
	get_tree().change_scene_to_file("res://gui/weapon_select/weapon_select.tscn")

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/settings/settings.tscn")

func _on_quit_button_pressed() -> void:
	SoundManager.play(_pop_sfx, -8.0)
	get_tree().quit()
