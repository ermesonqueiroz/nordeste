extends Resource
class_name UpgradeData

@export var id: String = "upgrade_id"
@export var name: String = "Nome do Upgrade"
@export var description: String = "Descrição do efeito do upgrade."
@export var icon: Texture2D = null
@export var max_uses: int = -1

func apply_upgrade(_character: BaseCharacter) -> void:
	pass
