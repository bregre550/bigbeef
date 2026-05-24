class_name EnemyStateGuard extends EnemyState

@export var anim_name : String = "idle"

@onready var turret: EnemyStateTurret = $"../Turret"
@onready var vision_area: VisionArea = $"../../VisionArea"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var after_idle_state : EnemyState

var can_see_player: bool = false
var shoot_delay: float = 2.0
var is_aggro: bool = false
var aggro_duration: float = 5.0

var _shoot_timer: float = 0.0
var _aggro_timer: float = 0.0
var _direction: Vector2
var turn_rate: float = 0.25

func init() -> void:
	_aggro_timer = aggro_duration
	if vision_area:
		vision_area.player_entered.connect(_on_area_entered)
		vision_area.player_exited.connect(_on_area_exited)
	
func enter() -> void:
	_shoot_timer = shoot_delay
	enemy.update_animation(anim_name)
	
func exit() -> void:
	pass
	
func process(_delta: float) -> EnemyState:
	if is_aggro and not can_see_player:
		_aggro_timer -= _delta
	
	if _aggro_timer <= 0:
		is_aggro = false
		_aggro_timer = aggro_duration
	
	if is_aggro:
		_shoot_timer -= _delta
		var new_dir: Vector2 = enemy.global_position.direction_to(PlayerManager.player.global_position)
		_direction = lerp(_direction, new_dir, turn_rate)
		enemy.direction = _direction
		if enemy.set_direction(_direction):
			enemy.update_animation(anim_name)
	
	if _shoot_timer <= 0:
		return turret
	
	return null

func physics(_delta: float) -> EnemyState:
	return null
	
func _on_area_entered() -> void:
	can_see_player = true
	is_aggro = true
	
func _on_area_exited() -> void:
	can_see_player = false
