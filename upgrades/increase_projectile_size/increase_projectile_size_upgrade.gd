extends BaseUpgrade
class_name IncreaseProjectileSizeUpgrade

func _init() -> void:
	id = "increase_projectile_size"
	name = "Megaball"
	description = "Aumenta o tamanho do projétil do revolver em 20%."
	icon = preload("res://upgrades/increase_projectile_size/fire_ball.png")
	max_uses = 4

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.weapon._current_projectile_scale *= 1.2
