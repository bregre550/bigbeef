class_name HitBox extends Area2D

signal damaged(damage: int)

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass
	
func TakeDamage(hurt_box: HurtBox) -> void:
	damaged.emit(hurt_box)
