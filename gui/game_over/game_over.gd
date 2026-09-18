extends ColorRect

@export var _restart_button: Button
@export var _main_menu_button: Button
@export var _survival_time_label: Label
@export var _enemies_killed_label: Label

@onready var _game_over_sfx: AudioStream = preload("res://sfx/game_over.mp3")

func _ready() -> void:
	visible = false
	_restart_button.pressed.connect(_on_restart_pressed)
	_main_menu_button.pressed.connect(_on_main_menu_pressed)

func show_screen() -> void:
	visible = true
	SoundManager.play(_game_over_sfx, 0, Node.ProcessMode.PROCESS_MODE_ALWAYS)
	GameManager.is_game_active = false

	var total_seconds = int(GameManager.survival_time)
	var minutes = total_seconds / 60.0
	var seconds = total_seconds % 60

	_survival_time_label.text = "%02d:%02d" % [minutes, seconds]
	_enemies_killed_label.text = str(GameManager.enemies_killed)

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")
