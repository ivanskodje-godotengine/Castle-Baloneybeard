extends Sprite

export(int, "Horizontal", "Vertical") var orientation

# Facing direction of this slider
var direction = null 

# Used to determine whether or not to enable player movement after moving him
var has_next = false 
var next_pos = null

func _ready():
	# Update direction
	update_direction()
	
	# Check if we have
	check_for_next()
	
	pass


# Set our direction
func update_direction():
	if(orientation == 0): # Horizontal
		print("HORI")
		if(!is_flipped_h()):
			direction = global.DIRECTION.LEFT
		else:
			direction = global.DIRECTION.RIGHT
	elif(orientation == 1): # Vertical
		print("VERT")
		if(!is_flipped_v()):
			direction = global.DIRECTION.UP
		else:
			direction = global.DIRECTION.DOWN


# Check the next tile and see if there is another slider
func check_for_next():
		# Get next pos and check if there is a slider
		next_pos = get_pos()
		
		if(direction == global.DIRECTION.UP):
			next_pos.y -= global.config.tile_size
		elif(direction == global.DIRECTION.RIGHT):
			next_pos.x += global.config.tile_size
		elif(direction == global.DIRECTION.DOWN):
			next_pos.y += global.config.tile_size
		elif(direction == global.DIRECTION.LEFT):
			next_pos.x -= global.config.tile_size
		
		var cell_pos = get_parent().world_to_map(next_pos)
		var cell_id = get_parent().get_cellv(cell_pos)
		
		if(cell_id == global.WORLD.SLIDER):
			has_next = true
		

func _on_slider_body_enter( body ):
	if(body.get_name() == "player"):
		# If I have next, push and disable movement
		if(has_next):
			body.slide_to_next(next_pos) # Disable player movement and move
		else:
			body.slide_to_next(next_pos, false) # We do not have next, so we move and enable player movement
	pass
	
