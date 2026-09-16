extends Area2D
class_name HurtBox

signal hitbox_entered

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not area is HitBox:
		return

	hitbox_entered.emit(area as HitBox)
