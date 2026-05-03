class_name EnemyStateAttack extends EnemyState

var attacking: bool = false

@export var anim_name: String = "attack"
@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0
@export var slime_ball: PackedScene

@onready var animation: AnimationPlayer = $"../../AnimationPlayer"
@onready var chase: EnemyStateChase = $"../Chase"

func init() -> void:
	pass
	
func enter() -> void:
	enemy.update_animation(anim_name)
	animation.animation_finished.connect(_end_attack)
	attacking = true
	
	var b = slime_ball.instantiate()
	get_tree().root.add_child(b)
	b.global_position = enemy.global_position
	b.shoot(enemy.direction)
	
func exit() -> void:
	animation.animation_finished.disconnect(_end_attack)
	attacking = false
	
	
func process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	
	if not attacking:
		return chase
	
	return null

func physics(_delta: float) -> EnemyState:
	return null
	
func _end_attack(_new_anim_name: String) -> void:
	attacking = false
