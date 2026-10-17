extends State
class_name EnemyMeleeAttackState

@export var attack_hitbox: HitBox
@export var on_finish_state: State

@onready var _enemy: BaseEnemy = owner

func enter():
	_enemy.velocity = Vector2.ZERO

	if _enemy.animation.has_animation("attack"):
		_enemy.animation.play("attack")

	if attack_hitbox:
		await get_tree().create_timer(0.2).timeout
		attack_hitbox.enable()

	await get_tree().create_timer(0.15).timeout

	if attack_hitbox:
		attack_hitbox.disable()

	await _enemy.animation.animation_finished
	switch_state.emit(on_finish_state)
