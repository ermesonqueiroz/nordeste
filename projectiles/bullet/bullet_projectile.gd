extends BaseProjectile
class_name BulletProjectile

@onready var _spriteGroup = $SpriteGroup

func _ready() -> void:
	super._ready()

	var tween = get_tree().create_tween()
	tween.tween_property(
		_spriteGroup,
		"scale",
		Vector2.ZERO,
		lifespan / 4
	).set_delay(3 * lifespan / 4)
