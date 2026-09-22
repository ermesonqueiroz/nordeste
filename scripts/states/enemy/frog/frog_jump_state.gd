extends State
class_name FrogJumpState

@export var idle_state: State

@onready var _enemy: FrogEnemy = owner

var _initial_jump_timer: float = 0.4
var _jump_timer: float = 0.0

func enter():
	_jump_timer = _initial_jump_timer
	_enemy.animation.play("movement")

func update_physics(delta: float):
	_jump_timer -= delta

	if _jump_timer <= 0:
		switch_state.emit(idle_state)
		return

	var character = get_tree().get_first_node_in_group("player")
	var _target_direction = _enemy.position.direction_to(character.global_position).normalized()

	_enemy.velocity = _target_direction * 300
	_enemy.move_and_slide()

	var progress = clamp(1.0 - (_jump_timer / _initial_jump_timer), 0.0, 1.0)
	var jump_curve = sin(progress * PI)

	var scale_factor = 1.0 + (jump_curve * 0.3)
	_enemy.texture.scale = Vector2.ONE * scale_factor

	var max_shadow_offset = 15.0
	_enemy.shadow.position.y = _enemy.initial_shadow_y + (jump_curve * max_shadow_offset)

	var shadow_scale_factor = 1.0 + (jump_curve * 0.1)
	_enemy.shadow.scale = _enemy.initial_shadow_scale * shadow_scale_factor

func exit():
	_enemy.shadow.position.y = _enemy.initial_shadow_y
	_enemy.shadow.modulate = _enemy.initial_shadow_modulate
	_enemy.shadow.scale = _enemy.initial_shadow_scale
	_enemy.texture.scale = Vector2.ONE
	_enemy.scale = Vector2.ONE
