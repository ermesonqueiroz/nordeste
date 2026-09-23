extends AnimatedSprite2D

@export var jump_state: State

func _ready():
	visible = false
	$"../StateMachine".state_exited.connect(_on_state_exited)

func _on_state_exited(state: State):
	if state != jump_state:
		return

	visible = true
	play("default")
	await animation_finished
	visible = false
