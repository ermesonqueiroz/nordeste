extends BaseUpgrade
class_name IncreaseCharacterHealthUpgrade

func _init() -> void:
	id = "increase_character_health"
	name = "Vida da bexiga"
	description = "+1 Vida"
	icon = preload("res://upgrades/increase_character_health/icon.png")
	max_uses = 4

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.increase_max_health(1)
