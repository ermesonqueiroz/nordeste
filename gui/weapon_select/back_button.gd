extends Button

@onready var _hover_sfx = preload("res://gui/upgrade_button/hover_sfx.mp3")
@onready var _pop_sfx = preload("res://gui/sfx/pop.wav")

var animation_tween: Tween

func _ready() -> void:
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	self.button_down.connect(_on_button_down)
	self.button_up.connect(_on_button_up)
	self.pressed.connect(_on_pressed)

	pivot_offset = size / 2.0

func _on_mouse_entered() -> void:
	SoundManager.play(_hover_sfx, -12.0)

	if animation_tween and animation_tween.is_running():
		animation_tween.kill()

	animation_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.12)

func _on_mouse_exited() -> void:
	if animation_tween and animation_tween.is_running():
		animation_tween.kill()

	animation_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.35)

func _on_button_down() -> void:
	if animation_tween and animation_tween.is_running():
		animation_tween.kill()

	animation_tween = create_tween()
	animation_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "scale", Vector2.ONE * 0.95, 0.12)

func _on_button_up() -> void:
	SoundManager.play(_pop_sfx, -8.0)

	if animation_tween and animation_tween.is_running():
		animation_tween.kill()

	animation_tween = create_tween()
	animation_tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "scale", Vector2.ONE * 1.1, 0.25)

	animation_tween.chain()
	animation_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(self, "scale", Vector2.ONE, 0.12)

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")
