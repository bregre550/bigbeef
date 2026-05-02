class_name State_Walk extends State

@export var strafe_speed: float = 65.0
@export var normal_speed: float = 100.0
@export var move_speed : float
@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"

func Enter() -> void:
	player.UpdateAnimation( "walk" )
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	if player.is_strafing:
		move_speed = strafe_speed
	else:
		move_speed = normal_speed
		
	
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
		
	return null
	

	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	#if _event.is_action_pressed( "attack" ):
		#return attack
		
	return null
