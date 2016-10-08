
extends Node2D

var Y = 0

#Number of Boloney slices to spawn
var MAX = 5


var BREAD = preload('res://data/title/bread.tscn')
var BOLOGNE = preload('res://data/title/bologne.tscn')



func add_to_sandwich():
	var N = BOLOGNE.instance()
	if Y == 0 or Y == MAX+1:
		N = BREAD.instance()
	add_child(N)
	N.set_pos(Vector2(80,120-(Y*4)))
	Y += 1

# Runs each tick
func _on_Timer_timeout():
	if Y >= MAX + 2:
		get_node('Timer').stop()
	else:
		add_to_sandwich()
		#get_node('Timer').start()
