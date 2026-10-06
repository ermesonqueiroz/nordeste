extends BaseEnemy
class_name TejoEnemy

@export var attack_state: State

@onready var state_machine: StateMachine = $StateMachine
@onready var sprite_trail: SpriteTrail = $SpriteTrail

func _ready() -> void:
	sprite_trail.enabled = false
	state_machine.state_entered.connect(_on_state_entered)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	sprite_group.scale.x = -1 if velocity.x < 0 else 1

func _on_state_entered(state: State):
	sprite_trail.enabled = state == attack_state
