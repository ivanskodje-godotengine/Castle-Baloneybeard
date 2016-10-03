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
				print("A1")
				# Start game
				get_child(0).get_node("ui").set_intro(false)
				get_child(0).get_node("ui").start_countdown() # Start timer
				game_running = true
			
			if(game_over && !game_running):
				# Restart level
				print("Restarting level...")
				# Game over to false
				game_over = false
				get_child(0).queue_free()
				load_level(current_level)
		else:
			# Paused - Pressing USE confirms returning to menu
			print("Remove pause and continue")
	
	# ESCAPE
	elif(event.is_action_pressed("ui_cancel")):
		# Return to main menu
		if(game_running):
			if(!paused):
				# Pause
				print("PAUSE GAME, IF PRESSING ESC AGAIN, QUIT TO MAIN MENU")
				paused = true
			else:
				# Return to main menu after pressing ESC twice
				paused = false
				print("RETURN TO MAIN MENU")
		else:
			# Return directly to main menu
			paused = false
			print("RETURN TO MAIN MENU")
	
func load_level(level):
	print("B1")
	current_level = level
	var scene = load("res://data/levels/" + str(level).pad_zeros(2) + "/level.tscn").instance()
	
	scene.get_node("ui").connect("game_over", self, "game_over")
	add_child(scene)

# Set game over
func game_over():
	print("G1")
	game_over = true
	game_running = false