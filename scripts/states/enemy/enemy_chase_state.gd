extends State
class_name EnemyChaseState

@export var stop_distance: float = 0

var _update_target_direction_cooldown: float = 0.3
var _update_target_direction_timer: float = 0.0
var _current_target_direction: Vector2 = Vector2.ZERO

@onready var _enemy: BaseEnemy = owner

func update_physics(delta: float):
    _update_target_direction_timer -= delta

    if _update_target_direction_timer <= 0:
        _update_target_direction()
        _update_target_direction_timer = _update_target_direction_cooldown

    if _current_target_direction != Vector2.ZERO:
        _enemy.last_direction = _current_target_direction

    _enemy.velocity = _current_target_direction * _enemy.move_speed
    _enemy.move_and_slide()

    if _current_target_direction == Vector2.ZERO:
        if _enemy.texture.sprite_frames.has_animation("idle"):
            _enemy.texture.play("idle")
    else:
        if _enemy.texture.sprite_frames.has_animation("movement"):
            _enemy.texture.play("movement")

func _update_target_direction():
    var character = get_tree().get_first_node_in_group("player")
    if not character:
        _current_target_direction = Vector2.ZERO
        return

    var distance_to_player = _enemy.global_position.distance_to(character.global_position)

    if distance_to_player > stop_distance:
        _current_target_direction = _enemy.global_position.direction_to(character.global_position).normalized()
    elif distance_to_player < stop_distance - 20.0:
        _current_target_direction = character.global_position.direction_to(_enemy.global_position).normalized()
    else:
        _current_target_direction = Vector2.ZERO
