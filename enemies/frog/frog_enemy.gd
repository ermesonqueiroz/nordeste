extends BaseEnemy
class_name FrogEnemy

@onready var _shadow: Sprite2D = $Shadow
@onready var _attack_area: Area2D = $AttackArea
@onready var _tongue: FrogTongue = $FrogTongue

var _initial_idle_timer = 2.0
var _initial_move_timer = 0.4

var idle_timer: float = _initial_idle_timer
var move_timer: float = 0.0
var _attack_timer: float = 0.0

var _player_direction
var _player_are_in_attack_area: bool = false

@onready var _initial_shadow_y: float = _shadow.position.y
@onready var _initial_shadow_modulate: Color = _shadow.modulate
@onready var _initial_shadow_scale: Vector2 = _shadow.scale

func _ready() -> void:
	super._ready()

	_attack_area.body_entered.connect(_on_attack_area_body_entered)
	_attack_area.body_exited.connect(_on_attack_area_body_exited)

func _physics_process(delta: float) -> void:
	if damage_cooldown > 0:
		damage_cooldown -= delta

	if _attack_timer > 0:
		_attack_timer -= delta

		if _attack_timer <= 0:
			_attack_timer = 0
			idle_timer = _initial_idle_timer

		return

	if move_timer > 0:
		animation.play("movement")

		if not _player_direction:
			_player_direction = position.direction_to(player.global_position).normalized()

		velocity = _player_direction * 300
		move_and_slide()

		var progress = clamp(1.0 - (move_timer / _initial_move_timer), 0.0, 1.0)
		var jump_curve = sin(progress * PI)

		var scale_factor = 1.0 + (jump_curve * 0.3)
		_texture.scale = Vector2.ONE * scale_factor

		var max_shadow_offset = 15.0
		_shadow.position.y = _initial_shadow_y + (jump_curve * max_shadow_offset)

		var shadow_scale_factor = 1.0 + (jump_curve * 0.1)
		_shadow.scale = _initial_shadow_scale * shadow_scale_factor

		_shadow.modulate.a = _initial_shadow_modulate.a - (jump_curve * 0.3)

		move_timer -= delta

		if move_timer <= 0:
			move_timer = 0.0
			idle_timer = _initial_idle_timer
			_reset_properties()

		return

	if idle_timer > 0:
		animation.play("idle")
		idle_timer -= delta

		if idle_timer <= 0:
			if _player_are_in_attack_area:
				animation.play("attack")
				await animation.animation_finished

				_player_direction = position.direction_to(player.global_position).normalized()

				_attack()
				return

			idle_timer = 0.0
			move_timer = _initial_move_timer
			_player_direction = null

		return

func _reset_properties() -> void:
	_shadow.position.y = _initial_shadow_y
	_shadow.modulate = _initial_shadow_modulate
	_shadow.scale = _initial_shadow_scale
	_texture.scale = Vector2.ONE
	scale = Vector2.ONE

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		_player_are_in_attack_area = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		_player_are_in_attack_area = false

func _attack() -> void:
	var attack_duration = 1
	_tongue.shoot(_player_direction, attack_duration)
	_player_direction = null
	_attack_timer = attack_duration
