extends PointLight2D
class_name CharacterLight

func _ready() -> void:
	var tween = get_tree().create_tween() \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_SINE) \
		.set_loops()

	tween.tween_property(self, "scale", Vector2.ONE * 0.9, 3.0)
	tween.chain().tween_property(self, "scale", Vector2.ONE, 2.0)
