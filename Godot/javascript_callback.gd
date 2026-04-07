extends Node

# a lot of this code is copyPasted from Godot's tutorials on how to link
# Javascript with Godot, as a tutorial for myself

# also I figured out I don't have to export the project every time I want to test
# can just use Remote Deploy haha

# Here we create a reference to the `_on_permissions` function (below).
# This reference will be kept until the node is freed.
#var _permission_callback = JavaScriptBridge.create_callback(_on_permissions)

# Here we create a reference to the `_my_callback` function (below).
# This reference will be kept until the node is freed.
var _callback_ref = JavaScriptBridge.create_callback(_my_callback)

const BALL = preload("uid://c8kmdwepw5ts0")
@onready var root_link = $".."

func _ready():
	# NOTE: This is done in `_ready` for simplicity, but SHOULD BE done in response
	# to user input instead (e.g. during `_input`, or `button_pressed` event, etc.),
	# otherwise it might not work.

	var thing = JavaScriptBridge.get_interface("console")
	thing.log(" hammertime time")
	print(" calling a normal Godot Print statement here")
	
	# Get the JavaScript `window` object.
	#var window = JavaScriptBridge.get_interface("window")
	## Set the `window.onbeforeunload` DOM event listener.
	##window.onbeforeunload = _callback_ref
	#window.resizeWebpage = _callback_ref
	var java_window = JavaScriptBridge.get_interface("window")
	java_window.onbeforeunload = _callback_ref
	
	#var java_notification = JavaScriptBridge.get_interface("Notification")
	# Call the `window.Notification.requestPermission` method which returns a JavaScript
	# Promise, and bind our callback to it.
	#java_notification.requestPermission().then(_permission_callback)
	#
	#print('read the code for java_notification')
#
#func _on_permissions(args):
	## The first argument of this callback is the string "granted" if the permission is granted.
	#var permission = args[0]
	#if permission == "granted":
		#print("Permission granted, sending notification.")
		## Create the notification: `new Notification("Hi there!")`
		#JavaScriptBridge.create_object("Notification", "Hi there!")
	#else:
		#print("No notification permission.")

func _my_callback(args):
	# this is called every single time you try to close out the page, when the dialogue to leave appears
	# regardless or not of if you actually leave, this is called.
	
	print('doing my callback')
	
	# Get the first argument (the DOM event in our case).
	var js_event = args[0]
	# Call preventDefault and set the `returnValue` property of the DOM event.
	js_event.preventDefault()
	js_event.returnValue = ''
	
	var child = BALL.instantiate()
	child.position = Vector2(0, -200)
	root_link.add_child(child)
