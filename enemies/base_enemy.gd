extends CharacterBody2D
class_name BaseEnemy

signal took_damage

@export var _die_state: State
@export var collectable_to_drop_on_die: PackedScene
@export var collectable_amount_to_drop: int = 1
@export var move_speed: float = 50.0
@export var max_health: float = 20.0
@export var update_target_interval: float = 0.15
@export var damage_immunity_duration: float = 0
@export var knockback_intensity: int = 300

@onready var texture: Sprite2D = $Texture
@onready var animation: AnimationPlayer = $Animation
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _hit_particles: GPUParticles2D = $HitParticles

var spawnPosition: Vector2
var health: float

var damage_amount = 10
var last_direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var _hit_history: Dictionary = {}

func _ready() -> void:
	health = max_health

	if spawnPosition:
		position = spawnPosition

	_hurtbox.hitbox_entered.connect(_on_hitbox_entered)

func _physics_process(delta: float) -> void:
	if knockback_timer > 0:
		velocity = knockback
		knockback_timer -= delta

		if knockback_timer <= 0:
			knockback = Vector2.ZERO

		move_and_slide()
		return

func _take_damage(damage: float) -> void:
	health -= damage
	$DamageLabelSpawner.spawn_label(damage)
	$DieAudio.play()

	took_damage.emit()

	var tween = get_tree().create_tween()
	tween.tween_method(
		func(val): texture.material.set_shader_parameter("flash_value", val),
		0, 1, 0.15
	)
	tween.chain().tween_method(
		func(val): texture.material.set_shader_parameter("flash_value", val),
		1, 0, 0.15
	)

	if health <= 0:
		$StateMachine.switch_state(_die_state)

func _apply_knockback(direction: Vector2, intensity: float, knockback_duration: float):
	knockback = direction * intensity
	knockback_timer = knockback_duration

func _drop_collectable():
	for i in collectable_amount_to_drop:
		var new_collectable: BaseCollectable = collectable_to_drop_on_die.instantiate()
		new_collectable.global_position = global_position
		get_tree().current_scene.add_child(new_collectable)

func _on_hitbox_entered(hitbox: HitBox) -> void:
	if health <= 0:
		return

	var hitbox_id = hitbox.get_instance_id()
	if _hit_history.has(hitbox_id):
		return

	_hit_history[hitbox_id] = true
	_take_damage(hitbox.damage)

	var knockback_dir: Vector2
	knockback_dir = hitbox.knockback_direction

	_hit_particles.restart()
	_hit_particles.rotation = hitbox.knockback_direction.angle()

	if hitbox.pulls_target:
		_apply_knockback(-knockback_dir, knockback_intensity, 0.1)
	else:
		_apply_knockback(knockback_dir, knockback_intensity, 0.15)
