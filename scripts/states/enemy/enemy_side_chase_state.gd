extends State
class_name EnemySideChaseState

@export var attack_state: State
@export var attack_range_x: float = 40.0
@export var vertical_tolerance: float = 15.0

var _update_target_direction_cooldown: float = 0.3
var _update_target_direction_timer: float = 0.0
var _current_target_direction: Vector2 = Vector2.ZERO

@onready var _enemy: BaseEnemy = owner

func update_physics(delta: float):
	var character = get_tree().get_first_node_in_group("player")
	if not character:
		return

	if _is_beside_player(character) and attack_state:
		switch_state.emit(attack_state)
		return

	_update_target_direction_timer -= delta

	if _update_target_direction_timer <= 0:
		_update_target_direction(character)
		_update_target_direction_timer = _update_target_direction_cooldown

	if _current_target_direction != Vector2.ZERO:
		_enemy.last_direction = _current_target_direction

	_enemy.velocity = _current_target_direction * _enemy.move_speed
	_enemy.move_and_slide()

	if _enemy.texture.sprite_frames.has_animation("movement"):
		_enemy.texture.play("movement")

func _update_target_direction(character):
	_current_target_direction = _enemy.position.direction_to(character.global_position).normalized()

func _is_beside_player(character: Node2D) -> bool:
	var distance_vector = character.global_position - _enemy.global_position
	var abs_x = abs(distance_vector.x)
	var abs_y = abs(distance_vector.y)

	return abs_x <= attack_range_x and abs_y <= vertical_tolerance
