extends CharacterBody2D
class_name BaseCharacter

signal healthUpdated

@export_category("Variables")
@export var _move_speed: float = 128.0

@export_category("Objects")
@export var _gameLevel: GameLevel
@export var _animation: AnimationPlayer
@export var _spawnArea: Area2D
@export var _animations: Dictionary = {
	"idle": "idle",
	"idle_right": "idle_right",
	"idle_left": "idle_left",
	"idle_top": "idle_top",
	"idle_bottom": "idle_bottom",
	"run_right": "run_right",
	"run_left": "run_left",
	"run_top": "run_top",
	"run_bottom": "run_bottom",
}

var enemy: PackedScene = load("res://enemies/mosquito/mosquito.tscn")
var projectile: PackedScene = load("res://projectiles/melee/melee_projectile.tscn")

var last_direction: Vector2 = Vector2.RIGHT
var maxHealth = 100
var currentHealth = maxHealth

func _physics_process(_delta: float) -> void:
	_move()
	_animate()

func _move():
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)

	if _direction != Vector2.ZERO:
		last_direction = _direction

	velocity = _direction * _move_speed
	move_and_slide()

func _animate() -> void:
	if velocity.length() > 0:
		if velocity.x < 0:
			_animation.play(_animations["run_left"])
			return

		if velocity.x > 0:
			_animation.play(_animations["run_right"])
			return

		if velocity.y < 0:
			_animation.play(_animations["run_top"])
			return

		if velocity.y > 0:
			_animation.play(_animations["run_bottom"])
			return

	if last_direction.x < 0:
		_animation.play(_animations["idle_left"])
		return

	_animation.play(_animations["idle_right"])
	return

func _attack() -> void:
	var mouse_position := (get_global_mouse_position() - global_position).normalized()

	var new_projectile: BaseProjectile = projectile.instantiate()
	new_projectile.direction = mouse_position
	new_projectile.spawn_position = global_position + (mouse_position * 40)
	new_projectile.spawn_rotation = mouse_position.angle()

	get_parent().add_child.call_deferred(new_projectile)

func _get_spawn_area_collision() -> CollisionShape2D:
	if _spawnArea.get_child(0) is not CollisionShape2D:
		return null

	return _spawnArea.get_child(0) as CollisionShape2D

func _on_enemy_spawn_timer_timeout() -> void:
	var rect = _get_spawn_area_collision().shape.get_rect()
	var newEnemy: BaseEnemy = enemy.instantiate()
	newEnemy.player = self
	newEnemy.spawnPosition = Vector2(
		randi_range(global_position.x - (rect.size.x / 2), global_position.x + (rect.size.x / 2)),
		randi_range(global_position.x - (rect.size.y / 2), global_position.x + (rect.size.y / 2))
	)

	get_parent().add_child(newEnemy)

func take_damage(damage: float) -> void:
	currentHealth -= damage
	healthUpdated.emit()

	if currentHealth <= 0:
		die()

func die():
	if _gameLevel:
		_gameLevel.showGameOver()

func _on_hit_timer_timeout() -> void:
	_attack()
