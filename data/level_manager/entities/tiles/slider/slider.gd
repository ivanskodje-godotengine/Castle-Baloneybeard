extends Sprite

export(int, "Horizontal", "Vertical") var orientation

# Facing direction of this slider
var direction = null 

# Used to determine whether or not to enable player movement after moving him
var has_next = false 


func _ready():
	# Update direction
	update_direction()
	
	# Check if we have
	check_for_next()
	
	pass


# Check the next tile and see if there is another slider
func check_for_next():
		# Get next pos and check if there is a slider
		var next_pos = get_pos()
		if(direction == global.DIRECTION.UP):
			next_pos.y -= global.config.tile_size
			pass
		elif(direction == global.DIRECTION.RIGHT):
			next_pos.x += global.config.tile_size
			pass
		elif(direction == global.DIRECTION.DOWN):
			next_pos.y += global.config.tile_size
			pass
		elif(direction == global.DIRECTION.LEFT):
			next_pos.x -= global.config.tile_size
			pass
		
		


# Set our direction
func update_direction():
	if(orientation == 0): # Horizontal
		if(!is_flipped_h()):
			direction = global.DIRECTION.LEFT
		else:
			direction = global.DIRECTION.RIGHT
	elif(orientation == 1): # Vertical
		if(!is_flipped_v()):
			direction = global.DIRECTION.UP
		else:
			direction = global.DIRECTION.DOWN
