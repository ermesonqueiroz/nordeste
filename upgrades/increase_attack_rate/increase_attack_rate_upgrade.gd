extends BaseUpgrade
class_name IncreaseAttackRateUpgrade

func _init() -> void:
	id = "increase_attack_speed"
	name = "Tiro rápido"
	description = "Aumenta o attack rate do revolver em 20%."
	icon = preload("res://upgrades/increase_attack_rate/icon.png")
	max_uses = 4

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.attack_interval *= 0.8
