extends Control

# Level properties
export(int) var time = 999
export(int) var level = 999

var ui = preload("res://data/ui/ui.tscn")
signal game_over()

func _ready():
	# Create UI
	var ui_scene = ui.instance()
	ui_scene.init(level, time)
	add_child(ui_scene)