extends Camera2D

@export var intensity: float = 35.0   # O quanto a câmera se mexe (quanto maior, mais forte o efeito)
@export var smooth_speed: float = 6.0 # Velocidade da suavização (Lerp)

var screen_center: Vector2

func _ready() -> void:
	screen_center = get_viewport().get_visible_rect().size / 2.0

func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()

	var camera_offset = (mouse_pos - screen_center) / screen_center
	var target_pos = camera_offset * intensity

	position = position.lerp(target_pos, smooth_speed * delta)
