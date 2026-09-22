extends State
class_name EnemyDieState

@onready var _enemy: BaseEnemy = owner

func enter():
	var tween = get_tree().create_tween()
	tween.tween_property(
		_enemy.texture,
		"scale",
		Vector2.ZERO,
		0.15
	)
	await tween.finished

	if GameManager:
		GameManager.add_kill()

	_enemy._drop_collectable()
	_enemy.queue_free()
