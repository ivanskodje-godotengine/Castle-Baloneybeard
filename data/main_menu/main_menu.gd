extends Control

onready var START_MENU = preload("res://data/main_menu/instances/start_menu/start_menu.tscn")
var menu_queue = []

func _ready():
	add_menu(START_MENU)
	pass


# START MENU
func start():
	print("Start level")
	pass


# Adds a menu to queue (allowing us to add menus on top of menus, be it overlays or whatnot)
func add_menu(menu_scene):
	var menu = menu_scene.instance()
	if(menu_scene == START_MENU):
		menu.connect("start", self, "start")
		menu.connect("level", self, "level")
		menu.connect("music", self, "music")
	menu_queue.push_front(menu)
	add_child(menu_queue[0])


# Removes current menu
func remove_menu():
	menu_queue[0].queue_free() # clear reference to current menu
	menu_queue.pop_front() # remove top menu


# Changes current menu to new_menu
func change_menu_to(new_menu):
	remove_menu()
	add_menu(new_menu)