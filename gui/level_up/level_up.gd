extends ColorRect
class_name LevelUp

@export var _character: BaseCharacter

@onready var _upgrades_container: BoxContainer = $Column/UpgradesContainer
@onready var _level_up_sfx: AudioStream = preload("res://sfx/level_up.wav")

func _ready() -> void:
	visible = false

func show_screen() -> void:
	SoundManager.play(_level_up_sfx, 0, ProcessMode.PROCESS_MODE_ALWAYS)
	show()
	_setup_buttons()

func _setup_buttons() -> void:
	for child in _upgrades_container.get_children():
		if child is UpgradeButton:
			if not child.pressed.is_connected(_on_upgrade_button_pressed):
				child.pressed.connect(_on_upgrade_button_pressed.bind(child))

func _on_upgrade_button_pressed(button: UpgradeButton):
	if button._upgrade:
		_character.apply_upgrade(button._upgrade)

	hide()
	get_tree().paused = false
