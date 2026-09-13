extends TextureProgressBar
class_name WaterBar

@export var character: BaseCharacter

@onready var _label: Label = $Label

func _ready() -> void:
	character.water_collected.connect(_update)
	_update()

func _update() -> void:
	value = character.current_water_amount * 100.0 / character.water_amount_to_next_level
	_label.text = "Level %s" % character.current_level
