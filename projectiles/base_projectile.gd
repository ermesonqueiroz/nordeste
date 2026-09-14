extends Area2D
class_name BaseProjectile

@export_category("Variables")
@export var speed = 180.0
@export var lifespan: float = 1.0

@onready var _audio: AudioStreamPlayer = $Audio

var direction: Vector2
var spawn_position: Vector2
var spawn_rotation: float
var damage: int = 20

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation

	if _audio and _audio.stream:
		_audio.play()

	await get_tree().create_timer(lifespan).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is BaseEnemy:
		var enemy = area.get_parent()
		enemy.take_damage(damage)
		enemy.apply_knockback((enemy.global_position - global_position).normalized(), 200, 0.15)
