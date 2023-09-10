extends Node

var lsl

func _ready():
	var script := load("res://Globals/LSL_Inlet.cs")
	lsl = script.new()


func connect_to_stream(prop: String, value: String, num_channels: int):
	# Connect to LSL inlet after resolving.
	# Once this is ready, it will return true and variables
	# are stored within the C# class
	lsl.connect_to_stream(prop, value, num_channels)


func pull_sample():
	# This will call the overloaded function in C# which utilizes stored
	# variables within the C# class since GDScript has no access.
	# This will return an array of floats of size `num_channels` defined
	# in `connect_to_stream()`.
	return lsl.pull_sample()

