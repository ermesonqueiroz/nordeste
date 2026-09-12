extends Label

@export var character: BaseCharacter

func _ready() -> void:
	character.water_collected.connect(_update)
	_update()

func _update() -> void:
	text = str(character.current_water_amount)
