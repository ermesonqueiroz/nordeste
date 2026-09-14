extends Node2D
class_name EnemySpawner

@export var _enemies_to_spawn: Array[PackedScene] = []
@export var _player: BaseCharacter

var _spawn_enemy_interval: float = 1.5

func _ready() -> void:
	_player.level_updated.connect(_on_player_level_updated)
	_start_enemies_spawn()

func _start_enemies_spawn():
	while true:
		await get_tree().create_timer(_spawn_enemy_interval).timeout

		if get_tree().paused:
			continue

		var spawn_count: int = 1 + int(_player.current_level / 2.0)

		for i in range(spawn_count):
			var new_enemy: BaseEnemy = _enemies_to_spawn.pick_random().instantiate()
			new_enemy.player = _player
			var angle = randf() * TAU
			var spawn_distance = 600
			new_enemy.spawnPosition = _player.global_position + Vector2(cos(angle), sin(angle)) * spawn_distance

			get_parent().add_child(new_enemy)

func _on_player_level_updated():
	_spawn_enemy_interval = max(0.2, 1.5 - (0.06 * _player.current_level))
