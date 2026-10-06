extends Node2D
class_name SpriteTrail

@export var texture: AnimatedSprite2D
@export var enabled: bool = true
@onready var parent: Node2D = get_parent()

var _time_accumulator: float = 0.0
@export var SPAWN_INTERVAL: float = 1.0 / 20.0

var _sprite_array: Array[Sprite2D]

func _ready() -> void:
	_setup_sprite_array()

func _setup_sprite_array() -> void:
	for i in 10:
		var new_sprite = texture.duplicate()
		new_sprite.z_index = 0
		new_sprite.modulate.a = 0
		get_tree().root.add_child.call_deferred(new_sprite)
		_sprite_array.append(new_sprite)

func _process(delta: float) -> void:
	if not enabled:
		return

	_time_accumulator += delta

	if _time_accumulator >= SPAWN_INTERVAL:
		_time_accumulator = 0.0

		if not _sprite_array.is_empty():
			var sprite = _sprite_array.pop_front()
			sprite.frame = texture.frame
			sprite.global_position = parent.global_position
			sprite.global_rotation = parent.global_rotation
			sprite.material = material

			var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_method(func(value): sprite.modulate.a = value, 0.8, 0.0, 1.0)
