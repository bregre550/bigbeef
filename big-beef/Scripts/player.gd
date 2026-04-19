class_name Player extends CharacterBody2D

@export var speed = 400

@onready var sprite: Sprite2D = $Sprite2D

var hp : int = 100
var max_hp : int = 100

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down").normalized()
	velocity = input_direction * speed
	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
