extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 3.0



func _on_restart_timer_timeout() -> void:
	# resets the simulation every about 20 seconds
	get_tree().reload_current_scene()
