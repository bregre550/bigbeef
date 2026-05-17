class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction : Vector2)
signal enemy_damaged(hurt_box : HurtBox)
signal enemy_destroyed(hurt_box : HurtBox)

const DIR_4 : Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp : int = 5

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

# onready variables go here
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
@onready var hit_box: HitBox = $HitBox

func _ready() -> void:
	state_machine.initialize(self)
	hit_box.damaged.connect(_take_damage)
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func set_direction(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int(round((direction).angle() / TAU * DIR_4.size()))
	var new_direction = DIR_4[direction_id]
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	return true
	
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())
	pass
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.LEFT: 
		return "left"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	else:
		return "down"
		
func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
	
func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
