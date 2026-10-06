extends State
class_name EnemyHitState

@export_category("States")
@export var chase_state: State
@export var die_state: State

@onready var _enemy: BaseEnemy = owner

func enter():
	_enemy.hit_particles.restart()
	_enemy.texture.stop()

	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(
		func(val): _enemy.texture.material.set_shader_parameter("flash_value", val),
		0, 1, 0.15
	)
	tween.chain().tween_method(
		func(val): _enemy.texture.material.set_shader_parameter("flash_value", val),
		1, 0, 0.15
	)

	await tween.finished
	switch_state.emit(chase_state if _enemy.health > 0 else die_state)
