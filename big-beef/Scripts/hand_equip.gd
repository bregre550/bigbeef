class_name HandEquip extends Node

@onready var sprite: Sprite2D = $Sprite2D
@onready var attack_animation: AnimationPlayer = $AttackAnimation
@onready var hurt_box: HurtBox = $HurtBox

func _ready() -> void:
	#hurt_box.monitoring = false
	#sprite.visible = false
	pass
	
func attack() -> void:
	pass
