extends Node2D
class_name FrogTongue

@onready var _links: Sprite2D = $Links
@onready var _tip: Area2D = $Tip

var direction: Vector2
var max_distance: float = 161.0

var is_shooting: bool = false
var shoot_timer: float = 0.0
var total_duration: float = 0.0

var is_returning: bool = false

func _ready() -> void:
	visible = false

	_tip.area_entered.connect(_on_tip_area_entered)
	_tip.body_entered.connect(_on_tip_body_entered)

func _physics_process(delta: float) -> void:
	if not is_shooting:
		return

	shoot_timer += delta
	var progress = shoot_timer / total_duration

	if progress >= 1.0:
		is_shooting = false
		visible = false
		return

	var current_progress = progress
	if is_returning:
		current_progress = 1.0 - progress

	var smooth_progress = sin(current_progress * PI)
	var current_distance = smooth_progress * max_distance

	_tip.position = (position + direction * 20) + (direction * current_distance)
	_tip.rotation = direction.angle() + PI / 2

func _process(_delta: float) -> void:
	if not visible:
		return

	_links.rotation = _tip.rotation

	var tongue_size = (_tip.position - (position + direction * 20)).length()
	_links.region_rect.size.y = tongue_size
	_links.position = _tip.position

func shoot(shoot_direction: Vector2, duration: float) -> void:
	visible = true
	direction = shoot_direction
	_tip.position = position + shoot_direction * 20

	shoot_timer = 0.0
	total_duration = duration
	is_shooting = true
	is_returning = false

func _on_tip_area_entered(_area: Area2D) -> void:
	if is_shooting and not is_returning:
		_trigger_return()

func _on_tip_body_entered(_body: Node2D) -> void:
	if is_shooting and not is_returning:
		_trigger_return()

func _trigger_return() -> void:
	is_returning = true
	shoot_timer = total_duration - shoot_timer
