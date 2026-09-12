extends Label

@export var character: BaseCharacter

func _ready() -> void:
	character.level_updated.connect(_update)
	_update()

func _update() -> void:
	text = "Lvl %s" % str(character.current_level)
