extends BaseProjectile
class_name ChinelaProjectile

func _physics_process(delta: float) -> void:
	position += direction * 300 * delta
	rotation += 5 * delta
