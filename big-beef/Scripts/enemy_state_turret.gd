class_name EnemyStateTurret extends EnemyState

var attacking: bool = false


@export var anim_name: String = "attack"
@export var slime_ball: PackedScene
@export var aim_spread: float = 5.0

@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var guard: EnemyStateGuard = $"../Guard"
func init() -> void:
	pass
	
func enter() -> void:
	var b = slime_ball.instantiate()
	get_tree().root.add_child(b)
	b.global_position = enemy.global_position
	var spread: float = deg_to_rad(randf_range(-aim_spread, aim_spread))
	var bullet_direction: Vector2 = enemy.direction.rotated(spread)
	b.shoot(bullet_direction)
	
	enemy.update_animation(anim_name)
	animation.animation_finished.connect(_end_attack)
	attacking = true
	
func exit() -> void:
	animation.animation_finished.disconnect(_end_attack)
	attacking = false
	
func process(_delta: float) -> EnemyState:
	if not attacking:
		return guard
	
	return null

func physics(_delta: float) -> EnemyState:
	return null
	
func _end_attack(_new_anim_name: String) -> void:
	attacking = false
