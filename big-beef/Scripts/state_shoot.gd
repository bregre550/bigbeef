class_name State_Shoot extends State

var shooting: bool = false

@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

@onready var animation: AnimationPlayer = $"../../AttackSprite/AttackAnimationPlayer"

@onready var idle: State_Idle = $"../Idle"
@onready var walk: State = $"../Walk"

@export var sword_beam: PackedScene

var offset_key = {
	Vector2.LEFT: 10.0,
	Vector2(-1, -1): 10.0,
	Vector2.UP: 18.0,
	Vector2(1, -1): 10.0,
	Vector2.RIGHT: 10.0,
	Vector2(1, 1): 4.0,
	Vector2.DOWN: 4.0,
	Vector2(-1, 1): 4.0,
}

var shoot_direction : Vector2 = Vector2.DOWN
var prev_direction : Vector2

func Enter() -> void:
	player.update_animation("attack")
	animation.play("attack_" + player.anim_direction())
	animation.animation_finished.connect(_end_shot)
	
	var b = sword_beam.instantiate()
	get_tree().root.add_child(b)
	
	var spawn_distance: float = offset_key[player.cardinal_direction]
	var spawn_offset: Vector2 = player.cardinal_direction * spawn_distance
	
	if player.cardinal_direction == Vector2.RIGHT or player.cardinal_direction == Vector2.LEFT:
		spawn_offset.y -= 5
	
	b.global_position = player.global_position + spawn_offset
	b.shoot(player.cardinal_direction)
	b.animate()
	
	shooting = true
	player.modulate_attack_sprite(Color(1, 1, 1))
	
func Exit() -> void:
	animation.animation_finished.disconnect(_end_shot)
	shooting = false
	
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if not shooting:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func _end_shot(_new_anim_name: String) -> void:
	shooting = false
