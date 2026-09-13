extends BaseUpgrade
class_name IncreaseProjectileSizeUpgrade

func _init() -> void:
	name = "Megaball"
	description = "Aumenta o tamanho do projétil do revolver em 20%."

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.projectile_scale *= 1.2
