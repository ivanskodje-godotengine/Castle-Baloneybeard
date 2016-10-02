extends Control

onready var MAIN_MENU = preload("res://data/main_menu/main_menu.tscn")
onready var WORLD = preload("res://data/world/world.tscn")
onready var ui_node = get_node("ui")


func _ready():
	main_menu()

func main_menu():
	# Create main menu scene
	var scene = MAIN_MENU.instance()
	
	# Connect signal for start
	scene.connect("start", self, "start")
	
	# Add to main menu to scene
	add_child(scene)

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