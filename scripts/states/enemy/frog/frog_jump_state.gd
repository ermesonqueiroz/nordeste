extends State
class_name FrogJumpState

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

	shadow.position.y = initial_shadow_y + (jump_curve * max_shadow_offset)

	var shadow_scale_factor = 1.0 - (jump_curve * 0.1)
	shadow.scale = initial_shadow_scale * shadow_scale_factor

func exit():
	SoundManager.play(ground_impact_sfx, -8)
	var camera = get_tree().get_first_node_in_group("camera")
	if camera and screen_shake_intensity > 0:
		camera.screen_shake(screen_shake_intensity, 0.3)

	shadow.position.y = initial_shadow_y
	shadow.modulate = initial_shadow_modulate
	shadow.scale = initial_shadow_scale
	_enemy.texture.scale = Vector2.ONE
	_enemy.scale = Vector2.ONE
