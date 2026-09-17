extends TextureProgressBar

var _character: BaseCharacter

var _reload_time: float = 0.0
var _progress_timer: float = 0.0

func _ready() -> void:
	visible = false

func setup(character: BaseCharacter) -> void:
	_character = character

	if _character.weapon:
		_character.weapon.start_reload.connect(_on_start_reload)

func _process(delta: float) -> void:
	if _progress_timer <= 0:
		visible = false
		return

	visible = true
	value = (_reload_time - _progress_timer) * 100 / _reload_time
	_progress_timer -= delta

func _on_start_reload() -> void:
	visible = true
	_reload_time = _character.weapon.reload_time
	_progress_timer = _character.weapon.reload_time
