extends BaseUpgrade
class_name WeaponProjectilesUpgrade

func apply_upgrade(character: BaseCharacter) -> void:
	character.weapon.projectiles *= 2
