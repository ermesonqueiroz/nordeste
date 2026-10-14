extends BaseCollectable
class_name HealthCollectable

func collect_item(character: BaseCharacter) -> void:
	character.add_health()
