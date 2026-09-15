extends Node2D
class_name BaseWeapon

@export var orbit_distance: float = 24.0
@export var _character: BaseCharacter
@onready var _animation: AnimationPlayer = $Animation

var _projectile: PackedScene
var crosshair: Texture2D

func _ready() -> void:
	_animation.animation_finished.connect(_on_animation_finished)

func _process(_delta: float) -> void:
	if not _character:
		return

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
	if _animation.has_animation("shoot"):
		_animation.play("shoot")

	await _animation.animation_finished

	var mouse_position := (get_global_mouse_position() - global_position).normalized()

	var new_projectile: BaseProjectile = _projectile.instantiate()
	new_projectile.direction = mouse_position
	new_projectile.spawn_position = global_position + (mouse_position * 40)
	new_projectile.spawn_rotation = mouse_position.angle()
	new_projectile.scale = Vector2.ONE * projectile_scale
	new_projectile.damage = attack_damage

	get_tree().current_scene.add_child.call_deferred(new_projectile)

func _on_animation_finished(animation_name: String) -> void:
	if animation_name == "shoot":
		if not _animation.has_animation("shoot"):
			return

		_animation.play("idle")
