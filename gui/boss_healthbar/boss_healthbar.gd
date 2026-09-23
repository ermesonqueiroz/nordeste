extends TextureProgressBar
class_name BossHealthbar

var boss: BaseEnemy

func _ready() -> void:
	update()
	boss.took_damage.connect(update)

func update():
	value = boss.health * 100 / boss.max_health

	if boss.health <= 0:
		queue_free()
