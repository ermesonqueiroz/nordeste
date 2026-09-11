extends Node2D
class_name SwordWeapon

func _process(_delta: float) -> void:
    look_at(get_global_mouse_position())

    # Desloca o eixo para que o 0 fique embaixo (90 graus no padrão do Godot) e normaliza de 0 a 360
    var adjusted_deg = wrap(rotation_degrees - 90, 0, 360)

    # Entre 0 e 180 (passando pelo lado esquerdo) a espada fica invertida; o restante fica normal
    if adjusted_deg >= 0 and adjusted_deg <= 180:
        scale.y = -1
    else:
        scale.y = 1

    scale.x = 1
