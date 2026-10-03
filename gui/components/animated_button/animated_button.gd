@tool
extends HBoxContainer
class_name AnimatedButton

signal pressed

@export var button_text: String = "Animated button":
	set(value):
		button_text = value
		if button:
			button.text = value

@export var disabled: bool = false:
	set(value):
		disabled = value
		if button:
			button.disabled = value


@export var offset_distance: float = 6.0

@onready var _pop_sfx = preload("res://gui/sfx/pop.wav")
@onready var left: Label = $Left
@onready var right: Label = $Right
@onready var button: Button = $Button

var animation_tween: Tween

func _ready() -> void:
	left.modulate.a = 0
	right.modulate.a = 0

	button.text = button_text
	button.disabled = disabled

	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.button_down.connect(_on_button_down)
	button.button_up.connect(_on_button_up)
	button.pressed.connect(pressed.emit)

func show_indicators():
	if disabled:
		return

	if animation_tween and animation_tween.is_running():
		animation_tween.kill()

	animation_tween = get_tree().create_tween()

	left.show()
	right.show()

	left.offset_transform_position.x = 0
	right.offset_transform_position.x = 0

	left.modulate.a = 0
	right.modulate.a = 0

	animation_tween.tween_property(left, "modulate:a", 1, 0.2)
	animation_tween.parallel().tween_property(right, "modulate:a", 1, 0.2)

	animation_tween.set_loops()

	animation_tween.tween_property(left, "offset_transform_position:x", -offset_distance, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	animation_tween.parallel().tween_property(right, "offset_transform_position:x", offset_distance, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	animation_tween.tween_property(left, "offset_transform_position:x", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	animation_tween.parallel().tween_property(right, "offset_transform_position:x", 0, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func hide_indicators():
	if animation_tween and animation_tween.is_running():
		animation_tween.kill()

	animation_tween = get_tree().create_tween()

	animation_tween.tween_property(left, "modulate:a", 0, 0.15)
	animation_tween.parallel().tween_property(right, "modulate:a", 0, 0.15)

	left.offset_transform_position.x = 0
	right.offset_transform_position.x = 0

	animation_tween.tween_callback(left.hide)
	animation_tween.tween_callback(right.hide)

func _on_mouse_entered() -> void:
	if disabled:
		return
	show_indicators()

func _on_mouse_exited() -> void:
	if disabled:
		return
	hide_indicators()

func _on_button_down() -> void:
	pass

func _on_button_up() -> void:
	if disabled:
		return
	SoundManager.play(_pop_sfx, -8.0)
