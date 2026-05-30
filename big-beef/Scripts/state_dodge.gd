class_name State_Dodge extends State

var dodging: bool = false

@export var dodge_speed: float = 110.0
@export var dodge_duration: float = 0.3

@onready var animation: AnimationPlayer = $"../../AttackSprite/AttackAnimationPlayer"

var was_strafing: bool = false
var prev_dir: Vector2
var dodge_dir: Vector2

@onready var idle: State_Idle = $"../Idle"
@onready var walk: State = $"../Walk"

func Enter() -> void:
	was_strafing = player.is_strafing
	prev_dir = player.cardinal_direction
		
	if player.direction != Vector2.ZERO:
		dodge_dir = player.direction.normalized()
		player.is_strafing = false
		player.set_direction()
	else:
		dodge_dir = player.cardinal_direction
		
	player.make_invulnerable(dodge_duration)
	player.velocity = dodge_dir * dodge_speed
	
	player.is_strafing = false
	player.animation.animation_finished.connect(_end_dodge)
	player.update_animation("dodge")
	
	dodging = true
	
func Exit() -> void:
	if was_strafing:
		player.cardinal_direction = prev_dir
		player.is_strafing = true
		#player.update_animation("idle")
	else:
		player.is_strafing = false
		#player.set_direction()
		
	player.animation.animation_finished.disconnect(_end_dodge)
	dodging = false
	player.invulernable = false
	was_strafing = false
	
func Process(_delta: float) -> State:	
	if not dodging:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics( _delta: float ) -> State:
	player.velocity = dodge_dir * dodge_speed
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func _end_dodge(_new_anim_name: String) -> void:
	dodging = false
