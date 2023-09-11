extends Node

var loop_pulling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_send_marker_pressed():
	LSL.connect_to_stream("type", "EEG", 8)
	#LSL.connect_to_stream("type", "EEG", 8)
	
	# Assume we're connected, start pulling samples
	#for i in range(10000):
	#	print(LSL.pull_sample())


func _on_button_pressed():
	loop_pulling = !loop_pulling
	while loop_pulling:
		print(LSL.pull_sample())
	#var data = LSL.pull_sample()
	#print(data)
