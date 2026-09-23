extends Node2D
class_name EnemySpawner

@export var _enemy_pool: Array[Dictionary] = [
	# {"scene": PackedScene, "cost": 1, "min_level": 1}
]
@export var _character: BaseCharacter
@export var enabled: bool = true

var _spawn_enemy_interval: float = 2

func _ready() -> void:
	_character.level_updated.connect(_on_player_level_updated)
	_start_enemies_spawn()

func _start_enemies_spawn():
	while true:
		await get_tree().create_timer(_spawn_enemy_interval).timeout

		if get_tree().paused or not enabled:
			continue

		var difficulty_budget: int = 1 + int(_character.current_level / 2.0)

		var available_enemies = []
		for entry in _enemy_pool:
			if _character.current_level >= entry.get("min_level", 1):
				available_enemies.append(entry)

		if available_enemies.is_empty():
			continue

		while difficulty_budget > 0:
			var affordable_enemies = available_enemies.filter(func(e): return e["cost"] <= difficulty_budget)

			if affordable_enemies.is_empty():
				break

			var chosen_enemy_data = affordable_enemies.pick_random()

			var new_enemy: BaseEnemy = chosen_enemy_data["scene"].instantiate()

			var angle = randf() * TAU
			var spawn_distance = 600
			new_enemy.spawnPosition = _character.global_position + Vector2(cos(angle), sin(angle)) * spawn_distance

			get_parent().add_child(new_enemy)

			difficulty_budget -= chosen_enemy_data["cost"]

func _on_player_level_updated():
	_spawn_enemy_interval = 2
