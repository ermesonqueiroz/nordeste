extends BaseCollectable
class_name WaterCollectable

func collect_item(character: BaseCharacter) -> void:
	character.add_water(1)
