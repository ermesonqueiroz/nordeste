extends CharacterBody2D
class_name BaseEnemy

@export_category("Variables")
@export var move_speed: float = 50.0
@export var max_health: float = 20.0

var player: BaseCharacter
var spawnPosition: Vector2
var health: float

var damage_amount = 10

func _ready() -> void:
	position = spawnPosition
	health = max_health

func _physics_process(_delta: float) -> void:
	if health <= 0:
		return

	var direction = position.direction_to(player.global_position).normalized()
	velocity = direction * move_speed
	move_and_slide()

func take_damage(damage: float) -> void:
	health -= damage

	if health <= 0:
		die()

func die():
	queue_free()


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		player.take_damage(damage_amount)
