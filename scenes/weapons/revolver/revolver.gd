extends BaseWeapon
class_name RevolverWeapon

func _init() -> void:
	_projectile = preload("res://scenes/projectiles/musket_ball/musket_ball_projectile.tscn")
	crosshair = preload("res://scenes/weapons/revolver/crosshair.png")
