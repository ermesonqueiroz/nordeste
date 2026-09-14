extends Resource
class_name BaseUpgrade

var id: String = "upgrade_id"
var name: String = "Nome do Upgrade"
var description: String = "Descrição do efeito do upgrade."
var icon: Texture2D = null
var max_uses: int = -1

func apply_upgrade(_character: BaseCharacter) -> void:
	pass
