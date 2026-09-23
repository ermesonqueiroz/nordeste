extends State
class_name FrogSmashJumpAttackState

@export var idle_state: State
@export var shadow: Node2D
@export var screen_shake_intensity: int = 0
@export var jump_impact_sprite: AnimatedSprite2D
@export var max_shadow_offset: float = 15.0
@export var ground_impact_sfx: AudioStream

@onready var _enemy: BaseEnemy = owner
@onready var initial_shadow_y: float = shadow.position.y
@onready var initial_shadow_modulate: Color = shadow.modulate
@onready var initial_shadow_scale: Vector2 = shadow.scale

@export var wind_up_duration: float = 0.3
@export var jump_duration: float = 0.48

var _current_timer: float = 0.0
var _is_jumping: bool = false

var _start_position: Vector2
var _target_position: Vector2

func enter():
	_current_timer = wind_up_duration
	_is_jumping = false

	_enemy.animation.play("wind_up")

	_start_position = _enemy.global_position
	var character = get_tree().get_first_node_in_group("player")
	_target_position = character.global_position

func update_physics(delta: float):
	_current_timer -= delta
	var character = get_tree().get_first_node_in_group("player")

	if not _is_jumping:
		if _current_timer <= 0:
			_is_jumping = true
			_current_timer = jump_duration

			_start_position = _enemy.global_position
			if character:
				_target_position = character.global_position
			else:
				_target_position = _start_position

			_enemy.animation.play("smash_jump_attack")

		return

	if _current_timer <= 0:
		_enemy.global_position = _target_position
		switch_state.emit(idle_state)
		return

	var _target_direction = _enemy.position.direction_to(character.global_position).normalized()

	var progress = clamp(1.0 - (_current_timer / jump_duration), 0.0, 1.0)
	_enemy.global_position = _start_position.lerp(_target_position, progress)

	var jump_curve = sin(progress * PI)

	var scale_factor = 1.0 + (jump_curve * 0.3)
	_enemy.texture.scale = Vector2.ONE * scale_factor

	shadow.position.y = initial_shadow_y + (jump_curve * max_shadow_offset)

	var shadow_scale_factor = 1.0 - (jump_curve * 0.1)
	shadow.scale = initial_shadow_scale * shadow_scale_factor

func exit():
	if ground_impact_sfx:
		SoundManager.play(ground_impact_sfx, -8)

	var camera = get_tree().get_first_node_in_group("camera")
	if camera and screen_shake_intensity > 0:
		camera.screen_shake(screen_shake_intensity, 0.3)

	shadow.position.y = initial_shadow_y
	shadow.modulate = initial_shadow_modulate
	shadow.scale = initial_shadow_scale
	_enemy.texture.scale = Vector2.ONE
	_enemy.scale = Vector2.ONE
