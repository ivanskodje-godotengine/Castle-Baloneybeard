extends Node2D

# Tile size
var tile_size = global.config.tile_size

# Previous position - Used to blacklist position to prevent going back the direction you came from
var previous_pos = null

# Time between movement
var movement_speed = 0.3

# Timer
var timer = null

func _ready():
	# Create timer
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_wait_time(movement_speed)
	timer.connect("timeout", self, "patrol")
	timer.set_name("patrol_timer")
	add_child(timer)
	
	# Start movement
	timer.start()


# Patrols
func patrol():
	var next_pos = get_pos()
	
	# NORTH
	var north_pos = next_pos
	north_pos.y -= global.config.tile_size
	
	# Is there a patrol cell?
	var cell_pos = get_parent().get_parent().get_node("extra").world_to_map(north_pos)
	var cell_id = get_parent().get_parent().get_node("extra").get_cellv(cell_pos)
	
	if(cell_id == global.EXTRA.PATROL && previous_pos != north_pos):
		# Move north
		previous_pos = get_pos()
		set_pos(north_pos)
		
		return
	
	# ------------
	
	# EAST
	var east_pos = next_pos
	east_pos.x += global.config.tile_size
	
	# Is there a patrol cell?
	var cell_pos = get_parent().get_parent().get_node("extra").world_to_map(east_pos)
	var cell_id = get_parent().get_parent().get_node("extra").get_cellv(cell_pos)
	
	if(cell_id == global.EXTRA.PATROL && previous_pos != east_pos):
		# Move north
		previous_pos = get_pos()
		set_pos(east_pos)
		return

	# ------------
	
	# SOUTH
	var south_pos = next_pos
	south_pos.y += global.config.tile_size
	
	# Is there a patrol cell?
	var cell_pos = get_parent().get_parent().get_node("extra").world_to_map(south_pos)
	var cell_id = get_parent().get_parent().get_node("extra").get_cellv(cell_pos)
	
	if(cell_id == global.EXTRA.PATROL && previous_pos != south_pos):
		# Move north
		previous_pos = get_pos()
		set_pos(south_pos)
		return

	# ------------
	
	# WEST
	var west_pos = next_pos
	west_pos.x -= global.config.tile_size
	
	# Is there a patrol cell?
	var cell_pos = get_parent().get_parent().get_node("extra").world_to_map(west_pos)
	var cell_id = get_parent().get_parent().get_node("extra").get_cellv(cell_pos)
	
	if(cell_id == global.EXTRA.PATROL && previous_pos != west_pos):
		# Move north
		previous_pos = get_pos()
		set_pos(west_pos)
		return


func move(direction):
	var pos = get_pos()

	# Left
	if(direction == 0):
		pos.x -= tile_size
	# Right
	elif(direction == 1):
		pos.x += tile_size
	# Up
	elif(direction == 2):
		pos.y -= tile_size
	# Down
	elif(direction == 3):
		pos.y += tile_size

	# TODO: Tween
	set_pos(pos)


func _on_enemy_body_enter( body ):
	if(body.get_name() == "player"):
		body.death()
