extends Control

@onready var noise: TextureRect = $Noise

# the main container is a Control Node, but I sort it using a VBoxContainer, then switch it to a Node
@onready var main_container: Control = $Margins/MainContainer
@onready var last_margin: HSeparator = $Margins/MainContainer/LastMargin
@onready var sub_viewport: SubViewport = $FallingDice/SubViewport
@onready var email_input: LineEdit = $Margins/MainContainer/VBoxContainer3/HBoxContainer/EmailInput
@onready var text_above_email_input: Label = $Margins/MainContainer/VBoxContainer3/TextAboveEmailInput
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var scroll_speed = 5
@export var skew : float = 1.3
@export var noise_speed = 2
var scroll_limit : float # gets determined in ready (or redetermined on window change)


# now this, is PII (if only it could be PI: 3.141592653589793238462643383279502883...)
var user_email : String
const recieving_email : String = 'bluedragon_space@outlook.com' # yes this is my email, have at it

var checking_otp := false

const save_path = "user://SaveFile.json"

# also haha the margins on left and right are useless they just end up going to the right

func _ready() -> void:
	load_data()
	
	main_container.position.y = 0
	@warning_ignore("narrowing_conversion")
	sub_viewport.size.x = main_container.size.x
	
	for child in main_container.get_children():
		
		# centers position to center of screen on y-axis, when in the middle of the x-axis of screen
		#child.position.y += size.y / 2 + child.size.y / 2
		
		# skews on x axis based on y position
		child.position.x = child.position.y * skew
	
	scroll_limit = last_margin.position.y - size.y
	
	if main_container is VBoxContainer:
		push_error("MainContainer should be a Control node!")
		print_rich("[color=red]MainContainer should be a Control node!!!!")

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

# custom Functions

func shift_main_container(add_y: float) -> void:
	main_container.position.y = clamp(main_container.position.y + add_y, -(scroll_limit), 0)
	main_container.position.x = main_container.position.y * skew

func resize_website(new_size: int) -> void:
	@warning_ignore("narrowing_conversion")
	sub_viewport.size.x = new_size * skew

func log_in() -> void:
	animation_player.play("log_in_fade_in")
	# create animation and link it here

func is_email_valid(email: String) -> bool:
	
	if email and true:
		user_email = email
		return true 
	else:
		return false

func is_otp_valid(otp: String) -> bool:
	
	if otp and true:
		return true
	else:
		return false

func save_data():
	var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.WRITE,"0192KAES")
	
	var data = [user_email]
	
	file.store_var(data)
	file.close()
	print("Data Saved!")

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open_encrypted_with_pass(save_path, FileAccess.READ,"0192KAES")
		var data = file.get_var()
		print('Located Save Data!')
		print(data)
		file.close()
		
		text_above_email_input.text = "You're already signed in! :D"
		email_input.text = data[0]
		
	else:
		print("No Save Data Found!")

func delete_data():
	print("delete pressed")
	var dir = DirAccess.open("user://")
	if dir:
		var delete = dir.remove("user://SaveFile.json")
		if delete == OK:
			print("File deleted successfully")
		else:
			print("Error deleting file")

func send_otp(email: String):
	# I have no idea how to send an email through Godot
	pass

## Signal Functions

func _on_main_container_resized() -> void:
	@warning_ignore("narrowing_conversion")
	if is_node_ready():
		call_deferred("resize_website", main_container.size.x)

func _on_clear_memory_pressed() -> void:
	delete_data()


func _on_email_input_text_submitted(new_text: String) -> void:
	
	if is_email_valid(new_text) and not checking_otp:
		checking_otp = true
		send_otp(new_text)
		user_email = new_text
	elif is_otp_valid(new_text) and checking_otp:
		save_data() # saves the email for next time
		log_in()
	else:
		text_above_email_input.text = "That wasn't valid, try again? If you have issues email bluedragon_space@outlook.com"


func _on_back_log_in_pressed() -> void:
	animation_player.play_backwards("log_in_fade_in")
