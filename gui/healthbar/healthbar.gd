extends TextureProgressBar
class_name HealthBar

@export var character: BaseCharacter

func _ready() -> void:
	character.healthUpdated.connect(update)
	update()

func update():
	value = character.currentHealth * 100.0 / character.maxHealth
