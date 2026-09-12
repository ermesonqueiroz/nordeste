extends Resource
class_name BaseUpgrade

@export var name: String = "Nome do Upgrade"
@export_multiline var description: String = "Descrição do efeito do upgrade."

func apply_upgrade(_character: BaseCharacter) -> void:
	pass
