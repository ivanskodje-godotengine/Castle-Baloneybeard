extends Control

# Keeps track of current selected item
var selected_item = 0 
onready var items = get_node("container/vbox_container").get_children()
var item_names = []
var current_level = 1
var max_level = 1 # TODO: Load number of levels and insert into this var
var current_music = 100
var max_music = 100

# Signals for game.gd
signal start()


func _ready():
	# Enable input
	set_process_input(true)
	
	# Get item names
	for i in items:
		item_names.append(i.get_text())
		pass
	
	change_selection(0)


func _input(event):
	# Pressed UI_UP
	if(event.is_action_pressed("ui_up")):
		selected_item -= 1
		if(selected_item < 0):
			selected_item = items.size()-1
		change_selection(selected_item)
	
	# Pressed UI_DOWN
	elif(event.is_action_pressed("ui_down")):
		selected_item += 1
		if(selected_item > items.size()-1):
			selected_item = 0
		change_selection(selected_item)
	
	elif(event.is_action_pressed("ui_left")):
		if(selected_item == 1):
			decrease_level()
		elif(selected_item == 2):
			decrease_music()
	
	elif(event.is_action_pressed("ui_right")):
		if(selected_item == 1):
			increase_level()
		elif(selected_item == 2):
			increase_music()
	
	# Pressed UI_ACCEPT
	elif(event.is_action_pressed("ui_accept")):
		if(selected_item == 0): # Start
			emit_signal("start", current_level)
			# Play sound effect for selected
		elif(selected_item == 1): # Level
			increase_level()
			# Play sound effect for selected
		elif(selected_item == 2): # Music
			increase_music()
			# Play sound effect for selected

func increase_level():
	current_level += 1
	if(current_level > max_level):
		current_level = 1
	items[1].set_text("*Level: " + str(current_level).pad_zeros(2) + "*")

func decrease_level():
	current_level -= 1
	if(current_level < 1):
		current_level = max_level
	items[1].set_text("*Level: " + str(current_level).pad_zeros(2) + "*")

func increase_music():
	current_music += 10
	if(current_music > max_music):
		current_music = max_music # prevent going above max
	items[2].set_text("*Music: " + str(current_music).pad_zeros(2) + "*")

func decrease_music():
	current_music -= 10
	if(current_music < 0):
		current_music = 0 # prevent going below 0
	items[2].set_text("*Music: " + str(current_music).pad_zeros(2) + "*")

func change_selection(id):
	var count = 0
	for c in items:
		var extra = ""
		if(count == 1):
			extra = str(current_level).pad_zeros(2)
		elif(count == 2):
			extra = str(current_music).pad_zeros(2)
		
		if(count == id):
			# Set name and color for active selection
			c.set_text("*" + item_names[count] + extra + "*")
			c.set_color(3)
		else:
			# Set name and color for inactive selection
			c.set_text(item_names[count] + extra)
			c.set_color(1)
		count += 1
	# Play sound effect for changing selection
	# ...
