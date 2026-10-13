extends BaseCharacter
class_name CearenseCharacter

@onready var sprite_group = $SpriteGroup
@onready var arm_front = $SpriteGroup/ArmFront
@onready var arm_back = $SpriteGroup/ArmBack
@onready var hand = $SpriteGroup/ArmFront/Hand
@onready var aim_pivot = $AimPivot

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	var mouse_pos = get_global_mouse_position()

	var dir = mouse_pos - aim_pivot.global_position
	var target_angle = atan2(dir.y, dir.x * sprite_group.scale.x) - (PI / 2)

	arm_front.rotation = lerp_angle(arm_front.rotation, target_angle, 0.15)
