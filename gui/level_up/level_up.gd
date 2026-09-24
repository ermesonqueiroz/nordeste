extends ColorRect
class_name LevelUp

signal upgrade_selected

@export var _character: BaseCharacter
@export var _upgrade_count_to_draw: int = 2

@onready var _upgrades_container: BoxContainer = $Column/UpgradesContainer
@onready var _level_up_sfx: AudioStream = preload("res://sfx/level_up.wav")
@onready var _upgrade_button: PackedScene = preload("res://gui/upgrade_button/upgrade_button.tscn")

var available_upgrades: Array[UpgradeData] = []

func _ready() -> void:
	visible = false

func show_screen() -> void:
	SoundManager.play(_level_up_sfx, 0, ProcessMode.PROCESS_MODE_ALWAYS)
	show()
	_setup_buttons()

func _setup_buttons() -> void:
	for child in _upgrades_container.get_children():
		child.queue_free()

	var drawn_upgrades: Array[UpgradeData] = draw_upgrades()

	for upgrade in drawn_upgrades:
		var new_upgrade_button = _upgrade_button.instantiate()
		new_upgrade_button.upgrade = upgrade
		new_upgrade_button.pressed.connect(func(): _on_upgrade_button_pressed(new_upgrade_button.upgrade))
		_upgrades_container.add_child(new_upgrade_button)

func _on_upgrade_button_pressed(upgrade: UpgradeData):
	if _character.can_apply_upgrade(upgrade):
		_character.apply_upgrade(upgrade)

	hide()
	get_tree().paused = false

	upgrade_selected.emit()

func reset_deck() -> void:
	available_upgrades = []
	for upgrade_id in UpgradeManager.available_cards:
		var upgrade = UpgradeManager.available_cards[upgrade_id]
		var upgrade_usage_count = _character.upgrades_applied.get(upgrade_id, 0)
		if upgrade_usage_count < upgrade.max_uses:
			available_upgrades.append(upgrade)

	available_upgrades.shuffle()

func draw_upgrades() -> Array[UpgradeData]:
	var drawn: Array[UpgradeData] = []

	if available_upgrades.is_empty():
		return drawn

	var count_to_draw = min(_upgrade_count_to_draw, available_upgrades.size())

	for i in range(count_to_draw):
		var card = available_upgrades.pop_front()
		drawn.append(card)

	return drawn
