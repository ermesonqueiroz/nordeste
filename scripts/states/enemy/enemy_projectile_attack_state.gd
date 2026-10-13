extends State
class_name EnemyProjectileAttackState

@export var on_exit_state: State
@export var projectile: PackedScene
@export var projectiles_amount: int = 1

@onready var _enemy: BaseEnemy = owner

func enter():
	var character = get_tree().get_first_node_in_group("player")
	var base_direction = _enemy.global_position.direction_to(character.global_position).normalized()
	var spread_rad = deg_to_rad(110)

	for i in range(3):
		var projectile_direction = base_direction

		if projectiles_amount > 1:
			var step = spread_rad / (projectiles_amount - 1)
			var current_angle = -spread_rad / 2 + (step * i)
			projectile_direction = base_direction.rotated(current_angle)

		var new_projectile: BaseProjectile = projectile.instantiate()
		new_projectile.direction = projectile_direction
		new_projectile.spawn_position = _enemy.global_position + (projectile_direction * 40) - Vector2(0, 8)
		new_projectile.spawn_rotation = projectile_direction.angle()
		new_projectile.damage = 1

		get_tree().current_scene.add_child.call_deferred(new_projectile)

	switch_state.emit(on_exit_state)
