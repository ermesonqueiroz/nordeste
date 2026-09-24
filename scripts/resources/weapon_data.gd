extends Resource
class_name WeaponData

@export var weapon_name: String = "Weapon"
@export var weapon_icon: Texture2D
@export var weapon_scene: PackedScene

@export_group("Stats")
@export var damage: int = 20
@export var max_ammo: int = 6
@export var reload_time: float = 1.0
@export var attack_interval: float = 1.0
@export var projectiles: int = 1
@export var spread_projectiles_angle_degrees: float = 15.0

@export_group("Other")
@export var orbit_distance: float = 18
