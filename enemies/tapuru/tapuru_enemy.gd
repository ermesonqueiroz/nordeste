extends BaseEnemy
class_name TapuruEnemy

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_texture.flip_h = velocity.x < 0
