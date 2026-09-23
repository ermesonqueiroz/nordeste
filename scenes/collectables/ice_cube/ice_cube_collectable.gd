extends BaseCollectable
class_name IceCubeCollectable

func collect_item(character: BaseCharacter) -> void:
	character.add_water(50)
