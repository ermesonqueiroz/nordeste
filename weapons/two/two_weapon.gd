extends BaseWeapon
class_name TwoWeapon

func _init() -> void:
	_projectile = preload("res://projectiles/bullet/bullet_projectile.tscn")
	crosshair = preload("res://weapons/two/crosshair.png")
