extends Node2D

var baloney_sprite = preload("res://data/goal/baloney/baloney.tscn")
var bread_sprite = preload("res://data/goal/bread/bread.tscn")

# Add baloney on top
func add_baloney():
	var baloney = baloney_sprite.instance()
	baloney.set_pos(new_pos())
	add_child(baloney)

# Add final bread piece
func finish():
	var bread = bread_sprite.instance()
	bread.set_pos(new_pos())
	add_child(bread)

# Returns new position to make the last baloney/bread look stacked
func new_pos():
	var children_size = get_children().size()
	var last_child_pos = get_child(children_size-1).get_pos()
	var rnd_x = rand_range(-2,2)
	return Vector2(last_child_pos.x + rnd_x, last_child_pos.y - 2)

# Triggers when the player walks on the bread
func _on_Area2D_body_enter(body):
	if(body.get_name() == "player"):
		body.walked_on_goal()
		pass
