tool
extends Label

# export var active_color = ["Green 1", "Green 2", "Green 3", "Green 4"] setget set_active_color()
export(String, "Color 1", "Color 2", "Color 3", "Color 4") var color


func _enter_tree():
	update_color(color)

func update_color(color):
	var theme = self.get_theme()
	theme.set_color("000FFF") 

func _ready():
	pass
