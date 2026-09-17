extends BaseUpgrade
class_name IncreaseProjectileDamageUpgrade

func _init() -> void:
	id = "increase_projectile_damage"
	name = "Dano da peste"
	description = "Dano do revolver +8"
	icon = preload("res://upgrades/increase_projectile_damage/icon.png")
	max_uses = 4

func apply_upgrade(_character: BaseCharacter) -> void:
	_character.weapon._current_attack_damage += 8
