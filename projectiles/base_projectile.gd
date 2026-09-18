extends HitBox
class_name BaseProjectile

@export_category("Variables")
@export var speed = 180.0
@export var lifespan: float = 1.0

@onready var _spriteGroup = $SpriteGroup

var direction: Vector2
var spawn_position: Vector2
var spawn_rotation: float

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation
	knockback_direction = direction

	await get_tree().create_timer(3 * lifespan / 4).timeout

	var tween = get_tree().create_tween()
	tween.tween_property(
		_spriteGroup,
		"scale",
		Vector2.ZERO,
		lifespan / 4
	)
	tween.chain().tween_callback(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
