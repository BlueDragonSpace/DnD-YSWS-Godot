extends Control

@onready var noise: TextureRect = $Noise

# the main container is a Control Node, but I sort it using a VBoxContainer, then switch it to a Node
@onready var main_container: Control = $Margins/MainContainer
@onready var last_margin: HSeparator = $Margins/MainContainer/LastMargin
@onready var sub_viewport: SubViewport = $FallingDice/SubViewport

@export var scroll_speed = 5
@export var skew : float = 1.3
@export var noise_speed = 2
var scroll_limit : float # gets determined in ready (or redetermined on window change)

# also haha the margins on left and right are useless they just end up going to the right

func _ready() -> void:
	main_container.position.y = 0
	@warning_ignore("narrowing_conversion")
	sub_viewport.size.x = main_container.size.x
	
	for child in main_container.get_children():
		
		# centers position to center of screen on y-axis, when in the middle of the x-axis of screen
		#child.position.y += size.y / 2 + child.size.y / 2
		
		# skews on x axis based on y position
		child.position.x = child.position.y * skew
	
	scroll_limit = last_margin.position.y - size.y

func _input(_event: InputEvent) -> void:
	
	# at this point may as well make it a match statement haha
	if Input.is_action_pressed("scroll_down"):
		shift_main_container(-scroll_speed)
	elif Input.is_action_pressed("scroll_up"):
		shift_main_container(scroll_speed)
	elif Input.is_action_pressed("powerscroll_down"):
		shift_main_container(-scroll_speed * 5)
	elif Input.is_action_pressed("powerscroll_up"):
		shift_main_container(scroll_speed * 5)
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _process(delta: float) -> void:
	noise.texture.noise.offset.x += delta * noise_speed
	noise.texture.noise.offset.y += delta * noise_speed
	noise.texture.noise.offset.z += delta * noise_speed * 3

func _on_main_container_resized() -> void:
	@warning_ignore("narrowing_conversion")
	if is_node_ready():
		call_deferred("resize_website", main_container.size.x)

func shift_main_container(add_y: float) -> void:
	main_container.position.y = clamp(main_container.position.y + add_y, -(scroll_limit), 0)
	main_container.position.x = main_container.position.y * skew

func resize_website(new_size: int) -> void:
	@warning_ignore("narrowing_conversion")
	sub_viewport.size.x = new_size * skew
