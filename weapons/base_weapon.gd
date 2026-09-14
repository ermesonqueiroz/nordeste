extends Node2D
class_name BaseWeapon

@export var orbit_distance: float = 24.0
@export var _character: BaseCharacter

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
