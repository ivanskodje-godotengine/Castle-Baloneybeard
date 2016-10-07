extends CanvasLayer

# Time and Level
var time
var level

# Timer
var timer = null

# Time Label
onready var time_label = get_node("color_frame/hbox_time/label_time_value")
onready var level_label = get_node("color_frame/hbox_level/label_level_value")
onready var intro_label = get_node("intro/label")

# Overlays
onready var intro_node = get_node("intro")
onready var pause_node = get_node("pause")
onready var time_out_node = get_node("time_out")
onready var game_over_node = get_node("game_over")


# Data from level.gd
func init(new_level, new_time):
	level = new_level
	time = new_time


func _ready():
	# Make sure to have updated the labels to display correct time and level
	time_label.set_text(str(time).pad_zeros(3))
	level_label.set_text(str(level).pad_zeros(3))
	intro_label.set_text("Level: " + str(level).pad_zeros(2))
	
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
		emit_signal("game_over")
	
	# Update label
	time_label.set_text(str(time).pad_zeros(3))


# Updates the keys based on a keys dictionary
func update_keys(dict):
	if(dict["SPADE"] > 0):
		get_node("color_frame/hbox_keys/Container1/key_2").show()
	else:
		get_node("color_frame/hbox_keys/Container1/key_2").hide()
	
	if(dict["DIAMOND"] > 0):
		get_node("color_frame/hbox_keys/Container/key_1").show()
	else:
		get_node("color_frame/hbox_keys/Container/key_1").hide()
	
	if(dict["CLUB"] > 0):
		get_node("color_frame/hbox_keys/Container2/key_3").show()
	else:
		get_node("color_frame/hbox_keys/Container2/key_3").hide()
	
	if(dict["HEART"] > 0):
		get_node("color_frame/hbox_keys/Container3/key_4").show()
	else:
		get_node("color_frame/hbox_keys/Container3/key_4").hide()

# Updates baloney counter (There are x baloneys remaining)
func update_baloney(num):
	get_node("color_frame/hbox_baloney/label_baloney_value").set_text(str(num))

func set_time(t):
	time = t
	
	if(get_node("color_frame/hbox_time/label_time_value") != null): # Due to tool being a bit weird; we have to use get_node in order to see "time" changes in the editor
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
		get_node("color_frame").hide()
		pause_node.hide()
		time_out_node.hide()
		game_over_node.hide()
	else:
		intro_node.hide()
		get_node("color_frame").show()


func set_pause(boolean):
	if(boolean):
		pause_node.show()
		get_node("color_frame").hide()
		intro_node.hide()
		time_out_node.hide()
		game_over_node.hide()
	else:
		pause_node.hide()
		get_node("color_frame").show()


func set_time_out(boolean):
	if(boolean):
		time_out_node.show()
		get_node("color_frame").hide()
		pause_node.hide()
		intro_node.hide()
		game_over_node.hide()
	else:
		time_out_node.hide()
		get_node("color_frame").show()

func set_you_died(boolean):
	if(boolean):
		game_over_node.show()
		get_node("color_frame").hide()
		time_out_node.hide()
		pause_node.hide()
		intro_node.hide()
	else:
		game_over_node.hide()
		get_node("color_frame").show()
	