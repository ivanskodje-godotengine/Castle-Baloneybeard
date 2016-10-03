
extends Node2D

var Y = 0

var MAX = 5	#Number of Boloney slices to spawn

var BREAD = preload('res://data/YeOldeTitle/Bread.tscn')
var BOLOGNE = preload('res://data/YeOldeTitle/Bologne.tscn')



func add_to_sandwich():
	var N = BOLOGNE.instance()
	if Y == 0 or Y == MAX+1:
		N = BREAD.instance()
	add_child(N)
	N.set_pos(Vector2(80,120-(Y*4)))
	Y += 1

func _on_Timer_timeout():
	if Y >= MAX+2:	get_node('Timer').stop()
	else:
		add_to_sandwich()
		#get_node('Timer').start()
