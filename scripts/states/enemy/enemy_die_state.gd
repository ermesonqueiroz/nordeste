extends State
class_name EnemyDieState

@onready var _enemy: BaseEnemy = owner

func enter():
	_enemy.set_physics_process(false)
	if _enemy.hitbox:
		_enemy.hitbox.set_deferred("monitorable", false)

	var sprite_group = _enemy.sprite_group

	if sprite_group:
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(sprite_group, "scale", sprite_group.scale * 1.3, 0.05)

		if sprite_group and sprite_group is ShaderMaterial:
			sprite_group.material.set_shader_parameter("flash_value", 1.0)

		await tween.finished

		var shrink_tween = get_tree().create_tween()
		shrink_tween.tween_property(sprite_group, "scale", Vector2.ZERO, 0.2)
		await shrink_tween.finished

	if GameManager:
		GameManager.add_kill()

	await _enemy.hit_particles.finished

	_enemy._drop_collectable()
	_enemy.queue_free()
