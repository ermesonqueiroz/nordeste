extends BaseWeapon
class_name RevolverWeapon

func _init() -> void:
	_projectile = preload("res://projectiles/bullet/bullet_projectile.tscn")
	crosshair = preload("res://weapons/revolver/crosshair.png")
