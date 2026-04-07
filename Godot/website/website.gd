extends Control

@onready var noise: TextureRect = $Noise

# the main container is a Control Node, but I sort it using a VBoxContainer, then switch it to a Node
@onready var main_container: Control = $MainContainer
@onready var sub_viewport: SubViewport = $FallingDice/SubViewport


@export var scroll_speed = 5
@export var skew : float = 1.3
@export var noise_speed = 2


func _ready() -> void:
	main_container.position.y = 0
	@warning_ignore("narrowing_conversion")
	sub_viewport.size.x = main_container.size.x
	
	for child in main_container.get_children():
		# skews on x axis based on y position
		child.position.x = child.position.y * skew

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("scroll_down"):
		main_container.position.y = clamp(main_container.position.y - scroll_speed, -(main_container.size.y - size.y) * skew, 0)
		main_container.position.x = main_container.position.y * skew
	elif Input.is_action_pressed("scroll_up"):
		main_container.position.y = clamp(main_container.position.y + scroll_speed, -(main_container.size.y - size.y) * skew, 0)
		main_container.position.x = main_container.position.y * skew

func _process(delta: float) -> void:
	noise.texture.noise.offset.x += delta * noise_speed
	noise.texture.noise.offset.y += delta * noise_speed
	noise.texture.noise.offset.z += delta * noise_speed * 3

func _on_main_container_resized() -> void:
	@warning_ignore("narrowing_conversion")
	if is_node_ready():
		call_deferred("resize_website", main_container.size.x)

func resize_website(new_size: int) -> void:
	@warning_ignore("narrowing_conversion")
	sub_viewport.size.x = new_size * skew
