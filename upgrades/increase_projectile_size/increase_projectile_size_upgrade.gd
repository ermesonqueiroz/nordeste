extends BaseUpgrade
class_name IncreaseProjectileSizeUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.projectile_scale *= 1.2
