class_name EnemyStateStun extends EnemyState

@export var anim_name : String = "stun"
@export var knockback_speed : float = 300.0
@export var decelerate_speed : float = 5.0
@export var invulnerable_duration: float = 1.0
@export var return_to_chase: float = 0.6

@export_category("AI")
@export var next_state : EnemyState

@onready var attack: EnemyStateAttack = $"../Attack"
@onready var chase: EnemyStateChase = $"../Chase"

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false

func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass
	
## What happens when the enemy enters this State?
func enter() -> void:
	attack.chase_time = chase.shoot_delay
	enemy.make_invulnerable(invulnerable_duration)
		
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.set_direction(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	_animation_finished = false
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	print("animation started")

## What happens when the enemy exits this State?
func exit() -> void:
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	
## What happens during the _proces updates in this State?
func process(_delta : float) -> EnemyState:
	if _animation_finished:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
## What happens during the _physics_proces update in this State?
func physics(_delta : float) -> EnemyState:
	return null
	
func _on_enemy_damaged(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)
	
func _on_animation_finished(_a : String) -> void:
	_animation_finished = true
	print("animation finished")
