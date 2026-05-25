extends Node

signal bullet_deflected

func deflect_bullet() -> void:
	bullet_deflected.emit()
