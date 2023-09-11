extends Control

var pulling_samples = false
var buffer_data = []
var line_data = PackedVector2Array()
var line_min = -25
var line_max = 25
var scale_min = -200
var scale_max = 200
@export var buffer_size = 1000

var scales = [25, 50, 75, 100, 150, 200, 250, 300, 350, 400, 450, 500, 1000, 1500, 2000, 2500]
var scale_index = 0 # default to 200

# Called when the node enters the scene tree for the first time.
func _ready():
	line_data.resize(buffer_size)
	line_data.fill(Vector2(0.0, 0.0))
	for i in range(buffer_size):
		line_data[i] = Vector2(i, 0.0)
	#update_line(0, 0.0)
	set_volt_scale(scale_index)


func add_data_point(y_value: float):
	# Update specific line index with new data
	line_data.remove_at(0)
	for i in range(buffer_size-1):
		line_data[i] = Vector2(i, line_data[i][1])
	var scaled_point = remap(y_value, scale_min, scale_max, line_min, line_max)
	line_data.push_back(Vector2(buffer_size-1, scaled_point))
	%ch.points = line_data


func update_line(buffer, col):
	# Updates line entirely from a buffer
	var points = PackedVector2Array()
	points.resize(buffer_size)
	for i in len(buffer):
		var point = buffer[i][col]
		point = remap(buffer[i][col], scale_min, scale_max, line_min, line_max)
		#var point = buffer[i][col]
		points.append(Vector2(i, point))
	%ch.points = points


func update_scale():
	# This just updates all existing points so that every update_line doesn't
	for i in range(buffer_size):
		var scaled_point = remap(line_data[i][1], scale_min, scale_max, line_min, line_max)
		line_data[i][1] = scaled_point


func set_volt_scale(scale_index_):
	scale_index = scale_index_
	scale_max = scales[scale_index]
	scale_min = -1 * scale_max
	%scale.text = "±{scale} μV".format({"scale": scale_max})
	update_scale()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_plus_pressed():
	if scale_index < len(scales):
		scale_index += 1
		set_volt_scale(scale_index)


func _on_minus_pressed():
	if scale_index > 0:
		scale_index -= 1
		set_volt_scale(scale_index)
