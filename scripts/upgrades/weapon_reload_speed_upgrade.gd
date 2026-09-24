extends BaseUpgrade
class_name WeaponReloadSpeedUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.weapon.reload_time *= 0.85
