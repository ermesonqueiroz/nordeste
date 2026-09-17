extends Node2D
class_name BaseWeapon

signal weapon_fired
signal ammo_updated
signal start_reload

@export var orbit_distance: float = 24.0
@export var initial_projectile_scale = 1.2

@onready var _animation: AnimationPlayer = $Animation

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
var reload_time: float = 0.0

func _ready() -> void:
	_animation.animation_finished.connect(_on_animation_finished)

func setup(weapon_data: WeaponData) -> void:
	if not weapon_data:
		return

	_current_attack_interval = weapon_data.attack_interval
	_current_attack_damage = weapon_data.damage
	max_ammo = weapon_data.max_ammo
	ammo = max_ammo
	reload_time = weapon_data.reload_time

func _process(delta: float) -> void:
	if not _character:
		return

	_look_to_player()

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

func _look_to_player() -> void:
	var mouse_pos = get_global_mouse_position()
	var char_pos = _character.global_position

	var direction = (mouse_pos - char_pos).normalized()

	global_position = char_pos + direction * orbit_distance

	look_at(mouse_pos)

	var angle_deg = rad_to_deg(direction.angle())
	if angle_deg > 90 or angle_deg < -90:
		scale.y = -1
	else:
		scale.y = 1

	scale.x = 1

func shoot(projectile_scale: float, attack_damage: int) -> void:
	ammo -= 1

	if _animation.has_animation("shoot"):
		_animation.play("shoot")

	await _animation.animation_finished

	var mouse_position := (get_global_mouse_position() - global_position).normalized()

	var new_projectile: BaseProjectile = _projectile.instantiate()
	new_projectile.direction = mouse_position
	new_projectile.spawn_position = global_position + (mouse_position * 40) - Vector2(0, 8)
	new_projectile.spawn_rotation = mouse_position.angle()
	new_projectile.scale = Vector2.ONE * projectile_scale
	new_projectile.damage = attack_damage

	get_tree().current_scene.add_child.call_deferred(new_projectile)
	weapon_fired.emit()
	ammo_updated.emit()

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "shoot":
		if not _animation.has_animation("shoot"):
			return

		_animation.play("idle")

func reload() -> void:
	start_reload.emit()
	is_reloading = true
	await get_tree().create_timer(reload_time).timeout
	ammo = max_ammo
	ammo_updated.emit()
	is_reloading = false
