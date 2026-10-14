extends Node2D
class_name Breakable

@export var collectable: PackedScene

func _ready() -> void:
	$HurtBox.hitbox_entered.connect(_on_hitbox_entered)

func _on_hitbox_entered(_hitbox: HitBox) -> void:
	var new_collectable: BaseCollectable = collectable.instantiate()
	new_collectable.global_position = global_position
	new_collectable.velocity = (Vector2.ONE * 180).rotated(deg_to_rad(randf_range(-90, 90)))
	get_tree().current_scene.call_deferred("add_child", new_collectable)
	queue_free()
