class_name State_Dodge extends State

var dodging: bool = false

@export var dodge_speed: float = 125.0
@export var dodge_duration: float = 0.3

@onready var animation: AnimationPlayer = $"../../Sprite2D/AttackSprite/AttackAnimationPlayer"

@onready var idle: State_Idle = $"../Idle"
@onready var walk: State = $"../Walk"

func Enter() -> void:
	player.make_invulnerable(dodge_duration)
	player.velocity = player.direction * dodge_speed
	player.animation.animation_finished.connect(_end_dodge)
	player.update_animation("dodge")
	
	dodging = true
	
func Exit() -> void:
	player.animation.animation_finished.disconnect(_end_dodge)
	dodging = false
	player.invulernable = false
	
func Process(_delta: float) -> State:	
	if not dodging:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics( _delta: float ) -> State:
	player.velocity = player.direction * dodge_speed
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func _end_dodge(_new_anim_name: String) -> void:
	dodging = false
