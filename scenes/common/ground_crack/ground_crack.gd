extends AnimatedSprite2D
class_name GroundCrack

@export var time_to_exit: float = 4

func _ready():
	await get_tree().create_timer(time_to_exit).timeout
	play("exit")
	await animation_finished
	queue_free()
