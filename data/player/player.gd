extends KinematicBody2D

# Movement
var tween = null # Moves the player from current to next tile smoothly
var is_moving = false # Prevents moving outside of tile positions
var tile_size = 16
var speed = 0.25 # Time between movement
var previous_pos # Vec2 Previous Cell Position 

onready var ui_node = get_parent().get_node("ui")

# Player Inventory
var inventory = {
	KEYS = {
		DIAMOND = 0,
		SPADE = 0,
		CLUB = 0,
		HEART = 0
	},
	BALONEY = {
		CURRENT = 0,
		TOTAL = 0
	},
	TOOL = {
		WATER = 0,
		FIRE = 0
	},
}


# Direction to move
const DIRECTION = {
LEFT = 0,
RIGHT = 1,
UP = 2,
DOWN = 3,
}


func _ready():
	# get_parent().get_node("extra")
	set_process_input(true)
	set_fixed_process(true)
	update_total_baloneys()
	pass


# Note: Can only run after you have been set as child
func spawn_at(vec2):
	var tilemap_extra = get_parent().get_node("extra")
	if(tilemap_extra != null):
		var world_pos = tilemap_extra.map_to_world(vec2)
		set_pos(world_pos)


# Using fixed process so player can hold down buttons for movement
func _fixed_process(delta):
	if(!is_moving):
		if(Input.is_action_pressed("ui_left")):
			move(DIRECTION.LEFT)
		elif(Input.is_action_pressed("ui_right")):
			move(DIRECTION.RIGHT)
		elif(Input.is_action_pressed("ui_up")):
			move(DIRECTION.UP)
		elif(Input.is_action_pressed("ui_down")):
			move(DIRECTION.DOWN)


# Move player with tween
func move(direction):
	# Check collision
	if(can_move(direction)):
		# Toggle to prevent unfinished movement before new movement
		is_moving = true 
		
		# Get current position
		var pos = get_pos()
		
		# Store current pos as previous
		previous_pos = pos
		
		# Add directional change to position
		if(direction == DIRECTION.LEFT):
			pos.x -= tile_size
		elif(direction == DIRECTION.RIGHT):
			pos.x += tile_size
		elif(direction == DIRECTION.UP):
			pos.y -= tile_size
		elif(direction == DIRECTION.DOWN):
			pos.y += tile_size
		
		# Tween from original position to new position
		if(tween == null): # Create once
			tween = Tween.new()
			get_parent().add_child(tween)
			tween.connect("tween_complete", self, "move_complete")
		tween.interpolate_property(self, "transform/pos", get_pos(), pos, speed, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
		tween.start()


# After movement is complete, we are no longer moving and can move again
func move_complete(tween, key):
	is_moving = false


# Fill in tile IDs for solid tiles
var SOLID_TILES = {
	WORLD = [1,3,5],
	ENTITIES = [0,1,2,3,10]
}

# Ids for the itmes the player can pickup (Entities only)
var ITEM = {
	SANDWICH = 4,
	HEART = 5,
	DIAMOND = 6,
	SPADE = 7,
	CLUB = 8,
	BALONEY = 9,
}

# Door block ids (Entities)
var DOOR = {
	HEART = 0,
	CLUB = 1,
	SPADE = 2,
	DIAMOND = 3,
}

# Returns true if player can move in the requested direction
func can_move(direction):
	var pos = get_pos()
	var tile_pos = null
	var tilemap_world = get_parent().get_node("world")
	var tilemap_entity = get_parent().get_node("entities")
	
	if(tilemap_world != null):
		# Get tile coordinate of where you currently are
		tile_pos = tilemap_world.world_to_map(pos)
	
	# Check if we have a solid block in the next block
	if(direction == DIRECTION.LEFT):
		# Check tile to your immediate left
		tile_pos.x -= 1
	elif(direction == DIRECTION.RIGHT):
		tile_pos.x += 1
	elif(direction == DIRECTION.UP):
		tile_pos.y -= 1
	elif(direction == DIRECTION.DOWN):
		tile_pos.y += 1
	
	# Check if tile is solid
	for t in SOLID_TILES["WORLD"]:
		if(t == tilemap_world.get_cellv(tile_pos)):
			return false
	
	for t in SOLID_TILES["ENTITIES"]:
		if(t == tilemap_entity.get_cellv(tile_pos)):
			# If it is a door, and we got the key, destroy door
			if(t == DOOR["SPADE"]):
				if(inventory["KEYS"]["SPADE"] > 0):
					inventory["KEYS"]["SPADE"] -= 1 # reduce by one
					tilemap_entity.set_cellv(tile_pos, -1)
					update_ui()
				else:
					return false
			elif(t == DOOR["DIAMOND"]):
				if(inventory["KEYS"]["DIAMOND"] > 0):
					inventory["KEYS"]["DIAMOND"] -= 1 # reduce by one
					tilemap_entity.set_cellv(tile_pos, -1)
					update_ui()
				else:
					return false
			elif(t == DOOR["CLUB"]):
				if(inventory["KEYS"]["CLUB"] > 0):
					inventory["KEYS"]["CLUB"] -= 1 # reduce by one
					tilemap_entity.set_cellv(tile_pos, -1)
					update_ui()
				else:
					return false
			elif(t == DOOR["HEART"]):
				if(inventory["KEYS"]["HEART"] > 0):
					inventory["KEYS"]["HEART"] -= 1 # reduce by one
					tilemap_entity.set_cellv(tile_pos, -1)
					update_ui()
				else:
					return false
			# We have a pushable block
			elif(t == 10):
				# Check if we can move block
				var move_to_pos = tile_pos
				# Check if we have a solid block in the next block
				if(direction == DIRECTION.LEFT):
					# Check tile to your immediate left
					move_to_pos.x -= 1
				elif(direction == DIRECTION.RIGHT):
					move_to_pos.x += 1
				elif(direction == DIRECTION.UP):
					move_to_pos.y -= 1
				elif(direction == DIRECTION.DOWN):
					move_to_pos.y += 1
				
				# Making sure there is nothing else in the position where we want to move the block
				if(tilemap_entity.get_cellv(move_to_pos) == -1):
					for c in SOLID_TILES["WORLD"]:
						if(tilemap_world.get_cellv(move_to_pos) == c):
							return false # Something is in the way, we cannot move
					
					# All clear! Moving block
					tilemap_entity.set_cellv(tile_pos, -1)
					tilemap_entity.set_cellv(move_to_pos, 10)
				else:
					# TODO: Play sound to indicate failure to push
					# ..
					return false
			else:
				return false
	
	# Check if there are any items we can pickup
	var tile_id = tilemap_entity.get_cellv(tile_pos)
	
	# Diamond
	if(tile_id == ITEM.DIAMOND):
		inventory["KEYS"]["DIAMOND"] += 1
		tilemap_entity.set_cellv(tile_pos, -1)
		update_ui()
		
	# Spade
	elif(tile_id == ITEM.SPADE):
		inventory["KEYS"]["SPADE"] += 1
		tilemap_entity.set_cellv(tile_pos, -1)
		update_ui()
	
	# Club
	elif(tile_id == ITEM.CLUB):
		inventory["KEYS"]["CLUB"] += 1
		tilemap_entity.set_cellv(tile_pos, -1)
		update_ui()
	
	# Heart
	elif(tile_id == ITEM.HEART):
		inventory["KEYS"]["HEART"] += 1
		tilemap_entity.set_cellv(tile_pos, -1)
		update_ui()
	
	# Baloney
	elif(tile_id == ITEM.BALONEY):
		inventory["BALONEY"]["CURRENT"] += 1
		ui_node.update_baloney(inventory["BALONEY"]["TOTAL"] - inventory["BALONEY"]["CURRENT"])
		
		get_parent().get_node("items/goal").add_baloney()
		
		# If we have collected all baloneys, add bread on top to finish it all off
		if(inventory["BALONEY"]["CURRENT"] == inventory["BALONEY"]["TOTAL"]):
			get_parent().get_node("items/goal").finish()
		
		# Remove baloney
		tilemap_entity.set_cellv(tile_pos, -1)
	
	return true

# Triggered by walking on a goal
func walked_on_goal():
	# If we have all baloneys # -----------------------------------------------------<_<-<-<-<--<_<->_-><_ REMEMBER TO FIX WHEN DONE DEBUGGING
	if(inventory["BALONEY"]["CURRENT"] != inventory["BALONEY"]["TOTAL"]):
		# Victory!
		# .. Do something here before going to next level
		
		# Go to next level
		get_parent().get_parent().load_next_level()

func in_water():
	# Player is in water! Check if he has the item needed
	if(inventory["TOOL"]["WATER"] > 0):
		# Safe!
		pass
	else:
		# Death awaits us!
		get_parent().get_parent().game_over()
		pass

func update_ui():
	# var ui = get_parent().get_node("ui")
	ui_node.update_keys(inventory["KEYS"])
	pass

# Counts and sets the total number of baloneys there is on the map
func update_total_baloneys():
	var tilemap_entities = get_parent().get_node("entities")
	var used_cells = tilemap_entities.get_used_cells()
	
	# For each baloney we find, increment total until we have counted them all
	for c in used_cells:
		if(tilemap_entities.get_cellv(c) == 9):
			inventory["BALONEY"]["TOTAL"] += 1
	ui_node.update_baloney(inventory["BALONEY"]["TOTAL"])