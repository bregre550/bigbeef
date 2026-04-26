class_name Player extends CharacterBody2D

@export var speed = 200

@onready var sprite: Sprite2D = $Sprite2D

signal direction_changed

var prev_direction : Vector2 = Vector2.ZERO

var hp : int = 100
var max_hp : int = 100

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down").normalized()
	if input_direction != prev_direction:
		direction_changed.emit(input_direction)
	prev_direction = input_direction
	velocity = input_direction * speed
	
func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
	
