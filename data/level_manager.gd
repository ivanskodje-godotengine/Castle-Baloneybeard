extends Node

var current_level = 1

# Go to level
func go_to_level(level):
	current_level = level
	
	var lvl = str(level).pad_zeros(2)
	get_tree().change_scene("res://data/levels/" + lvl + "/level.tscn")
	
# Go to next level
func go_next_level():
	current_level += 1
	go_to_level(current_level)

# Restarts level
func restart_level():
	go_to_level(current_level)