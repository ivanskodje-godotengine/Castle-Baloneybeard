extends Control

# Instance for creating an menu item
var menu_item = preload("res://data/main_menu/menu_item.tscn")

# Menu Items
var menu_items = ["Start", "Level", "Music"] # Start game, Level selection, Music volume

# Keeps track of current selected item
var selected_item = null 


func _ready():
	# Enable input
	set_process_input(true)
	
	# Create and add menu items to the menu
	for i in menu_items:
		var item = menu_item.instance()
		item.get_node("menu_item").set_text(i)
		get_node("container/vbox_container").add_child(item)
	
	# If we have at least one item, set selected item to 0
	if(menu_items.size() > 1):
		selected_item = 0
		change_selection(selected_item)
	else:
		get_tree().quit() # Abandon ship! Launch the escape pods! Fire the chef!
	pass


func _input(event):
	# Pressed UI_UP
	if(event.is_action_pressed("ui_up")):
		selected_item -= 1
		if(selected_item < 0):
			selected_item = menu_items.size()-1
		change_selection(selected_item)
	# Pressed UI_DOWN
	elif(event.is_action_pressed("ui_down")):
		selected_item += 1
		if(selected_item > menu_items.size()-1):
			selected_item = 0
		change_selection(selected_item)
	# Pressed UI_ACCEPT
	elif(event.is_action_pressed("ui_accept")):
		# Get text name
		var selected = menu_items[selected_item]
		
		# Selection
		if(selected == "Start"):
			print("TODO: Start")
			# Play sound effect for selected
		elif(selected == "Level"):
			print("TODO: Level selection (after unlocking)")
			# Play sound effect for selected
		elif(selected == "Music"):
			print("TODO: Music")
			# Play sound effect for selected


func change_selection(id):
	var count = 0
	for c in get_node("container/vbox_container").get_children():
		if(count == id):
			# Set name and color for active selection
			c.get_node("menu_item").set_text("* " + menu_items[count] + " *")
			c.get_node("menu_item").add_color_override("font_color", Color(global.get_color(2)))
		else:
			# Set name and color for inactive selection
			c.get_node("menu_item").set_text(menu_items[count])
			c.get_node("menu_item").add_color_override("font_color", Color(global.get_color(0)))
		count += 1
	# Play sound effect for changing selection
	# ...
