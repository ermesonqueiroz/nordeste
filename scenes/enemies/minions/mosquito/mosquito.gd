extends BaseEnemy
class_name MosquitoEnemy

@export var chase_state: State

var float_speed: float = 4.0
var float_amplitude: float = 4.0

var tilt_speed: float = 6.0
var max_tilt_degrees: float = 5.0

var time_elapsed: float = 0.0

func _process(delta: float) -> void:
	if $StateMachine.active_state != chase_state:
		pass

	time_elapsed += delta
	texture.position.y = sin(time_elapsed * float_speed) * float_amplitude

	var current_tilt = cos(time_elapsed * tilt_speed) * max_tilt_degrees
	texture.rotation = deg_to_rad(current_tilt)
