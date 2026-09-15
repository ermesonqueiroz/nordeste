extends BaseWeapon
class_name ChinelaWeapon

func _init() -> void:
	_projectile = preload("res://projectiles/chinela/chinela_projectile.tscn")
	crosshair = preload("res://weapons/chinela/crosshair.png")
