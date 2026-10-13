extends Node2D
class_name BaseWeapon

signal weapon_fired
signal ammo_updated
signal start_reload

@export var initial_projectile_scale = 1.2

@onready var texture: AnimatedSprite2D = $Texture
@onready var _reload_sfx: AudioStream = preload("res://sfx/reload.mp3")
@onready var _shoot_sfx: AudioStream = preload("res://sfx/shoot.wav")
@onready var projectile_spawn_point: Marker2D = $ProjectileSpawnPoint

var _character: BaseCharacter
var _projectile: PackedScene
var crosshair: Texture2D

var _current_attack_interval: float = 0
var _attack_cooldown_timer: float = 0.0

var _current_projectile_scale = initial_projectile_scale
var _current_attack_damage: int = 0

var max_ammo: int = 0
var ammo: int = 0
var is_reloading: bool = false
var is_shooting: bool = false
var reload_time: float = 0.0
var projectiles: int = 0
var spread_projectiles_angle_degrees: float = 0
var orbit_distance: float = 0.0

func _ready() -> void:
	texture.animation_finished.connect(_on_animation_finished)

func setup(weapon_data: WeaponData) -> void:
	if not weapon_data:
		return

	_current_attack_interval = weapon_data.attack_interval
	_current_attack_damage = weapon_data.damage
	max_ammo = weapon_data.max_ammo
	ammo = max_ammo
	reload_time = weapon_data.reload_time
	projectiles = weapon_data.projectiles
	spread_projectiles_angle_degrees = weapon_data.spread_projectiles_angle_degrees
	orbit_distance = weapon_data.orbit_distance

func _process(delta: float) -> void:
	if not _character:
		return

	var hand = _character.get_node_or_null("SpriteGroup/ArmFront/Hand")
	var arm_front = _character.get_node_or_null("SpriteGroup/ArmFront")

	if hand:
		global_position = hand.global_position

	if arm_front:
		var mouse_position = get_global_mouse_position()
		var mouse_direction = mouse_position - global_position

		if mouse_direction.x < 0:
			global_rotation = arm_front.global_rotation - PI / 2
		else:
			global_rotation = arm_front.global_rotation + PI / 2

	if _attack_cooldown_timer > 0:
		_attack_cooldown_timer -= delta

	if is_reloading:
		return

	if Input.is_action_just_pressed("reload") and ammo < max_ammo:
		reload()
		return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and _attack_cooldown_timer <= 0:
		if ammo <= 0:
			reload()
			return

		shoot(_current_projectile_scale, _current_attack_damage)
		_attack_cooldown_timer = _current_attack_interval

func shoot(projectile_scale: float, attack_damage: int) -> void:
	is_shooting = true
	ammo -= 1

	if texture.sprite_frames.has_animation("shoot"):
		texture.play("shoot")

	SoundManager.play(_shoot_sfx, 0)

	var base_direction := (get_global_mouse_position() - global_position).normalized()
	var spread_rad = deg_to_rad(spread_projectiles_angle_degrees)

	for i in range(projectiles):
		var projectile_direction = base_direction

		if projectiles > 1:
			var step = spread_rad / (projectiles - 1)
			var current_angle = -spread_rad / 2 + (step * i)
			projectile_direction = base_direction.rotated(current_angle)

		var new_projectile: BaseProjectile = _projectile.instantiate()
		new_projectile.direction = projectile_direction
		new_projectile.spawn_position = projectile_spawn_point.global_position
		new_projectile.spawn_rotation = projectile_direction.angle()
		new_projectile.scale = Vector2.ONE * projectile_scale
		new_projectile.damage = attack_damage

		get_tree().current_scene.add_child.call_deferred(new_projectile)

	weapon_fired.emit()
	ammo_updated.emit()

	is_shooting = false

	if ammo == 0:
		reload()

func _on_animation_finished() -> void:
	texture.play("idle")

func reload() -> void:
	if texture.sprite_frames.has_animation("reload"):
		texture.play("reload")

	SoundManager.play(_reload_sfx, -4)
	start_reload.emit()
	is_reloading = true
	await get_tree().create_timer(reload_time).timeout
	ammo = max_ammo
	ammo_updated.emit()
	is_reloading = false
