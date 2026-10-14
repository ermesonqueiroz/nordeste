extends CharacterBody2D
class_name BaseEnemy

signal took_damage

@export_category("States")
@export var die_state: State
@export var hit_state: State

@export var collectable_to_drop_on_die: PackedScene
@export var collectable_amount_to_drop: int = 1
@export var move_speed: float = 50.0
@export var max_health: float = 20.0
@export var update_target_interval: float = 0.15
@export var damage_immunity_duration: float = 0
@export var knockback_intensity: int = 300

@onready var texture: AnimatedSprite2D = $SpriteGroup/Texture
@onready var sprite_group: Node2D = $SpriteGroup
@onready var hurtbox: HurtBox = $HurtBox
@onready var hit_particles: GPUParticles2D = $HitParticles
@onready var hitbox: HitBox = $HitBox

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

	hurtbox.hitbox_entered.connect(_on_hitbox_entered)

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

	if health <= 0:
		$StateMachine.switch_state(die_state)

	if hit_state:
		$StateMachine.switch_state(hit_state)

	took_damage.emit()

func _drop_collectable():
	for i in collectable_amount_to_drop:
		var new_collectable: BaseCollectable = collectable_to_drop_on_die.instantiate()
		new_collectable.global_position = global_position
		get_tree().current_scene.add_child(new_collectable)

func _apply_knockback(intensity: float, knockback_duration: float):
	knockback = -last_direction * intensity
	knockback_timer = knockback_duration

func _on_hitbox_entered(external_hitbox: HitBox) -> void:
	if health <= 0:
		return

	var hitbox_id = external_hitbox.get_instance_id()
	if _hit_history.has(hitbox_id):
		return

	_hit_history[hitbox_id] = true
	hit_particles.rotation = external_hitbox.knockback_direction.angle()

	_take_damage(external_hitbox.damage)
	_apply_knockback(200, 0.15)
	play_hit_visuals()

	if external_hitbox is BaseProjectile:
		external_hitbox.queue_free()

func play_hit_visuals():
	if hit_particles:
		hit_particles.restart()

	flash()

func flash() -> void:
	var mat := sprite_group.material

	if not mat or not mat is ShaderMaterial:
		return

	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_method(
		func(val): mat.set_shader_parameter("flash_value", val),
		0, 1, 0.15
	)
	tween.chain().tween_method(
		func(val): mat.set_shader_parameter("flash_value", val),
		1, 0, 0.15
	)
