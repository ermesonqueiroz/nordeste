extends Label

var update_timer: float = 0.0

func _process(delta: float) -> void:
    if not GameManager:
        return

    update_timer += delta
    if update_timer >= 1.0:
        update_timer = 0.0
        update_display()

func update_display() -> void:
    var total_seconds = int(GameManager.survival_time)
    var minutes = total_seconds / 60.0
    var seconds = total_seconds % 60

    text = "%02d:%02d" % [minutes, seconds]
