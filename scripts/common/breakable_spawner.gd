extends Node2D
class_name BreakableSpawner

@export var spawn_interval_seconds: float = 10.0
@export var max_objects_amount: int = 5
@export var spawn_offset: float = 500.0

@onready var character: BaseCharacter = get_tree().get_first_node_in_group("player")

var spawn_timer: float = 0.0
var placed_breakables: Array[Breakable] = []

var SMALL_VASE: PackedScene = preload("res://scenes/breakables/SmallVase/small_vase.tscn")

func _process(delta: float) -> void:
	spawn_timer -= delta

	if spawn_timer <= 0:
		spawn_timer = spawn_interval_seconds
		_out_of_range_despawn()
		_spawn_breakables()

func _out_of_range_despawn() -> void:
	for i in range(placed_breakables.size() -1, -1, -1):
		var breakable = placed_breakables[i]

		if not is_instance_valid(breakable):
			placed_breakables.remove_at(i)
			continue

		var obj_distance = character.global_position.distance_to(breakable.global_position)
		if obj_distance > spawn_offset:
			breakable.queue_free()
			placed_breakables.remove_at(i)

func _spawn_breakables() -> void:
	var amount_to_spawn = max_objects_amount - placed_breakables.size()

	for i in range(amount_to_spawn):
		var angle = randf() * TAU
		var offset = Vector2(cos(angle), sin(angle)) * spawn_offset

		var small_vase: Breakable = SMALL_VASE.instantiate()
		small_vase.global_position = offset + character.global_position
		get_tree().current_scene.call_deferred("add_child", small_vase)
		placed_breakables.append(small_vase)
