extends Control
class_name PauseMenu

@export var _resume_button: Button
@export var _main_menu_button: Button

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if not visible:
			show_screen()
		else:
			hide_screen()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_resume_button.pressed.connect(_on_resume_button_pressed)
	_main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func show_screen() -> void:
	show()
	get_tree().paused = true

func hide_screen() -> void:
	hide()
	get_tree().paused = false

func _on_resume_button_pressed() -> void:
	hide_screen()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")
