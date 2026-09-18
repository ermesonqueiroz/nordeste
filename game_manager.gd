extends Node

var selected_weapon: WeaponData = null

var enemies_killed: int = 0
var survival_time: float = 0.0
var is_game_active: bool = false

func _process(delta: float) -> void:
    if is_game_active:
        survival_time += delta

func reset_stats() -> void:
    enemies_killed = 0
    survival_time = 0.0
    is_game_active = true

func add_kill() -> void:
    enemies_killed += 1
