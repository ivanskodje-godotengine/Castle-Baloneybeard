extends Control

var game_running = false
var game_over = false
var paused = false
var current_level = 1
var tile_size = 16 # Tile size used for tilemaps - used to move player

func _ready():
	# Enable input
	set_process_input(true)

func _input(event):
	# Pressed UI_UP
	if(event.is_action_pressed("ui_accept")):
		if(!paused):
			# Close Intro overlay and start coutndown
			if(!game_running && !game_over):
				# Spawn player
				spawn_player()

				# Start game
				get_child(0).get_node("ui").set_intro(false)
				get_child(0).get_node("ui").start_countdown() # Start timer
				game_running = true
		else:
			# Return to main menu
			get_tree().set_pause(false)
			get_tree().get_root().get_node("game").main_menu()
		
		if(game_over && !game_running):
			# Restart level
			game_over = false
			get_child(0).queue_free()
			load_level(current_level)
	
	# PAUSE
	elif(event.is_action_pressed("ui_start")):
		# Return to main menu
		if(game_running):
			if(!paused):
				# Pause
				paused = true
				get_child(0).get_node("ui").set_pause(true)
				get_tree().set_pause(true)
				get_child(0).get_node("player").hide()
			else:
				# Resume
				paused = false
				get_child(0).get_node("ui").set_pause(false)
				get_tree().set_pause(false)
				get_child(0).get_node("player").show()
		else:
			# Return directly to main menu
			get_tree().set_pause(false)
			get_tree().get_root().get_node("game").main_menu()


func spawn_player():
	# Get player spawn from level
	var tilemap = get_child(0).get_node("extra")
	var tiles = tilemap.get_used_cells()
	var spawn_vec2 = null
	
	for t in tiles:
		# If it is a spawn tile
		if(tilemap.get_cell(t.x, t.y) == 0):
			# Save vec2 pos for tile
			spawn_vec2 = t
			break
	
	# Create player on spawn position
	if(spawn_vec2 != null):
		# Create player instance
		var player = load("res://data/player/player.tscn").instance()
		get_child(0).add_child(player)
		player.spawn_at(spawn_vec2) # Must spawn AFTER being added to child
	else:
		print("LEVEL ERROR: Level is missing a spawn position!")


func load_level(level):
	# Store current level in order to go to next leven when we reach the goal
	current_level = level
	
	# Create level scene
	var level_scene = load("res://data/levels/" + str(level).pad_zeros(2) + "/level.tscn")
	if(level_scene != null):
		var scene = level_scene.instance()
		scene.get_node("ui").connect("game_over", self, "game_over")
		add_child(scene)
		update_tiles(scene)
	else:
		# Credits / Victory Cutscene
		# ..
		
		# Go back to menu
		get_tree().set_pause(false)
		get_tree().get_root().get_node("game").main_menu()
		


var ENTITIES = {
	SANDWICH = 4, # Goal
	HEART = 5, # Key for Heart Door
	DIAMOND = 6, # Key for Diamond Door
	SPADE = 7, # Key for Spade Door
	CLUB = 8, # Key for Club Door
	BALONEY = 9, # Baloney
	PUSHABLE_BLOCK = 10, # Pushable Block
}

var stored_cells = [] # Vec2, tileset and tile_id

var goal = preload("res://data/goal/goal.tscn")

# Replace all special tiles with instances that may be interacted with
func update_tiles(level_scene):
	var world_tilemap = level_scene.get_node("world")
	var extra_tilemap = level_scene.get_node("extra")
	
	var entities_tilemap = level_scene.get_node("entities")
	var entities_used_cells = entities_tilemap.get_used_cells()
	
	# Iterate through all used entities in the map
	for cell_pos in entities_used_cells:
		var cell_id = entities_tilemap.get_cellv(cell_pos)
		var tile_pos = entities_tilemap.map_to_world(cell_pos)
		if(cell_id == ENTITIES["SANDWICH"]):
			# Spawn entity
			var sandwich = goal.instance()
			sandwich.set_pos(tile_pos)
			
			# If we dont have an items node, create it
			if(level_scene.get_node("items") == null):
				var items_node = Node2D.new()
				items_node.set_name("items")
				level_scene.add_child(items_node)
			
			# Add sandwich goal
			level_scene.get_node("items").add_child(sandwich)
			
			# Remove original cell
			entities_tilemap.set_cellv(cell_pos, -1)
	
	
	pass


# Go to next level (while we are already playing)
func load_next_level():
	get_child(0).queue_free() # Remove current level 
	game_running = false
	game_over = false
	paused = false
	current_level += 1
	load_level(current_level)


# Set game over
func game_over():
	get_child(0).get_node("player").queue_free()
	game_over = true
	game_running = false