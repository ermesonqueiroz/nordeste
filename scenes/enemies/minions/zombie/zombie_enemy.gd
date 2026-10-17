extends BaseEnemy
class_name ZombieEnemy

@onready var attack_hitbox: HitBox = $AttackHitBox
@onready var warning_sprite: Node2D = $SpriteGroup/Warning
@onready var explosion_sfx: AudioStream = preload("res://sfx/explosion.wav")

func _ready() -> void:
	super._ready()
	attack_hitbox.disable()
	warning_sprite.visible = false

func _process(_delta: float) -> void:
	sprite_group.scale.x = -1 if last_direction.x < 0 else 1

func play_explosion_sound() -> void:
	SoundManager.play(explosion_sfx, -3, global_position)
