class_name SwordBeam extends CharacterBody2D

@export var speed : int = 125
var direction: Vector2 = Vector2.DOWN
var lifetime : float = 3.0	

@onready var animation: AnimationPlayer = $AnimationPlayer

func shoot(new_direction : Vector2) -> void:
	direction = new_direction
	rotation = direction.angle() + (PI / 2)
	velocity = direction * speed
	
func animate() -> void:
	animation.play("shoot")
	await animation.animation_finished
	animation.play("fly")
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	lifetime -= delta
	if lifetime <= 0:
		queue_free()	
	
