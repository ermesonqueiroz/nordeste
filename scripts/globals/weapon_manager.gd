extends Node

var available_weapons: Dictionary[String, WeaponData] = {}

func _ready() -> void:
	var json_data = Utils.load_json_data_from_path(Utils.PATH_JSON_DATA)

	if json_data == null:
		return

	var weapon_data = json_data.get("Weapons")

	if weapon_data == null:
		return

	for key in weapon_data.keys():
		var new_weapon_data = parse_weapon_data_from_json(weapon_data[key])
		available_weapons.set(key, new_weapon_data)

func parse_weapon_data_from_json(json_data: Dictionary) -> WeaponData:
	var weapon_data = WeaponData.new()
	weapon_data.weapon_name = json_data.get("WEAPON_NAME")
	weapon_data.damage = json_data.get("DAMAGE")
	weapon_data.max_ammo = json_data.get("MAX_AMMO")
	weapon_data.reload_time = json_data.get("RELOAD_TIME")
	weapon_data.attack_interval = json_data.get("ATTACK_INTERVAL")
	weapon_data.projectiles = json_data.get("PROJECTILES")
	weapon_data.spread_projectiles_angle_degrees = json_data.get("SPREAD_PROJECTILES_ANGLE_DEGREES")
	weapon_data.orbit_distance = json_data.get("ORBIT_DISTANCE")
	weapon_data.weapon_icon = load(json_data.get("WEAPON_ICON"))
	weapon_data.weapon_scene = load(json_data.get("WEAPON_SCENE"))

	return weapon_data
