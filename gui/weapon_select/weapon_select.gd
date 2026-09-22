extends Control

@export var weapon_button: PackedScene
@export var weapon_stats_panel: PanelContainer
@export var weapon_name_label: Label
@export var weapon_damage_label: Label
@export var weapon_ammo_label: Label
@export var attack_interval_label: Label
@export var reload_time_label: Label
@export var start_button: Button
@export var back_button: Button

@onready var shelf_slots: Array[Node] = [
	$Weapons/Slot1,
	$Weapons/Slot2,
	$Weapons/Slot3,
	$Weapons/Slot4
]
@onready var _enter_weapon_selection_sfx: AudioStream = preload("res://sfx/enter_weapon_selection.wav")

const SHARED_GROUP = preload("res://gui/weapon_select/button_group.tres")

var selected_weapon: WeaponData = null
var selected_button: Control = null

func _ready() -> void:
	weapon_stats_panel.visible = false
	_populate_shelf()
	start_button.disabled = true

	start_button.pressed.connect(_on_start_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)

	await get_tree().create_timer(0.4).timeout
	SoundManager.play(_enter_weapon_selection_sfx, -2)

func _populate_shelf() -> void:
	for i in range(min(WeaponManager.available_weapons.size(), shelf_slots.size())):
		var weapon_data = WeaponManager.available_weapons.values()[i]
		var target_slot = shelf_slots[i] as Node2D

		var card = weapon_button.instantiate()
		if card and target_slot:
			card.initial_scale = Vector2.ONE - (Vector2.ONE * (i * 0.1))
			card.setup(weapon_data)
			card.button_group = SHARED_GROUP
			card.pressed.connect(func(): _on_weapon_selected(weapon_data))

			get_tree().current_scene.add_child(card)
			card.global_position = target_slot.global_position - (card.size / 2)

func _on_weapon_selected(weapon_data: WeaponData) -> void:
	start_button.disabled = false
	selected_weapon = weapon_data
	GameManager.selected_weapon = weapon_data
	update_weapon_stats()

func update_weapon_stats() -> void:
	weapon_stats_panel.visible = true
	weapon_name_label.text = selected_weapon.weapon_name
	weapon_damage_label.text = str(selected_weapon.damage)
	weapon_ammo_label.text = str(selected_weapon.max_ammo)
	attack_interval_label.text = "%.2fs" % selected_weapon.attack_interval
	reload_time_label.text = "%.2fs" % selected_weapon.reload_time

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game_level.tscn")

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://gui/main_menu/main_menu.tscn")
