extends State
class_name FrogAttackState

@export var idle_state: State
@export var tongue: FrogTongue

@onready var _enemy: BaseEnemy = owner

var _attack_duration: float = 1.0

func enter():
	var anim_duration = _enemy.animation.get_animation("attack").length

	_enemy.animation.play("attack")
	await _enemy.animation.animation_finished

	var player = get_tree().get_first_node_in_group("player")
	var player_direction = _enemy.position.direction_to(player.global_position).normalized()
	tongue.shoot(player_direction, _attack_duration)

	await get_tree().create_timer(_attack_duration - anim_duration / 2).timeout
	_enemy.animation.play_backwards("attack")

	await _enemy.animation.animation_finished
	switch_state.emit(idle_state)
