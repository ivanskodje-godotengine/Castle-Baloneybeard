tool
extends HBoxContainer


export(int, "Color Darkest", "Color Dark", "Color Bright", "Color Brightest") var color = 0 setget update_color
export (String) var text = "Item" setget set_text
const colors = ["#232a0f", "#556625", "#8faa3f", "#b4ca73"] # This would not load through global when using tool features

func _enter_tree():
	pass

func set_text(new_text):
	if(get_node("menu_item") != null):
		get_node("menu_item").set_text(new_text)
		text = new_text

func get_text():
	return text

func update_color(id):
	if(id != null && get_node("menu_item") != null):
		color = id
		get_node("menu_item").add_color_override("font_color", Color(colors[id]))