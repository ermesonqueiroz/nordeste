extends NinePatchRect

@export var animation_frames: Array[Texture2D] = []
@export var fps: float = 10.0

var time_accumulator: float = 0.0

func _process(delta: float) -> void:
	if animation_frames.is_empty():
		return

	time_accumulator += delta
	var current_frame = int(time_accumulator * fps) % animation_frames.size()

	texture = animation_frames[current_frame]
