extends BaseUpgrade
class_name IncreaseProjectileDamageUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.weapon._current_attack_damage += 8
