extends Resource
class_name UpgradeData

@export var id: String = "id"
@export var name: String = "Nome do Upgrade"
@export var description: String = "Descrição do efeito do upgrade."
@export var icon: Texture2D = null
@export var max_uses: int = -1
@export var implementation: BaseUpgrade
