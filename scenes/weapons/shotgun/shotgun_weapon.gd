extends BaseWeapon
class_name ShotgunWeapon

func _init() -> void:
	_projectile = preload("res://scenes/projectiles/shotgun_shell/shotgun_shell_projectile.tscn")
	crosshair = preload("res://scenes/weapons/shotgun/crosshair.png")
