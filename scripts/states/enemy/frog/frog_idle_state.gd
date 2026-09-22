extends State
class_name FrogIdleState

@export var jump_state: State
@export var attack_state: State

@onready var _enemy: FrogEnemy = owner

var _initial_idle_timer: float = 2.0
var _idle_timer: float = 0.0

func enter():
	_idle_timer = _initial_idle_timer

	if _enemy.animation:
		if _enemy.animation.is_playing() and _enemy.animation.current_animation != "idle":
			_enemy.animation.animation_finished.connect(func(_anim_name): _enemy.animation.play("idle"))
		else:
			_enemy.animation.play("idle")

func update_physics(delta: float):
	_idle_timer -= delta

	if _idle_timer <= 0:
		if _enemy.player_are_in_attack_area:
			var player = get_tree().get_first_node_in_group("player")
			_enemy.player_direction = _enemy.position.direction_to(player.global_position).normalized()

			switch_state.emit(attack_state)
			return

		switch_state.emit(jump_state)
