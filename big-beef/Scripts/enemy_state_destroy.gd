class_name EnemyStateDestroy extends EnemyState

@onready var effect_animation_player: AnimationPlayer = $"../../EffectAnimationPlayer"

@export var anim_name: String = "stun"

var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	
## What happens when the enemy enters this State?
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_animation_finished = false
	enemy.update_animation(anim_name)
	
	effect_animation_player.play("destroy")
	await effect_animation_player.animation_finished
	enemy.queue_free()

## What happens when the enemy exits this State?
func exit() -> void:
	pass
	
## What happens during the _proces updates in this State?
func process(_delta : float) -> EnemyState:
	return null
	
## What happens during the _physics_proces update in this State?
func physics(_delta : float) -> EnemyState:
	return null
	
func _on_enemy_destroyed(_hurt_box : HurtBox) -> void:
	state_machine.change_state(self)
