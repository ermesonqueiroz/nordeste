extends Node2D
class_name DamageLabelSpawner

@export var label_settings: LabelSettings

func spawn_label(amount: float):
	var new_label: Label = Label.new()

	new_label.text = str(amount if step_decimals(amount) <= 0 else amount as int)
	new_label.label_settings = label_settings.duplicate()
	new_label.z_index = 1000

	new_label.pivot_offset = Vector2(0, 0)

	call_deferred("add_child", new_label)
	await new_label.resized

	new_label.position -= Vector2(new_label.size.x / 2, new_label.size.y / 2)
	new_label.pivot_offset = new_label.size / 2

	new_label.scale = Vector2(0.4, 0.4)
	new_label.modulate.a = 0.0

	var random_x = randf_range(-16, 16)
	var target_position_up = new_label.position + Vector2(random_x, -30)
	var target_position_drop = target_position_up + Vector2(random_x * 0.2, 8)

	var tween = create_tween().set_parallel(true)

	tween.tween_property(new_label, "modulate:a", 1.0, 0.1)
	tween.tween_property(new_label, "modulate:a", 0.0, 0.4).set_delay(0.4)

	var scale_tween = create_tween()
	scale_tween.tween_property(new_label, "scale", Vector2.ONE * 1.3, 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(new_label, "scale", Vector2.ONE * 0.9, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	var move_tween = create_tween()
	move_tween.tween_property(new_label, "position", target_position_up, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	move_tween.tween_property(new_label, "position", target_position_drop, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	move_tween.chain().tween_callback(new_label.queue_free)
