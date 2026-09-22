extends State
class_name FrogAttackState

@export var idle_state: State

@onready var _enemy: FrogEnemy = owner

var _attack_duration: float = 1.0

func enter():
	var anim_duration = _enemy.animation.get_animation("attack").length

	_enemy.animation.play("attack")
	await _enemy.animation.animation_finished

	_enemy.tongue.shoot(_enemy.player_direction, _attack_duration)

	await get_tree().create_timer(_attack_duration - anim_duration / 2).timeout
	_enemy.animation.play_backwards("attack")

	await _enemy.animation.animation_finished
	switch_state.emit(idle_state)
