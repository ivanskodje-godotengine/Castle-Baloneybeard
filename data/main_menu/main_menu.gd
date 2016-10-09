extends Control

# Load all menu item scenes
onready var items = get_node("container/vbox_container").get_children()

# Storing item names for selection handling
var item_names = []

# Currently selected menu item
var selected_item = 0 

# Signals for game.gd
signal start()

# Ready
func _ready():
	# Enable input
	set_process_input(true)
	
	# Get item names
	for i in items:
		item_names.append(i.get_text())
	
	# Set initial selection
	change_selection()
	
	# Play menu music
	wait_then_music(0.5)

var delay_timer = null
func wait_then_music(wait):
	# Stop existing music (if any)
	global.stop_music()
	
	# Create timer
	delay_timer = Timer.new()
	delay_timer.set_one_shot(true)
	delay_timer.set_wait_time(wait)
	delay_timer.connect("timeout", self, "_play_music")
	delay_timer.set_name("delay_timer")
	get_parent().add_child(delay_timer)
	delay_timer.start()

func _play_music():
	global.play_music(0)
	delay_timer.queue_free()

# Input events
func _input(event):
	# Pressed UP
	if(event.is_action_pressed("ui_up")):
		selected_item -= 1
		if(selected_item < 0):
			selected_item = items.size()-1
		change_selection(selected_item)
	
	# Pressed DOWN
	elif(event.is_action_pressed("ui_down")):
		selected_item += 1
		if(selected_item > items.size()-1):
			selected_item = 0
		change_selection(selected_item)
	
	# Pressed LEFT
	elif(event.is_action_pressed("ui_left")):
		# Level
		if(selected_item == 1):
			decrease_level()
		# Music
		elif(selected_item == 2):
			decrease_music()
	
	# Pressed RIGHT
	elif(event.is_action_pressed("ui_right")):
		# Level
		if(selected_item == 1): 
			increase_level()
		# Music
		elif(selected_item == 2):
			increase_music()
	
	# Pressed UI_ACCEPT
	elif(event.is_action_pressed("ui_accept")):
		# Start
		if(selected_item == 0):
			emit_signal("start", global.config["level"]["current"])
			global.play_sound(global.SOUND.ITEM_SELECTED)
		
		# Level
		elif(selected_item == 1): 
			increase_level()
		
		# Music
		elif(selected_item == 2):
			increase_music()


# Increase level by 1
func increase_level():
	global.config["level"]["current"] += 1
	if(global.config["level"]["current"] > global.config["level"]["total"]):
		global.config["level"]["current"] = global.config["level"]["total"]
	else:
		global.play_sound(global.SOUND.ITEM_CHANGED)
	items[1].set_text("*Level: " + str(global.config["level"]["current"]).pad_zeros(2) + "*")


# Decrease level by 1
func decrease_level():
	global.config["level"]["current"] -= 1
	if(global.config["level"]["current"] < 1):
		global.config["level"]["current"] = 1
	else:
		global.play_sound(global.SOUND.ITEM_CHANGED)
	items[1].set_text("*Level: " + str(global.config["level"]["current"]).pad_zeros(2) + "*")


# Increase music volume by 10
func increase_music():
	global.config["music"]["current"] += 10 # Increment
	
	if(global.config["music"]["current"] > global.config["music"]["total"]):
		global.config["music"]["current"] = global.config["music"]["total"] # prevent going above max
	else:
		global.play_sound(global.SOUND.ITEM_CHANGED)
	items[2].set_text("*Music: " + str(global.config["music"]["current"]).pad_zeros(2) + "*")
	
	global.update_music_volume()


# Decrease music volume by 10
func decrease_music():
	global.config["music"]["current"] -= 10
	
	if(global.config["music"]["current"] < 0):
		global.config["music"]["current"] = 0 # prevent going below 0
	else:
		global.play_sound(global.SOUND.ITEM_CHANGED)
	items[2].set_text("*Music: " + str(global.config["music"]["current"]).pad_zeros(2) + "*")
	
	global.update_music_volume()

# Change menu item selection
func change_selection(id = null):
	# This part allows us to run it once to initially set selection to 0 during first load of main menu,
	# without playing sound 
	if(id == null):
		id = 0
	else:
		# Play sound effect for changing selection
		global.play_sound(global.SOUND.ITEM_CHANGED)
	
	# Interate through all items and set text accordingly
	var count = 0
	for c in items:
		var extra = ""
		
		# Level
		if(count == 1):
			extra = str(global.config.level.current).pad_zeros(2)
			
		# Music
		elif(count == 2):
			extra = str(global.config.music.current).pad_zeros(2)
		
		# If the iterating c is equal to selected id
		if(count == id):
			# Set name and color for selection
			c.set_text("*" + item_names[count] + extra + "*")
			c.set_color(3)
		else:
			# Set name and color for everything other than selection
			c.set_text(item_names[count] + extra)
			c.set_color(2)
		count += 1

