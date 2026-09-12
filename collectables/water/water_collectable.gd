extends BaseCollectable
class_name WaterCollectable

func _on_collected(character: BaseCharacter) -> void:
	character.add_water(1)
	hide()

	$CollectAudio.play()
	await $CollectAudio.finished
	queue_free()
