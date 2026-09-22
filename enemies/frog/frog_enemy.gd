extends BaseEnemy
class_name FrogEnemy

@onready var shadow: Sprite2D = $Shadow
@onready var attack_area: Area2D = $AttackArea
@onready var tongue: FrogTongue = $FrogTongue

var player_direction: Vector2
var player_are_in_attack_area: bool = false

@onready var initial_shadow_y: float = shadow.position.y
@onready var initial_shadow_modulate: Color = shadow.modulate
@onready var initial_shadow_scale: Vector2 = shadow.scale

func _ready() -> void:
	super._ready()

	attack_area.body_entered.connect(_on_attack_area_body_entered)
	attack_area.body_exited.connect(_on_attack_area_body_exited)

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		player_are_in_attack_area = true

func _on_attack_area_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		player_are_in_attack_area = false
