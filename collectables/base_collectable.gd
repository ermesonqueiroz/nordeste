extends Area2D
class_name BaseCollectable

@export var _collect_sfx: AudioStream

@export_category("Floating Effect")
@export var float_speed: float = 4.0
@export var float_amplitude: float = 3.0

@export_category("Pulse Effect")
@export var pulse_speed: float = 6.0
@export var pulse_intensity: float = 0.05

@onready var _texture: Sprite2D = $Texture

var _start_y: float = 0.0
var _time_accumulator: float = 0.0

var _is_collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if _texture:
		_start_y = _texture.position.y

	_time_accumulator = randf() * 10.0

func _process(delta: float) -> void:
	if not _texture:
		return

	_time_accumulator += delta
	_texture.position.y = _start_y + sin(_time_accumulator * float_speed) * float_amplitude

	var scale_x = 1.0 + sin(_time_accumulator * pulse_speed) * pulse_intensity
	var scale_y = 1.0 + cos(_time_accumulator * pulse_speed) * pulse_intensity
	_texture.scale = Vector2(scale_x, scale_y)

func _on_body_entered(body: Node2D) -> void:
	if _is_collected:
		return

	if body is BaseCharacter:
		_on_collected(body)

func _on_collected(_character: BaseCharacter) -> void:
	_is_collected = true

	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

	if _collect_sfx:
		SoundManager.play(_collect_sfx, -5.0)

	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	if _texture:
		tween.tween_property(_texture, "scale", _texture.scale * 1.4, 0.15)
		tween.tween_property(_texture, "modulate:a", 0.0, 0.15)

	tween.chain().tween_callback(func():
		collect_item(_character)
		queue_free()
	)

func collect_item(_character: BaseCharacter) -> void:
	pass
