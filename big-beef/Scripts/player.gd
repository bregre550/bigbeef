class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
const DIR_8: Array[ Vector2 ] = [ Vector2.RIGHT, Vector2(1, 1), Vector2.DOWN, Vector2(-1, 1), Vector2.LEFT, Vector2(-1, -1), Vector2.UP, Vector2(1, -1) ]
var direction : Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $StateMachine

signal direction_changed(new_direction: Vector2)

var prev_direction : Vector2 = Vector2.ZERO
var is_strafing : bool = false

var hp : int = 100
var max_hp : int = 100

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)

func _input( event: InputEvent ):
	if event.is_action( "strafe" ):
		if event.is_pressed():
			is_strafing = true
		elif event.is_released():
			is_strafing = false

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
func _physics_process( _delta: float ) -> void:
	move_and_slide()
	
func SetDirection() -> bool:
	if direction == Vector2.ZERO || is_strafing:
		return false
		
	var direction_id: int = int(round((direction).angle() / TAU * DIR_8.size()))
	var new_direction = DIR_8[direction_id]
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	return true
	
func UpdateAnimation(state: String) -> void:
	animation.play(state + "_" + AnimDirection())
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	elif cardinal_direction == Vector2(1, 1):
		return "down_right"
	elif cardinal_direction == Vector2(-1, 1):
		return "down_left"
	elif cardinal_direction == Vector2(-1, -1):
		return "up_left"
	elif cardinal_direction == Vector2(1, -1):
		return "up_right"
	else:
		return "left"
