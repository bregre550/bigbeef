class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State_Attack = $"../Attack"
@onready var dodge: State_Dodge = $"../Dodge"
@onready var shoot: State_Shoot = $"../Shoot"

func Enter() -> void:
	player.update_animation( "idle" )
	
func Exit() -> void:
	pass
	
func Process( _delta: float ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
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
