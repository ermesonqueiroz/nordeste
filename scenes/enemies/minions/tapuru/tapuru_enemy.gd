extends BaseEnemy
class_name TapuruEnemy

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	sprite_group.scale.x = -1 if velocity.x < 0 else 1
