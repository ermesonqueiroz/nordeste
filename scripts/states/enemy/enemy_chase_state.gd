extends State
class_name EnemyChaseState

@export var stop_distance: float = 0
@export var state_on_stop: State

var _update_target_direction_cooldown: float = 0.3
var _update_target_direction_timer: float = 0.0
var _current_target_direction: Vector2 = Vector2.ZERO

@onready var _enemy: BaseEnemy = owner
@onready var character = get_tree().get_first_node_in_group("player")

func update_physics(delta: float):
	_update_target_direction_timer -= delta

	if _update_target_direction_timer <= 0:
		_update_target_direction()
		_update_target_direction_timer = _update_target_direction_cooldown

	if _current_target_direction != Vector2.ZERO:
		_enemy.last_direction = _current_target_direction

	var distance_to_player = _enemy.global_position.distance_to(character.global_position)

	if distance_to_player > stop_distance:
		_enemy.velocity = _current_target_direction * _enemy.move_speed
		_enemy.move_and_slide()
	elif state_on_stop:
		switch_state.emit(state_on_stop)

	if _enemy.velocity != Vector2.ZERO and _enemy.animation.has_animation("movement"):
		_enemy.animation.play("movement")
	elif _enemy.animation.has_animation("idle"):
		_enemy.animation.play("idle")

func _update_target_direction():
	if not character:
		_current_target_direction = Vector2.ZERO
		return

	_current_target_direction = _enemy.global_position.direction_to(character.global_position).normalized()
