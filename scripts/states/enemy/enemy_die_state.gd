extends State
class_name EnemyDieState

@onready var _enemy: BaseEnemy = owner

func enter():
	_enemy.set_physics_process(false)
	if _enemy.hitbox:
		_enemy.hitbox.monitorable = false

	var sprite = _enemy.get_node_or_null("Sprite2D") if _enemy.has_node("Sprite2D") else _enemy.texture

	if sprite:
		var tween = get_tree().create_tween().set_parallel(true)
		tween.tween_property(sprite, "scale", sprite.scale * 1.3, 0.05)

		if sprite.material and sprite.material is ShaderMaterial:
			sprite.material.set_shader_parameter("flash_value", 1.0)

		await tween.finished

		var shrink_tween = get_tree().create_tween()
		shrink_tween.tween_property(sprite, "scale", Vector2.ZERO, 0.1)
		await shrink_tween.finished

	if GameManager:
		GameManager.add_kill()

	await _enemy.hit_particles.finished

	_enemy._drop_collectable()
	_enemy.queue_free()
