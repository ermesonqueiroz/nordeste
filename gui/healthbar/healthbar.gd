extends Control
class_name HealthBar

@export var base_height: float = 0.0
@export var pixels_per_hp: float = 26.0
@export var character: BaseCharacter

@onready var background: NinePatchRect = $Background
@onready var fill_mask: Control = $FillMask
@onready var health_fill: NinePatchRect = $FillMask/Fill
@onready var damage_fill: ColorRect = $FillMask/Damage

func _ready() -> void:
	if not character:
		push_warning("HealthBar: Nenhum personagem atribuído!")
		return

	character.health_updated.connect(_on_character_health_updated)
	await get_tree().process_frame
	_apply_health_instant(character.max_health, character.current_health)

func _on_character_health_updated() -> void:
	update_health_bar(character.max_health, character.current_health)

func _apply_health_instant(max_hp: int, current_hp: int) -> void:
	var target_height = _calculate_total_height(max_hp)
	var target_fill_height = _calculate_fill_height(target_height, max_hp, current_hp)

	background.custom_minimum_size.y = target_height
	fill_mask.custom_minimum_size.y = target_height
	health_fill.size.y = target_fill_height
	damage_fill.size.y = target_fill_height # A barra branca começa igualada

func update_health_bar(new_max: int, new_current: int) -> void:
	var target_height = _calculate_total_height(new_max)
	var target_fill_height = _calculate_fill_height(target_height, new_max, new_current)

	var tween = create_tween().set_parallel(true)

	tween.tween_property(health_fill, "size:y", target_fill_height, 0.15)

	tween.tween_property(background, "custom_minimum_size:y", target_height, 0.3)
	tween.tween_property(fill_mask, "custom_minimum_size:y", target_height, 0.3)

	var damage_tween = create_tween()
	damage_tween.tween_interval(0.2)
	damage_tween.tween_property(damage_fill, "size:y", target_fill_height, 0.4)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _calculate_total_height(max_hp: int) -> float:
	if max_hp <= 0: return 4.0 * 26.0
	return base_height + (float(max_hp) * pixels_per_hp)

func _calculate_fill_height(total_height: float, max_hp: int, current_hp: int) -> float:
	if max_hp <= 0:
		return 0.0

	var clamped_hp = clamp(current_hp, 0, max_hp)
	var fill_height = float(clamped_hp) * pixels_per_hp
	var border_padding = 6.0

	return min(fill_height, total_height - border_padding)
