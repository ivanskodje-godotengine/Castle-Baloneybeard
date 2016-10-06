extends Control

onready var MAIN_MENU = preload("res://data/main_menu/main_menu.tscn")
onready var WORLD = preload("res://data/world/world.tscn")
onready var ui_node = get_node("ui")

var width = 160
var height = 144

# Everything begins here
func _ready():
	# Resize window bigger
	OS.set_window_size(Vector2(width*3, height*3))
	
	
	# TODO: Display splash screen/cutscene first?
	# ...
	
	# Start by displaying the main menu
	main_menu()


# Creates the main menu
func main_menu():
	# If world exists, remove it
	if(get_node("world")):
		get_node("world").queue_free()
	
	# Create main menu scene
	var scene = MAIN_MENU.instance()
	
	# Connect signal for start
	scene.connect("start", self, "start")
	
	# Add to main menu to scene
	add_child(scene)


# Signal sent by main menu to start the game with selected level
func start(level):
	# Remove main menu
	get_node("main_menu").queue_free()
	
	# Create world node and add to scene
	var world = WORLD.instance()
	add_child(world)
	move_child(world, 0) # Set world behind ui
	
	# Add level to world
	go_to_level(level)


# Go to level
func go_to_level(level):
	get_node("world").load_level(level)