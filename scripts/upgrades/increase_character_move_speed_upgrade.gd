extends BaseUpgrade
class_name IncreaseCharacterMoveSpeedUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character._move_speed *= 1.1
