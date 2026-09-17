extends CharacterBody2D
class_name BaseCharacter

signal healthUpdated
signal water_collected
signal level_updated

@export_category("Variables")
@export var _move_speed: float = 128.0

@export_category("Objects")
@export var _animation: AnimationPlayer
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

@onready var _camera: BaseCharacterCamera = $Camera
@onready var _texture: Sprite2D = $SpriteGroup/Texture
@onready var _audio: AudioStreamPlayer = $Audio
@onready var weapon: BaseWeapon = $SpriteGroup/Weapon
@onready var _hurtbox: HurtBox = $HurtBox
@onready var _dust_particles: GPUParticles2D = $DustParticles

var enemy: PackedScene = load("res://enemies/mosquito/mosquito.tscn")
var projectile: PackedScene = load("res://projectiles/bullet/bullet_projectile.tscn")

var last_direction: Vector2 = Vector2.RIGHT

var maxHealth = 1000
var currentHealth = maxHealth

var knockback: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var is_invulnerable: bool = false

var current_water_amount = 0
var current_level = 1
var water_amount_to_next_level = 20

var upgrades_applied: Dictionary = {}

func _ready() -> void:
	_texture.material.set_shader_parameter("flash_value", 0.0)
	water_collected.connect(_on_water_collected)
	_hurtbox.hitbox_entered.connect(_on_hitbox_entered)
	weapon.weapon_fired.connect(_on_weapon_fired)

func _physics_process(delta: float) -> void:
	if knockback_timer > 0:
		velocity = knockback
		knockback_timer -= delta

		if knockback_timer <= 0:
			knockback = Vector2.ZERO

		move_and_slide()
		return

	_move()
	_animate()

func _move():
	var _direction: Vector2 = Input.get_vector(
		"move_left", "move_right", "move_up", "move_down"
	)

	if _direction != Vector2.ZERO:
		last_direction = _direction

	var speed = _move_speed / 2 if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) else _move_speed

	velocity = _direction * speed
	move_and_slide()

func _animate() -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_dust_particles.emitting = false
		var shooting_direction = (get_global_mouse_position() - global_position).normalized()

		if shooting_direction.x < 0:
			if _animation.has_animation(_animations["run_left"]):
				_animation.play(_animations["run_left"])

		if shooting_direction.x > 0:
			if _animation.has_animation(_animations["run_right"]):
				_animation.play(_animations["run_right"])

		return

	if velocity.length() > 0:
		_dust_particles.emitting = true
		_dust_particles.position.x = 0

		if velocity.x < 0:
			if _animation.has_animation(_animations["run_left"]):
				_animation.play(_animations["run_left"])

			if _dust_particles:
				_dust_particles.scale.x = -1
				_dust_particles.position.x = -8

			return

		if velocity.x > 0:
			if _animation.has_animation(_animations["run_right"]):
				_animation.play(_animations["run_right"])

			if _dust_particles:
				_dust_particles.scale.x = 1
				_dust_particles.position.x = 8

			return

		if velocity.y < 0:
			if _animation.has_animation(_animations["run_top"]):
				_animation.play(_animations["run_top"])
			return

		if velocity.y > 0:
			if _animation.has_animation(_animations["run_bottom"]):
				_animation.play(_animations["run_bottom"])
			return

	_dust_particles.emitting = false

	if last_direction.x < 0:
		_animation.play(_animations["idle_left"])
		return

	_animation.play(_animations["idle_right"])
	return

func _on_water_collected() -> void:
	while current_water_amount >= water_amount_to_next_level:
		current_water_amount -= water_amount_to_next_level
		_level_up()

func _level_up() -> void:
	current_level += 1

	if current_level < 20:
		water_amount_to_next_level = int(10 + (current_level * 10))

	level_updated.emit()

func _take_damage(damage: float) -> void:
	currentHealth -= damage
	healthUpdated.emit()

	_camera.screen_shake(8, 0.3)
	_audio.play()

	await _audio.finished

	if currentHealth <= 0:
		die()

func die():
	pass

func _apply_knockback(direction: Vector2, intensity: float, knockback_duration: float):
	knockback = direction * intensity
	knockback_timer = knockback_duration

	var tween = get_tree().create_tween()
	tween.tween_property($SpriteGroup, "scale", Vector2(0.8, 0.8), knockback_duration / 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($SpriteGroup, "scale", Vector2(1, 1), knockback_duration / 2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

	apply_invulnerability(2)

func apply_invulnerability(duration: float):
	if is_invulnerable:
		return

	is_invulnerable = true

	if _texture.material is ShaderMaterial:
		var flash_cycles = max(1, int(duration / 0.3))
		var tween = get_tree().create_tween()
		tween.set_loops(flash_cycles)

		tween.tween_method(
			func(val): _texture.material.set_shader_parameter("flash_value", val),
			0, 1, 0.15
		)
		tween.tween_method(
			func(val): _texture.material.set_shader_parameter("flash_value", val),
			1, 0, 0.15
		)

	await get_tree().create_timer(duration).timeout
	is_invulnerable = false

	if _texture.material is ShaderMaterial:
		_texture.material.set_shader_parameter("flash_value", 0.0)

func add_water(amount: int):
	current_water_amount += amount
	water_collected.emit()

func can_apply_upgrade(upgrade: BaseUpgrade) -> bool:
	if upgrade.max_uses == -1:
		return true

	var current_uses = upgrades_applied.get(upgrade.id, 0)
	return current_uses < upgrade.max_uses

func apply_upgrade(upgrade: BaseUpgrade) -> void:
	if not can_apply_upgrade(upgrade):
		return

	if not upgrades_applied.has(upgrade.id):
		upgrades_applied[upgrade.id] = 0

	upgrades_applied[upgrade.id] += 1
	upgrade.apply_upgrade(self)

func _on_hitbox_entered(hitbox: HitBox):
	if is_invulnerable:
		return

	_take_damage(hitbox.damage)

	var attacker_position = hitbox.get_parent().global_position
	var knockback_dir: Vector2

	if hitbox.pulls_target:
		knockback_dir = (attacker_position - global_position).normalized()
		_apply_knockback(knockback_dir, 500, 0.1)
	else:
		knockback_dir = (global_position - attacker_position).normalized()
		_apply_knockback(knockback_dir, 200, 0.15)

func _on_weapon_fired() -> void:
	_camera.screen_shake(3, 0.3)
