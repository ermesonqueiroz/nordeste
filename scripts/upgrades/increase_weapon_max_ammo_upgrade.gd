extends BaseUpgrade
class_name IncreaseWeaponMaxAmmoUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.weapon.max_ammo += 1
