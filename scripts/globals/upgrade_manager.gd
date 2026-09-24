extends Node

var available_cards: Dictionary[String, UpgradeData] = {}

func _ready():
	var json_data = Utils.load_json_data_from_path(Utils.PATH_JSON_DATA)

	if json_data == null:
		return

	var upgrade_data = json_data.get("Upgrades")

	if upgrade_data == null:
		return

	for key in upgrade_data.keys():
		if not upgrade_data[key]["ACTIVE"]:
			return

		upgrade_data[key]["ID"] = key
		var new_upgrade_data = parse_upgrade_data_from_json(upgrade_data[key])
		available_cards.set(key, new_upgrade_data)

func parse_upgrade_data_from_json(json_data: Dictionary) -> UpgradeData:
	var upgrade_data = UpgradeData.new()
	upgrade_data.id = json_data.get("ID")
	upgrade_data.name = json_data.get("UPGRADE_NAME")
	upgrade_data.description = json_data.get("UPGRADE_DESCRIPTION")
	upgrade_data.max_uses = json_data.get("MAX_USES")
	upgrade_data.icon = load(json_data.get("UPGRADE_ICON"))
	upgrade_data.implementation = load(json_data.get("UPGRADE_SCRIPT")).new()
	return upgrade_data
