extends Node2D
class_name BossSpawner

signal boss_spawned(boss: BaseEnemy)

@export var enemy_pool: Array = [preload("res://scenes/enemies/bosses/frog/frog_boss.tscn")]
@export var _character: BaseCharacter
@export var enabled: bool = true
@export var spawn_enemy_interval_seconds: float = 300 # 5 minutes

var last_boss: BaseEnemy
var last_boss_spawned_index = -1
var spawn_enemy_timer: float = 0.0

func _ready() -> void:
	# spawn_enemy_timer = spawn_enemy_interval_seconds
	pass

func _process(delta: float) -> void:
	spawn_enemy_timer -= delta

	if spawn_enemy_timer <= 0:
		spawn_enemy_timer = spawn_enemy_interval_seconds

		if last_boss:
			if last_boss.health > 0:
				return

		last_boss_spawned_index = min(enemy_pool.size() - 1, last_boss_spawned_index + 1)
		_spawn_boss_by_index(last_boss_spawned_index)

func _spawn_boss_by_index(index: int):
	var new_enemy: BaseEnemy = enemy_pool[index].instantiate()

	var angle = randf() * TAU
	var spawn_distance = 600
	new_enemy.spawnPosition = _character.global_position + Vector2(cos(angle), sin(angle)) * spawn_distance

	get_tree().current_scene.add_child(new_enemy)
	boss_spawned.emit(new_enemy)
	last_boss = new_enemy
