class_name State_Attack extends State

var attacking: bool = false

@export_range(1, 20, 0.5) var decelerate_speed: float = 5.0

@onready var animation: AnimationPlayer = $"../../Sprite2D/AttackSprite/AttackAnimationPlayer"


@onready var idle: State_Idle = $"../Idle"
@onready var walk: State = $"../Walk"

func Enter() -> void:
	player.update_animation("attack")
	animation.play("attack_" + player.anim_direction())
	animation.animation_finished.connect(_end_attack)
	
	attacking = true
	
func Exit() -> void:
	animation.animation_finished.disconnect(_end_attack)
	attacking = false
	
func Process(_delta: float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	if not attacking:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func _end_attack(_new_anim_name: String) -> void:
	attacking = false
