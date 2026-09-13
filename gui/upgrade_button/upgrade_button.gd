extends Button
class_name UpgradeButton

@export var _upgrade: BaseUpgrade

@onready var _title: Label = $Container/Title
@onready var _description: Label = $Container/Description

func _ready() -> void:
	_title.text = _upgrade.name
	_description.text = _upgrade.description
