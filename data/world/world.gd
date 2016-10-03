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
			remove_child(get_child(0))
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
			else:
				# Return to main menu after pressing ESC twice
				paused = false
				get_child(0).get_node("ui").set_pause(false)
				get_tree().set_pause(false)
				print("RESUME GAME!")
		else:
			# Return directly to main menu
			paused = false
			print("RETURN TO MAIN MENU")
	
func load_level(level):
	print("Loading level " + str(level))
	current_level = level
	var scene = load("res://data/levels/" + str(level).pad_zeros(2) + "/level.tscn").instance()
	
	scene.get_node("ui").connect("game_over", self, "game_over")
	add_child(scene)

# Set game over
func game_over():
	print("Game over - time limit reached")
	game_over = true
	game_running = false