extends State
class_name EnemyHitState

@export_category("States")
@export var chase_state: State
@export var die_state: State

@onready var _enemy: BaseEnemy = owner

func enter():
	await get_tree().create_timer(0.3).timeout
	switch_state.emit(chase_state if _enemy.health > 0 else die_state)
