class_name Player extends CharacterBody2D

var cardinal_direction: Vector2 = Vector2.DOWN
const DIR_8: Array[ Vector2 ] = [ Vector2.RIGHT, Vector2(1, 1), Vector2.DOWN, Vector2(-1, 1), Vector2.LEFT, Vector2(-1, -1), Vector2.UP, Vector2(1, -1) ]
const OPP_DIR = {
	"idle_right": Vector2.LEFT,
	"idle_down_right": Vector2(-1, -1),
	"idle_down": Vector2.UP,
	"idle_down_left": Vector2(1, -1),
	"idle_left": Vector2.RIGHT,
	"idle_up_left": Vector2(1, 1),
	"idle_up": Vector2.DOWN,
	"idle_up_right": Vector2(-1, 1)
}
var direction : Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var effect_animation_player: AnimationPlayer = $EffectAnimationPlayer
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Node = $StateMachine
@onready var hit_box: HitBox = $HitBox

signal direction_changed(new_direction: Vector2)
signal player_damaged(hurt_box: HurtBox)

var prev_direction: Vector2 = Vector2.ZERO
var is_strafing: bool = false

var invulernable: bool = false
var hp: int = 100
var max_hp: int = 100

func _ready() -> void:
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.damaged.connect(_take_damage)

func _input( event: InputEvent ):
	if event.is_action("strafe"):
		if event.is_pressed():
			is_strafing = true
		elif event.is_released() and not Input.is_action_pressed("flip strafe"):
			is_strafing = false
	
	if event.is_action("flip strafe"):
		if event.is_pressed():
			if direction == Vector2.ZERO:
				direction = OPP_DIR[animation.assigned_animation]
				if set_direction():
					update_animation("idle")
			else:
				direction *= -1
				if set_direction():
					update_animation("walk")
			is_strafing = true
		elif event.is_released() and not Input.is_action_pressed("strafe"):
			is_strafing = false
			
func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	
func _physics_process( _delta: float ) -> void:
	move_and_slide()
	
func set_direction() -> bool:
	if is_strafing:
		return false
	
	var direction_id: int = int(round((direction).angle() / TAU * DIR_8.size()))
	var new_direction = DIR_8[direction_id]
	if new_direction == cardinal_direction:
		return false
		
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	return true
	
func update_animation(state: String) -> void:
	animation.play(state + "_" + anim_direction())
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	elif cardinal_direction == Vector2(1, 1):
		return "down_right"
	elif cardinal_direction == Vector2(-1, 1):
		return "down_left"
	elif cardinal_direction == Vector2(-1, -1):
		return "up_left"
	elif cardinal_direction == Vector2(1, -1):
		return "up_right"
	else:
		return "left"
		
func _take_damage(hurt_box: HurtBox) -> void:
	if invulernable:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(max_hp)

func update_hp(delta: int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	
func make_invulnerable(_duration: float = 1.0) -> void:
	invulernable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	
	invulernable = false
	hit_box.monitoring = true
