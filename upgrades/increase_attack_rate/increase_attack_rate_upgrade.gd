extends BaseUpgrade
class_name IncreaseAttackRateUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.attack_interval -= 0.2
