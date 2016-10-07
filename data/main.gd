extends Control

# Load Scenes
var MAIN_MENU = preload("res://data/main_menu/main_menu.tscn")
var LEVEL_MANAGER = preload("res://data/level_manager/level_manager.tscn")

# 0: Ready
func _ready():
	# Load data to set screen size
	var width = global.config["screen_width"]
	var height = global.config["screen_height"]
	var scale = global.config["screen_scale"]

	# Set window size
	OS.set_window_size(Vector2(width*scale, height*scale))
	
	# Enable user input
	set_process_input(true)
	
	# Show splash screen
	splash_screen()


# User Input
func _input(event):
	# Awaiting input from player ('Use' or 'Start' buttons)
	if(event.is_action_pressed("ui_accept") || event.is_action_pressed("ui_start")):
		set_process_input(false) # We are no longer awaiting input from main.gd
		main_menu()


# 1: Splash Screen
func splash_screen():
	# Do stuff
	# ..
	
	print("Press ENTER or USE to continue to main menu.. ") # Debug


# 2: Creates the main menu
func main_menu():
	# Clear nodes
	clear_nodes()
	
	# Instantiate main menu
	var main_menu_scene = MAIN_MENU.instance()
	
	# Connect signal to start the game
	main_menu_scene.connect("start", self, "start")
	
	# Add the main menu to main scene
	add_child(main_menu_scene)


# Start the game
# Run from within Main Menu instance
func start(level):
	# Instantiate level manager
	level_manager()


# Creates a level manager and loads selected level
func level_manager():
	# Clear nodes
	clear_nodes()
	
	# Create world node and add to scene
	var level_manager_scene = LEVEL_MANAGER.instance()
	add_child(level_manager_scene)
	# move_child(level_manager, 0) # Set world behind ui


# Plays credits
func credits():
	# TODO
	pass


func clear_nodes():
	for c in get_children():
		c.queue_free()