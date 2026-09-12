extends Node2D
class_name DamageLabelSpawner

@export var label_settings: LabelSettings

func spawn_label(amount: float):
	var new_label: Label = Label.new()

	new_label.text = str(amount if step_decimals(amount) <= 0 else amount as int)
	new_label.label_settings = label_settings.duplicate()
	new_label.z_index = 1000
	new_label.pivot_offset_ratio = Vector2(0.5, 1)

	call_deferred("add_child", new_label)
	await new_label.resized
	new_label.position -= Vector2(new_label.size.x / 2, 0)

	var target_position = new_label.position + Vector2(randf_range(-5, 5), randf_range(-22, -16))
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(new_label, "position", target_position, 1)
	tween.parallel().tween_property(new_label, "scale", Vector2.ONE * 1.35, 1)
	tween.parallel().tween_property(new_label, "modulate:a", 0, 0.6).set_delay(0.6).connect("finished", new_label.queue_free)
