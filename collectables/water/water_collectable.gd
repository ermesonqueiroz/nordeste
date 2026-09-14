extends BaseCollectable
class_name WaterCollectable

func _on_collected(character: BaseCharacter) -> void:
	character.add_water(1)
	super._on_collected(character)
