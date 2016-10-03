extends KinematicBody2D

# Movement
var tween = null # Moves the player from current to next tile smoothly
var is_moving = false # Prevents moving outside of tile positions
var tile_size = 16
var speed = 0.25 # Movement speed

func _ready():
	# get_parent().get_node("extra")
	set_process_input(true)
	set_fixed_process(true)
	pass

# Note: Can only run after you have been set as child
func spawn_at(vec2):
	var tilemap_extra = get_parent().get_node("extra")
	if(tilemap_extra != null):
		var world_pos = tilemap_extra.map_to_world(vec2)
		set_pos(world_pos)
	
	# Set UI as child of player (to make it follow when you move)
	# var ui = get_parent().get_node("ui")
	# get_parent().remove_child(ui)
	# add_child(ui)
	


# Using fixed process so player can hold down buttons for movement
func _fixed_process(delta):
	if(!is_moving):
		if(Input.is_action_pressed("ui_left")):
			move_left()
		elif(Input.is_action_pressed("ui_right")):
			move_right()
		elif(Input.is_action_pressed("ui_up")):
			move_up()
		elif(Input.is_action_pressed("ui_down")):
			move_down()
	

func move_left():
	var pos = get_pos()
	pos.x -= tile_size
	
	# Check if we can move
	# ..

	# Move
	move(pos)

func move_right():
	var pos = get_pos()
	pos.x += tile_size
	
	# Check if we can move
	# ..

	# Move
	move(pos)

func move_up():
	var pos = get_pos()
	pos.y -= tile_size
	
	# Check if we can move
	# ..

	# Move
	move(pos)

func move_down():
	var pos = get_pos()
	pos.y += tile_size
	
	# Check if we can move
	# ..

	# Move
	move(pos)

# Move player with tween
func move(pos):
	is_moving = true # Toggle to prevent unfinished movement before new movement
	
	if(tween == null):
		tween = Tween.new()
		get_parent().add_child(tween)
		tween.connect("tween_complete", self, "move_complete")
	
	tween.interpolate_property(self, "transform/pos", get_pos(), pos, speed, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()
	
# Notify us when the movement has stopped, enable input
func move_complete(tween, key):
	is_moving = false