extends Resource
class_name BaseUpgrade

var name: String = "Nome do Upgrade"
var description: String = "Descrição do efeito do upgrade."
var icon: Texture2D = null

func apply_upgrade(_character: BaseCharacter) -> void:
	pass
