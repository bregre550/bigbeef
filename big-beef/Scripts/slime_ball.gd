class_name SlimeBall extends CharacterBody2D

@onready var hurt_box: HurtBox = $Sprite2D/HurtBox
@onready var bounce_box: BounceBox = $BounceBox

@export var speed : int = 150

var direction : Vector2 = Vector2.ZERO
var lifetime : float = 3.0	

func _ready() -> void:
	hurt_box.area_entered.connect(_on_area_entered)
	bounce_box.area_entered.connect(deflect)

func shoot(new_direction : Vector2) -> void:
	direction = new_direction
	velocity = direction * speed
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	lifetime -= delta
	
	if lifetime <= 0:
		queue_free()
		
func _on_area_entered(_b: Area2D) -> void:
	queue_free()
	
func deflect(_b: Area2D) -> void:
	velocity *= -1
	lifetime = 3.0
	hurt_box.set_collision_mask_value(2, false)
	hurt_box.set_collision_mask_value(9, true)


	
	
