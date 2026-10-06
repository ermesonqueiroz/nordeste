extends State
class_name EnemyDashAttackState

@export var chase_state: State
@export var max_dash_speed: float = 600.0
@export var dash_duration: float = 0.4
@export var overshoot_distance: float = 100.0

@onready var woosh_sfx: AudioStream = preload("res://sfx/whoosh.wav")

var _dash_direction: Vector2 = Vector2.ZERO
var _target_position: Vector2 = Vector2.ZERO
var _elapsed_time: float = 0.0

@onready var _enemy: BaseEnemy = owner
@onready var collision_shape: CollisionShape2D = _enemy.get_node("Collision")

func enter():
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		switch_state.emit(chase_state)
		return

	var raw_direction = _enemy.global_position.direction_to(player.global_position)

	if raw_direction == Vector2.ZERO:
		raw_direction = Vector2.RIGHT

	_target_position = player.global_position + (raw_direction * overshoot_distance)
	_dash_direction = _enemy.global_position.direction_to(_target_position)

	_elapsed_time = 0.0

	if collision_shape:
		collision_shape.set_deferred("disabled", true)

	if _enemy.texture.sprite_frames.has_animation("attack"):
		_enemy.texture.play("attack")

	SoundManager.play(woosh_sfx)

func update_physics(delta: float):
	_elapsed_time += delta

	var progress = clamp(_elapsed_time / dash_duration, 0.0, 1.0)
	var speed_curve = sin(progress * PI)

	var current_speed = max_dash_speed * speed_curve
	_enemy.velocity = _dash_direction * current_speed

	_enemy.move_and_slide()

	if _enemy.is_on_wall():
		switch_state.emit(chase_state)
		return

	var to_target = _target_position - _enemy.global_position
	var has_crossed_target = to_target.dot(_dash_direction) <= 0

	if progress >= 1.0 or has_crossed_target:
		switch_state.emit(chase_state)

func exit():
	if collision_shape:
		collision_shape.set_deferred("disabled", false)
