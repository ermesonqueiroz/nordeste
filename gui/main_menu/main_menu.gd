extends Control

@export var _start_button: Button
@export var _quit_button: Button
@onready var _hover_sfx = preload("res://gui/upgrade_button/hover_sfx.mp3")
@onready var _pop_sfx = preload("res://gui/sfx/pop.wav")

func _ready() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	_setup_button_pivot(_start_button)
	_setup_button_pivot(_quit_button)

	_start_button.pressed.connect(_on_start_button_pressed)
	_start_button.mouse_entered.connect(func(): _on_mouse_entered(_start_button))
	_start_button.mouse_exited.connect(func(): _on_mouse_exited(_start_button))
	_start_button.button_down.connect(func(): _on_button_down(_start_button))
	_start_button.button_up.connect(func(): _on_button_up(_start_button))

	_quit_button.pressed.connect(_on_quit_button_pressed)
	_quit_button.mouse_entered.connect(func(): _on_mouse_entered(_quit_button))
	_quit_button.mouse_exited.connect(func(): _on_mouse_exited(_quit_button))
	_quit_button.button_down.connect(func(): _on_button_down(_quit_button))
	_quit_button.button_up.connect(func(): _on_button_up(_quit_button))

func _setup_button_pivot(button: Button) -> void:
	button.pivot_offset = button.size / 2.0

	if not button.resized.is_connected(func(): button.pivot_offset = button.size / 2.0):
		button.resized.connect(func(): button.pivot_offset = button.size / 2.0)

func _on_start_button_pressed() -> void:
	SoundManager.play(_pop_sfx, -8.0)
	get_tree().change_scene_to_file("res://gui/weapon_select/weapon_select.tscn")

func _on_quit_button_pressed() -> void:
	SoundManager.play(_pop_sfx, -8.0)
	get_tree().quit()

func _on_mouse_entered(button: Button) -> void:
	SoundManager.play(_hover_sfx, -12.0)
	_animate_scale(button, Vector2(1.1, 1.1), 0.12, Tween.TRANS_BACK, Tween.EASE_OUT)

func _on_mouse_exited(button: Button) -> void:
	_animate_scale(button, Vector2(1.0, 1.0), 0.35, Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func _on_button_down(button: Button) -> void:
	_animate_scale(button, Vector2.ONE * 0.95, 0.12, Tween.TRANS_BACK, Tween.EASE_OUT)

func _on_button_up(button: Button) -> void:
	if ClassDB.class_exists("Node"):
		pass

	var tween = button.create_tween().set_parallel(false)
	tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2.ONE * 1.1, 0.25)

	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2.ONE, 0.12)

func _animate_scale(button: Button, target_scale: Vector2, duration: float, trans: Tween.TransitionType, ease_tpe: Tween.EaseType) -> void:
	if button.has_meta("active_tween"):
		var existing_tween = button.get_meta("active_tween")
		if existing_tween and is_instance_valid(existing_tween) and existing_tween.is_running():
			existing_tween.kill()

	var tween = button.create_tween().set_trans(trans).set_ease(ease_tpe)
	tween.tween_property(button, "scale", target_scale, duration)

	button.set_meta("active_tween", tween)
