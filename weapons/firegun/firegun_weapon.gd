extends BaseWeapon
class_name FiregunWeapon

func _init() -> void:
	_projectile = preload("res://projectiles/bullet/bullet_projectile.tscn")
	crosshair = preload("res://weapons/firegun/crosshair.png")
