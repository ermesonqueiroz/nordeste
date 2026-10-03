extends Area2D
class_name HitBox

signal hurtbox_entered

@export var damage: int = 1
@export var pulls_target: bool = false

var knockback_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		hurtbox_entered.emit(area)
