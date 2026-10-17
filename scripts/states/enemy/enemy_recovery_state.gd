extends State
class_name EnemyRecoveryState

@export var chase_state: State
@export var recovery_duration: float = 1.0

var _elapsed_time: float = 0.0
@onready var _enemy: BaseEnemy = owner

func enter():
    _elapsed_time = 0.0
    _enemy.velocity = Vector2.ZERO

    if _enemy.animation.has_animation("recovery"):
        _enemy.animation.play("recovery")
    elif _enemy.animation.has_animation("idle"):
        _enemy.animation.play("idle")

func update_physics(delta: float):
    _elapsed_time += delta

    if _elapsed_time >= recovery_duration:
        switch_state.emit(chase_state)
