extends Node2D

func _on_linky_pressed() -> void:
	OS.shell_open("https://hackclub.com/")


func _ready():
	## Retrieve the `window.console` object.
	#var console = JavaScriptBridge.get_interface("console")
	## Call the `window.console.log()` method.
	#console.log("logged a message using Javascript, through GDScript!")
	
	JavaScriptBridge.eval("alert('Calling Javascript per GDScript!');")


func _on_javascript_log_pressed() -> void:
	JavaScriptBridge.eval("window.console.log('calling thru the windowwwwww');")
