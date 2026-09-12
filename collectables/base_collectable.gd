extends Area2D
class_name BaseCollectable

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		_on_collected(body)

func _on_collected(_character: BaseCharacter) -> void:
	queue_free()
