extends ColorRect
class_name LevelUp

@export var _character: BaseCharacter

@onready var _upgrades_container: BoxContainer = $Column/UpgradesContainer

func _ready() -> void:
	visible = false

func show_screen() -> void:
	show()
	_setup_buttons()

func _setup_buttons() -> void:
	for child in _upgrades_container.get_children():
		if child is UpgradeButton:
			if not child.pressed.is_connected(_on_upgrade_button_pressed):
				child.pressed.connect(_on_upgrade_button_pressed.bind(child))

func _on_upgrade_button_pressed(button: UpgradeButton):
	if button._upgrade:
		button._upgrade.apply_upgrade(_character)

	hide()
	get_tree().paused = false
