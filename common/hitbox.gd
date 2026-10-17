extends Area2D
class_name HitBox

signal hurtbox_entered

@export var damage: int = 1
@export var pulls_target: bool = false

@onready var collision: CollisionShape2D = _get_collision_shape()

var knockback_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HurtBox:
		hurtbox_entered.emit(area)

func _get_collision_shape() -> CollisionShape2D:
	var collision_shape: CollisionShape2D

	for child in get_children():
		if not child is CollisionShape2D:
			continue

		collision_shape = child

	return collision_shape

func disable() -> void:
	collision.disabled = true

func enable() -> void:
	collision.disabled = false
