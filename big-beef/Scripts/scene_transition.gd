extends CanvasLayer

@onready var animation: AnimationPlayer = $Control/AnimationPlayer

func fade_out() -> bool:
	animation.play("fade_out")
	await animation.animation.finished
	return true
	
func fade_in() -> bool:
	animation.play("fade_in")
	await animation.animation.finished
	return true
