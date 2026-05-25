class_name State_Walk extends State

@export var strafe_speed: float = 65.0
@export var normal_speed: float = 100.0
@export var move_speed : float
@onready var idle: State = $"../Idle"
@onready var attack: State_Attack = $"../Attack"
@onready var dodge: State_Dodge = $"../Dodge"
@onready var shoot: State_Shoot = $"../Shoot"

func Enter() -> void:
	player.update_animation( "walk" )
	
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
	
	if player.set_direction():
		player.update_animation("walk")
		
	return null
	

	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
		
	elif _event.is_action_pressed("dodge"):
		return dodge
	
	elif _event.is_action_pressed("shoot"):
		if player.bullets_deflected >= player.deflects_needed:
			player.bullets_deflected = 0
			return shoot
		
	return null
