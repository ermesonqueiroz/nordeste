extends Node

const PATH_JSON_DATA = "res://data/Ne4 - Game Data.json"

func load_json_data_from_path(path: String):
	var file_string = FileAccess.get_file_as_string(path)
	var json_data

	if file_string != null:
		json_data = JSON.parse_string(file_string)
	else:
		push_warning("load_json_data_from_path failed get_file_as_string for path: ", path)

	if json_data == null:
		push_error("load_json_data_from_path failed to parse data to JSON for path: ", path)

	return json_data


func flash_node_material(node: Node2D, tween: Tween = null) -> Tween:
	if not node or not node.material is ShaderMaterial:
		return tween

	var mat := node.material

	if not tween:
		tween = create_tween().set_parallel().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	tween.tween_method(
		func(val): mat.set_shader_parameter("flash_value", val),
		0, 1, 0.15
	)
	tween.chain().tween_method(
		func(val): mat.set_shader_parameter("flash_value", val),
		1, 0, 0.15
	)

	return tween
