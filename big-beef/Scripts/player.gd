class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
const DIR_4 : Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
var direction : Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D

signal DirectionChanged(new_direction : Vector2)

var hp : int = 100
var max_hp : int = 100

func _ready() -> void:
	pass
	
func _process(_delta : float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()

func _physics_process(_delta: float) -> void:
	move_and_slide()
	print(position.x, global_position.y)
	
func SetDirection() -> bool:
	if direction == Vector2.ZERO:
		return false
		
	var direction_id : int = int(round((direction).angle() / TAU * DIR_4.size()))
	var new_direction = DIR_4[direction_id]
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	DirectionChanged.emit(new_direction)
	
	return true
	
