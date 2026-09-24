extends BaseUpgrade
class_name IncreaseProjectileSizeUpgrade

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.weapon._current_projectile_scale *= 1.2
