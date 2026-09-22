extends State
class_name EnemyChaseState

var _update_target_direction_cooldown: float = 0.3
var _update_target_direction_timer: float = 0.0
var _current_target_direction: Vector2 = Vector2.ZERO

@onready var _enemy: BaseEnemy = owner

func update_physics(delta: float):
	_update_target_direction_timer -= delta

	if _update_target_direction_timer <= 0:
		_update_target_direction()
		_update_target_direction_timer = _update_target_direction_cooldown

	if _current_target_direction != Vector2.ZERO:
		_enemy.last_direction = _current_target_direction

	_enemy.velocity = _current_target_direction * _enemy.move_speed
	_enemy.move_and_slide()

func _update_target_direction():
	var character = get_tree().get_first_node_in_group("player")
	_current_target_direction = _enemy.position.direction_to(character.global_position).normalized()
