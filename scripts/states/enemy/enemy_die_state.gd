extends State
class_name EnemyDieState

@onready var _enemy: BaseEnemy = owner

func enter():
	_enemy.texture.stop()
	_enemy._drop_collectable()
	_enemy.set_deferred("physics_process", false)

	if _enemy.hitbox:
		_enemy.hitbox.set_deferred("monitorable", false)

	var sprite_group = _enemy.sprite_group

	if sprite_group:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(sprite_group, "scale", sprite_group.scale * 1.5, 0.2)
		tween.chain().tween_property(sprite_group, "scale", Vector2.ZERO, 0.4)
		await tween.finished

	if GameManager:
		GameManager.add_kill()

	await _enemy.hit_particles.finished

	_enemy.queue_free()
