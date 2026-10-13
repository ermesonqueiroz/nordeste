extends BaseEnemy
class_name DeathFishEnemy

@export var chase_state: State
@export var attack_state: State
@export var attack_cooldown: float = 5.0

@export_group("Flapping Physics")
@export var base_speed: float = 12.0
@export var float_amplitude: float = 6.0
@export var max_tilt_degrees: float = 15.0

var time_elapsed: float = 0.0
var attack_timer: float = attack_cooldown

func _process(delta: float) -> void:
	sprite_group.scale.x = -1 if velocity.x < 0 else 1

	if $StateMachine.active_state != chase_state:
		return

	attack_timer -= delta
	time_elapsed += delta

	if attack_timer <= 0 and attack_state:
		attack_timer = attack_cooldown
		$StateMachine.switch_state(attack_state)

	var primary_wave = sin(time_elapsed * base_speed)
	var secondary_wave = sin(time_elapsed * (base_speed * 0.5) + 1.5)

	var vertical_offset = (primary_wave * 0.7 + abs(secondary_wave) * 0.3) * float_amplitude
	texture.position.y = vertical_offset

	var tilt_wave = cos(time_elapsed * base_speed + 0.5) * max_tilt_degrees
	texture.rotation = deg_to_rad(tilt_wave)

	var stretch_factor = 1.0 + (primary_wave * 0.08)
	texture.scale = Vector2(1.0 / stretch_factor, stretch_factor)
