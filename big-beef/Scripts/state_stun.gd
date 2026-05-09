class_name State_Stun extends State

@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 5.0
@export var invulnerable_duration: float = 1.5

var hurt_box: HurtBox
var direction: Vector2

var next_state: State = null

@onready var idle: State = $"../Idle"

func init() -> void:
	player.player_damaged.connect(_player_damaged)
	
func Enter() -> void:
	player.animation.animation_finished.connect(_animation_finished)
	player.make_invulnerable(invulnerable_duration)
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	player.set_direction()
	player.update_animation("stun")
	
	player.effect_animation_player.play("damaged")
		
	next_state = null
	
func Exit() -> void:
	player.animation.animation_finished.disconnect(_animation_finished)
	
	
func Process( _delta: float ) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state
	
func Physics( _delta: float ) -> State:
	return null
	
func HandleInput(_event: InputEvent) -> State:
	return null
	
func _player_damaged(_hurt_box: HurtBox) -> void:
	hurt_box = _hurt_box
	state_machine.ChangeState(self)
	
func _animation_finished(_a: String) -> void:
	next_state = idle
