extends BaseUpgrade
class_name IncreaseAttackRateUpgrade

func _init() -> void:
	name = "Tiro rápido"
	description = "Aumenta o attack rate do revolver em 20%."

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.attack_interval -= 0.2
