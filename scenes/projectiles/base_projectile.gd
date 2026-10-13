extends HitBox
class_name BaseProjectile

@export_category("Variables")
@export var speed = 360.0
@export var lifespan: float = 0.8

@onready var _spriteGroup = $SpriteGroup

var direction: Vector2
var spawn_position: Vector2
var spawn_rotation: float

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation
	knockback_direction = direction

	await get_tree().create_timer(lifespan).timeout

	var tween = get_tree().create_tween()
	tween.tween_property(
		_spriteGroup,
		"scale",
		Vector2.ZERO,
		0.3
	).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.chain().tween_callback(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
