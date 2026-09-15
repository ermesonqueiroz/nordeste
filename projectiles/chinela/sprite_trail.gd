extends Node2D

@onready var _texture: Sprite2D = $"../SpriteGroup/Texture"
@onready var _projectile: BaseProjectile = $".."

var _time_accumulator: float = 0.0
const SPAWN_INTERVAL: float = 1.0 / 10.0

var _sprite_array: Array[Sprite2D]

func _ready() -> void:
	_setup_sprite_array()

func _setup_sprite_array() -> void:
	for i in 10:
		var new_sprite = _texture.duplicate()
		new_sprite.z_index = 0
		new_sprite.modulate.a = 0
		get_tree().root.add_child.call_deferred(new_sprite)
		_sprite_array.append(new_sprite)

func _process(delta: float) -> void:
	_time_accumulator += delta

	if _time_accumulator >= SPAWN_INTERVAL:
		_time_accumulator = 0.0

		if not _sprite_array.is_empty():
			var sprite = _sprite_array.pop_front()
			sprite.frame = _texture.frame
			sprite.global_position = _projectile.global_position
			sprite.global_rotation = _projectile.global_rotation

			var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_method(func(value): sprite.modulate.a = value, 0.8, 0.0, 1.0)
