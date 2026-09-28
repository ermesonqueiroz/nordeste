extends TextureProgressBar
class_name BossHealthbar

var boss: BaseEnemy

func _ready() -> void:
	if not is_instance_valid(boss):
		queue_free()
		return

	update()
	boss.took_damage.connect(update)

func update():
	if not is_instance_valid(boss):
		queue_free()
		return

	value = boss.health * 100 / boss.max_health

	if boss.health <= 0:
		queue_free()
