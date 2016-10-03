extends Control

var game_running = false
var game_over = false
var paused = false
var current_level = 1

func _ready():
	# Enable input
	set_process_input(true)

func _input(event):
	# Pressed UI_UP
	if(event.is_action_pressed("ui_accept")):
		if(!paused):
			# Close Intro overlay and start coutndown
			if(!game_running && !game_over):
				print("Starting game")
				
				spawn_player()

				
				# Start game
				get_child(0).get_node("ui").set_intro(false)
				get_child(0).get_node("ui").start_countdown() # Start timer
				game_running = true
		else:
			# Return to main menu
			# game_running = false
			get_tree().set_pause(false)
			get_tree().get_root().get_node("game").main_menu()
			print("Closing game and returning to main menu")
		
		if(game_over && !game_running):
			# Restart level
			print("Restarting level")
			# Game over to false
			game_over = false
			get_child(0).queue_free()
			load_level(current_level)
	
	# PAUSE
	elif(event.is_action_pressed("ui_start")):
		# Return to main menu
		if(game_running):
			if(!paused):
				# Pause
				print("PAUSE GAME!")
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
				print("RESUME GAME!")
		else:
			# Return directly to main menu
			paused = false
			print("RETURN TO MAIN MENU")


func spawn_player():
	# Get player spawn from level
	var tilemap = get_child(0).get_node("extra")
	var tiles = tilemap.get_used_cells()
	var spawn_vec2 = null
	for t in tiles:
		# If it is a spawn tile
		if(tilemap.get_cell(t.x, t.y) == 0):
			# Convert player pos into world coordinates
			var vec2_world = tilemap.map_to_world(t)
			
			# Store position as player spawn pos
			spawn_vec2 = vec2_world
			
			# If there are more spawn tiles, ignore the rest
			break
	
	# Create player on spawn position
	if(spawn_vec2 != null):
		# Create player instance
		var player = load("res://data/player/player.tscn").instance()
		player.set_pos(spawn_vec2)
		get_child(0).add_child(player)
	else:
		print("ERROR: Missing SPAWN tile!")


func load_level(level):
	print("Loading level " + str(level))
	current_level = level
	
	# Create level scene
	var scene = load("res://data/levels/" + str(level).pad_zeros(2) + "/level.tscn").instance()
	scene.get_node("ui").connect("game_over", self, "game_over")

	add_child(scene)

# Set game over
func game_over():
	print("Game over - time limit reached")
	get_child(0).get_node("player").queue_free()
	game_over = true
	game_running = false
	