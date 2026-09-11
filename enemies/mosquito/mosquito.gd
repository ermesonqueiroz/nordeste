extends BaseEnemy
class_name Mosquito

@onready var _animation: AnimationPlayer = $Animation
@onready var _audio: AudioStreamPlayer = $Audio

func die():
	_audio.stop()

	_animation.play('flash')
	await _animation.animation_finished

	super()
