extends BaseEnemy
class_name TejoEnemy

@export var attack_state: State
@export var windup_state: State

@onready var state_machine: StateMachine = $StateMachine
@onready var sprite_trail: SpriteTrail = $SpriteTrail
@onready var warning_sprite: Node2D = $SpriteGroup/Warning

var _warning_tween: Tween

func _ready():
	super._ready()
	sprite_trail.enabled = false
	warning_sprite.visible = false
	warning_sprite.scale = Vector2.ZERO
	state_machine.state_entered.connect(_on_state_entered)

func _physics_process(delta: float):
	super._physics_process(delta)
	if velocity.x != 0:
		sprite_group.scale.x = -1 if velocity.x < 0 else 1

func _on_state_entered(state: State):
	sprite_trail.enabled = state == attack_state

	if state == windup_state:
		_show_windup_warning()

func _show_windup_warning():
	if _warning_tween and _warning_tween.is_running():
		_warning_tween.kill()

	warning_sprite.visible = true
	warning_sprite.scale = Vector2.ZERO

	_warning_tween = create_tween().set_parallel(false)

	_warning_tween.tween_property(warning_sprite, "scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	_warning_tween.set_loops()
	_warning_tween.tween_property(warning_sprite, "scale", Vector2.ONE * 1.2, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_warning_tween.tween_property(warning_sprite, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await get_tree().create_timer(0.8).timeout
	_hide_windup_warning()

func _hide_windup_warning():
	if not warning_sprite.visible:
		return

	if _warning_tween and _warning_tween.is_running():
		_warning_tween.kill()

	_warning_tween = create_tween()
	_warning_tween.tween_property(warning_sprite, "scale", Vector2.ZERO, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	_warning_tween.tween_callback(func(): warning_sprite.visible = false)
