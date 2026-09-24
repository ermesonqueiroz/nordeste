extends BaseUpgrade
class_name IncreaseCharacterHealthUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.increase_max_health(1)
