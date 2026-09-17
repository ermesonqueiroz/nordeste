extends CanvasLayer
class_name Crosshair

@export var _character: BaseCharacter

@onready var sprite: Sprite2D = $Texture
@onready var _label: Label = $Label

var _tween: Tween

func _ready() -> void:
	if _character:
		_character.weapon.ammo_updated.connect(_on_ammo_updated)
		_update_bullets_label()

		if _character.weapon.crosshair:
			sprite.texture = _character.weapon.crosshair

func _process(_delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	sprite.global_position = mouse_position
	_label.global_position = mouse_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_animate_click_down()
		else:
			_animate_click_up()

func _on_ammo_updated() -> void:
	_animate_click_down_and_back()
	_update_bullets_label()

func _animate_click_down() -> void:
	if not sprite:
		return
	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(sprite, "scale", Vector2.ONE * 0.7, 0.08)

func _animate_click_up() -> void:
	if not sprite:
		return
	if _tween and _tween.is_valid():
		_tween.kill()

	_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(sprite, "scale", Vector2.ONE, 0.1)

func _animate_click_down_and_back() -> void:
	if not sprite:
		return
	if _tween and _tween.is_valid():
		_tween.kill()

	sprite.scale = Vector2.ONE
	_tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_tween.tween_property(sprite, "scale", Vector2.ONE * 0.7, 0.08)
	_tween.chain().tween_property(sprite, "scale", Vector2.ONE, 0.1)

func _update_bullets_label() -> void:
	_label.text = str(_character.weapon.ammo)
