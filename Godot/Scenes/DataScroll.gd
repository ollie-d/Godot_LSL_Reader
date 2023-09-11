extends Node

var pulling_samples = false
var buffer_data = []
var line_data = PackedVector2Array()
@export var num_channels = 8
@export var buffer_size = 1000

var mutex: Mutex
var lsl_pull_thread: Thread
var kill_thread = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize thread but don't start
	lsl_pull_thread = Thread.new()
	mutex = Mutex.new()
	
	# Initialize buffer array that the thread will use
	var temp_array = []
	for i in range(num_channels):
		temp_array.append(0.0)
	for i in range(buffer_size):
		buffer_data.append(temp_array)


func _pull_thread():
	print("Thread Running")
	while not kill_thread:
		#var data = 0.01
		#print(data)
		var data = LSL.pull_sample()
		#print(data)
		if len(data) > 0:
			mutex.lock()
			buffer_data.pop_front()
			buffer_data.push_back(data)
			mutex.unlock()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$FPS.text = str(Engine.get_frames_per_second())
	if pulling_samples:
		mutex.lock()
		#%ch1.add_data_point(buffer_data[buffer_size-1][0])
		%ch1.update_line(buffer_data, 0)
		%ch2.update_line(buffer_data, 1)
		%ch3.update_line(buffer_data, 2)
		%ch4.update_line(buffer_data, 3)
		%ch5.update_line(buffer_data, 4)
		%ch6.update_line(buffer_data, 5)
		%ch7.update_line(buffer_data, 6)
		%ch8.update_line(buffer_data, 7)
		mutex.unlock()


func _on_button_pressed():
	kill_thread = !kill_thread
	if !lsl_pull_thread.is_started():
		lsl_pull_thread.start(_pull_thread, Thread.PRIORITY_HIGH)
	else:
		lsl_pull_thread.wait_to_finish()
	pulling_samples = !pulling_samples
	if pulling_samples:
		%pull_samples.text = "Stop"
	else:
		%pull_samples.text = "Pull Samples"
		#%connect.disabled = false


func _exit_tree():
	lsl_pull_thread.wait_to_finish()


func _on_color_picker_button_color_changed(color):
	%BG.color = %picker.color


func _on_connect_pressed():
	# Only connect if name is valid
	if len(%stream_name.text) > 0:
		LSL.connect_to_stream("name", %stream_name.text, num_channels)
		%connect.disabled = true
	else:
		print("Give me name plox")
	
