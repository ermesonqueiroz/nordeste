@tool
extends HBoxContainer
class_name HorizontalSpin

signal option_changed(index: int, value: Variant)

@export var option_name: String = "Option":
    set(val):
        option_name = val
        update_label()

@export var choices: Array[String] = ["Choice 1", "Choice 2"]:
    set(val):
        choices = val
        current_index = clamp(current_index, 0, max(0, choices.size() - 1))
        update_label()

@export var values: Array[Variant] = []

@export var current_index: int = 0:
    set(val):
        if choices.size() > 0:
            current_index = wrapi(val, 0, choices.size())
            update_label()

var name_label: Label
var value_label: Label
var left_arrow: TextureButton
var right_arrow: TextureButton

func _ready() -> void:
    _cache_nodes()
    update_label()

    if Engine.is_editor_hint():
        return

    if left_arrow and not left_arrow.pressed.is_connected(_on_left_pressed):
        left_arrow.pressed.connect(_on_left_pressed)

    if right_arrow and not right_arrow.pressed.is_connected(_on_right_pressed):
        right_arrow.pressed.connect(_on_right_pressed)

func _cache_nodes() -> void:
    name_label = get_node_or_null("OptionLabel") as Label
    value_label = get_node_or_null("Container/ValueLabel") as Label
    left_arrow = get_node_or_null("Container/LeftArrow") as TextureButton
    right_arrow = get_node_or_null("Container/RightArrow") as TextureButton

func _on_left_pressed() -> void:
    current_index -= 1
    emit_signal("option_changed", current_index, get_current_value())

func _on_right_pressed() -> void:
    current_index += 1
    emit_signal("option_changed", current_index, get_current_value())

func get_current_value() -> Variant:
    if choices.is_empty():
        return null
    if values.size() > current_index:
        return values[current_index]
    return choices[current_index]

func update_label() -> void:
    if not value_label or not name_label:
        _cache_nodes()
        if not value_label or not name_label:
            return

    name_label.text = option_name + ":"

    if choices.is_empty():
        value_label.text = "Empty"
    else:
        value_label.text = choices[current_index]
