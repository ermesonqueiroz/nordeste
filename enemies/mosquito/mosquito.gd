extends BaseEnemy
class_name Mosquito

@onready var _audio: AudioStreamPlayer = $Audio

func die():
	_audio.stop()
	super.die()
