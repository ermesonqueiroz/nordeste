extends TextureButton
class_name UpgradeButton

@export var _upgrade: BaseUpgrade

@onready var _title: Label = $Title
@onready var _description: Label = $Description
@onready var _icon_node: TextureRect = $Icon

func _ready() -> void:
	_title.text = _upgrade.name
	_description.text = _upgrade.description

	if _upgrade.icon:
		_icon_node.texture = _upgrade.icon
