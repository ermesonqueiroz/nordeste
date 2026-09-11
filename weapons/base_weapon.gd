extends Node2D
class_name BaseWeapon

func _process(_delta: float) -> void:
    look_at(get_global_mouse_position())

    var adjusted_deg = wrap(rotation_degrees - 90, 0, 360)

    if adjusted_deg >= 0 and adjusted_deg <= 180:
        scale.y = -1
    else:
        scale.y = 1

    scale.x = 1
