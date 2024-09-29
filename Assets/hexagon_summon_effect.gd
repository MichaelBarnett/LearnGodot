extends Node2D

func _ready() -> void:
	$PurpleRain.emitting = true
	$Vortex.emitting = true



func _on_vortex_finished() -> void:
	queue_free()
