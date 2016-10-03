tool
extends CanvasLayer

# Time limit for the map
export(int) var time = 999 setget set_time
export(int) var level = 999 setget set_level
# var level = null

# Timer
var timer = null

# Time Label
onready var time_label = get_node("color_frame/hbox_time/label_time_value")
onready var level_label = get_node("color_frame/hbox_level/label_level_value")
onready var intro_label = get_node("intro/label")

# Intro Overlay (Level name and possibly extra information later)
onready var intro_node = get_node("intro")

# Pause node
onready var pause_node = get_node("pause")

# Time out Overlay
onready var time_out_node = get_node("time_out")

# Signal for game over
signal game_over()


func _ready():
	# Make sure to have updated the labels to display correct time and level
	time_label.set_text(str(time).pad_zeros(3))
	level_label.set_text(str(level).pad_zeros(3))
	
	# Create timer and start it
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "_countdown")
	add_child(timer)

func start_countdown():
	timer.start()

func _countdown():
	time -= 1 # decrease by one
	# If time is up
	if(time < 0):
		time = 0 # Time to 0
		timer.stop()
		time_out_node.show()
		print("Emit signal from UI: Game Over")
		emit_signal("game_over")
		# Game over
	time_label.set_text(str(time).pad_zeros(3))

# Given an number and boolean, enables/disables key (UI)
func set_key(num, boolean):
	# If number is 1, 2, 3 or 4
	if(num > 0 && num < 5):
		var key = get_node("color_frame/hbox_keys/Container/key_" + str(num))
		if(boolean):
			key.show()
		else:
			key.hide()

func set_time(t):
	time = t
	
	# Due to tool being a bit weird; we have to use get_node in order to see "time" changes in the editor
	if(get_node("color_frame/hbox_time/label_time_value") != null):
		get_node("color_frame/hbox_time/label_time_value").set_text(str(time).pad_zeros(3))

func set_level(l):
	level = l
	
	if(get_node("intro/label") != null):
		get_node("intro/label").set_text("Level: " + str(level).pad_zeros(3))
	
	if(get_node("color_frame/hbox_level/label_level_value") != null):
		get_node("color_frame/hbox_level/label_level_value").set_text(str(level).pad_zeros(3))

func set_intro(boolean):
	if(boolean):
		intro_node.show()
	else:
		intro_node.hide()

func set_pause(boolean):
	if(boolean):
		pause_node.show()
	else:
		pause_node.hide()

func set_time_out(boolean):
	if(boolean):
		time_out_node.show()
	else:
		time_out_node.hide()
	