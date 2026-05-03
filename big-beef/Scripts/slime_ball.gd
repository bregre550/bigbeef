class_name Bullet extends CharacterBody2D

@export var speed : int = 400

var direction : Vector2 = Vector2.ZERO
var lifetime : float = 3.0	

func shoot(new_direction : Vector2) -> void:
	direction = new_direction
	velocity = direction * speed
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	
	
