extends BaseWeapon
class_name FiregunWeapon

func _init() -> void:
	_projectile = preload("res://scenes/projectiles/bullet/bullet_projectile.tscn")
	crosshair = preload("res://scenes/weapons/firegun/crosshair.png")
