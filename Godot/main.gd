extends Node2D

func _on_linky_pressed() -> void:
	OS.shell_open("https://hackclub.com/")


func _ready():
	# Retrieve the `window.console` object.
	var console = JavaScriptBridge.get_interface("console")
	# Call the `window.console.log()` method.
	console.log("logged a message using Javascript, through GDScript!")
