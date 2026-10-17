extends State
class_name EnemyWindupState

@export var attack_state: State
@export var windup_duration: float = 0.5

var _elapsed_time: float = 0.0
@onready var _enemy: BaseEnemy = owner

func enter():
	_elapsed_time = 0.0
	_enemy.velocity = Vector2.ZERO

	if _enemy.animation.has_animation("prepare"):
		_enemy.animation.play("prepare")

func update_physics(delta: float):
	_elapsed_time += delta

	if _elapsed_time >= windup_duration:
		switch_state.emit(attack_state)
