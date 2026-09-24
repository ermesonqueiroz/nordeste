extends BaseUpgrade
class_name IncreaseAttackRateUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.weapon._attack_cooldown_timer *= 0.8
