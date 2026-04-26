class_name Abilities extends Node2D

@export var bullet : PackedScene
var shoot_direction : Vector2 = Vector2.RIGHT
var prev_direction : Vector2
var player : Player

func _ready() -> void:
	player = get_parent()
	player.direction_changed.connect(_direction_changed)

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		var b = bullet.instantiate()
		get_tree().root.add_child(b)
		b.global_position = player.global_position
		b.shoot(shoot_direction)
		
func _direction_changed(_new_dir : Vector2) -> void:
	if _new_dir != Vector2.ZERO:
		shoot_direction = _new_dir
		
