extends Node2D


# Called when the node enters the scene tree for the first time.
var test
func _ready():
	var script := load("res://Scenes/CSharp_Test.cs")
	test = script.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func return_float():
	test.return_float()


func _on_button_pressed():
	print(test.return_float())
