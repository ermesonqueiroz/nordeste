extends TextureProgressBar

@export var weapon: BaseWeapon

var _reload_time: float = 0.0
var _progress_timer: float = 0.0

func _ready() -> void:
	visible = false

	if weapon:
		weapon.start_reload.connect(_on_start_reload)

func _process(delta: float) -> void:
	if _progress_timer <= 0:
		visible = false
		return

	visible = true
	value = (_reload_time - _progress_timer) * 100 / _reload_time
	_progress_timer -= delta

func _on_start_reload() -> void:
	visible = true
	_reload_time = weapon.reload_time
	_progress_timer = weapon.reload_time
