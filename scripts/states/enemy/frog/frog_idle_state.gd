extends State
class_name FrogIdleState

@export var jump_state: State
@export var pool_attack_state: Array[State]
@export var attack_area: Area2D

@onready var _enemy: BaseEnemy = owner

var _initial_idle_timer: float = 2.0
var _idle_timer: float = 0.0

var _player_are_in_attack_area: bool = false

func _ready():
	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)

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
		if _player_are_in_attack_area:
			var attack_state = pool_attack_state.pick_random()
			switch_state.emit(attack_state)
			return

		switch_state.emit(jump_state)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		_player_are_in_attack_area = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		_player_are_in_attack_area = false
