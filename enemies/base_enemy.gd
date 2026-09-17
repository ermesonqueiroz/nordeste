extends CharacterBody2D
class_name BaseEnemy

@export var collectable_to_drop_on_die: PackedScene
@export var collectable_amount_to_drop: int = 1
@export var move_speed: float = 50.0
@export var max_health: float = 20.0

@onready var _texture: Sprite2D = $Texture
@onready var animation: AnimationPlayer = $Animation
@onready var _hurtbox: HurtBox = $HurtBox

var player: BaseCharacter
var spawnPosition: Vector2
var health: float

var damage_amount = 10
var last_direction: Vector2 = Vector2.ZERO
var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

func _ready() -> void:
	position = spawnPosition
	health = max_health

	_hurtbox.hitbox_entered.connect(_on_hitbox_entered)

func _physics_process(delta: float) -> void:
	if knockback_timer > 0:
		velocity = knockback
		knockback_timer -= delta

		if knockback_timer <= 0:
			knockback = Vector2.ZERO

		move_and_slide()
		return

	var direction = position.direction_to(player.global_position).normalized()

	if direction != Vector2.ZERO:
		last_direction = direction

	velocity = direction * move_speed
	move_and_slide()

func _take_damage(damage: float) -> void:
	health -= damage
	$DamageLabelSpawner.spawn_label(damage)
	$DieAudio.play()

	var tween = get_tree().create_tween()

	if health <= 0:
		tween.tween_property(
			$Texture,
			"scale",
			Vector2.ZERO,
			0.15
		).connect("finished", die)
		return

	tween.tween_method(
		func(val): _texture.material.set_shader_parameter("flash_value", val),
		0, 1, 0.15
	)
	tween.chain().tween_method(
		func(val): _texture.material.set_shader_parameter("flash_value", val),
		1, 0, 0.15
	)

func die():
	_drop_collectable()
	queue_free()

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

	_take_damage(hitbox.damage)

	var attacker_position = hitbox.get_parent().global_position
	var knockback_dir: Vector2

	if hitbox.pulls_target:
		knockback_dir = (attacker_position - global_position).normalized()
		_apply_knockback(knockback_dir, 300, 0.1)
	else:
		knockback_dir = (global_position - attacker_position).normalized()
		_apply_knockback(knockback_dir, 200, 0.15)
