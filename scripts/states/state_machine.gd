extends Node
class_name StateMachine

signal state_exited(state: State)

@export var initial_state: State
var active_state: State

func _ready():
	for child_state: State in get_children():
		child_state.switch_state.connect(switch_state)

	switch_state(initial_state)

func _process(delta: float):
	if active_state:
		active_state.update(delta)

func _physics_process(delta: float):
	if active_state:
		active_state.update_physics(delta)

func switch_state(new_state: State):
	if new_state == active_state:
		return

	if active_state:
		active_state.exit()
		state_exited.emit(active_state)

	active_state = new_state
	active_state.enter()
