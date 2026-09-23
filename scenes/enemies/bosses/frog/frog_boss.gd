extends BaseEnemy
class_name FrogBoss

@export var jump_state: State

@onready var _ground_crack: PackedScene = preload("res://scenes/common/ground_crack/ground_crack.tscn")

func _ready():
	super._ready()
	$StateMachine.state_exited.connect(_on_state_exited)

func _on_state_exited(state: State):
	if state != jump_state:
		return

	var new_ground_crack: AnimatedSprite2D = _ground_crack.instantiate()
	new_ground_crack.play("default")
	new_ground_crack.global_position = global_position + Vector2(-5, 5)

	get_tree().current_scene.add_child(new_ground_crack)
