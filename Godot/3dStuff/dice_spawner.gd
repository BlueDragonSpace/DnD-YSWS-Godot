extends Node3D

@export var dice : PackedScene = null
@export var rand_pos = Vector3(5, 0, 5) # random position
@export var timer_time = 0.7 ## time till next die spawn

var current_dice = 0

# spawns at same position on y-axis, 
# spawns at some random position on x and z-axis

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = timer_time

func _on_timer_timeout() -> void:
	var child = dice.instantiate()
	child.position = Vector3(randf_range(-rand_pos.x, rand_pos.x), 0, randf_range(-rand_pos.z, rand_pos.z))
	child.rotation = Vector3(randf_range(-PI, PI), randf_range(-PI, PI), randf_range(-PI, PI))
	add_child(child)
	
	current_dice += 1
	if current_dice >= 10:
		timer.autostart = false
		timer.wait_time = 5000 # this will probably never make it trigger again
