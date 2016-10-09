extends Control

# Timer
var timer = null
var current_time = null
var level = null

# Sandwich
var sandwich_scene = null

func start_countdown():
	timer.start()

func _countdown():
	current_time -= 1 # decrease by one
	
	# If time is up, stop the timer and display time out
	if(current_time < 0):
		current_time = 0 # Time to 0
		global.total_time = 0 # Set total time to 0
		timer.stop()
		global.current_state = global.STATE.TIME_OUT
		get_child(0).get_node("ui").update_state()
		get_tree().set_pause(true) # pause
	
	# Update UI label
	get_child(0).get_node("ui").time_label.set_text(str(current_time).pad_zeros(3))


# Ready
func _ready():
	# Enable input events
	set_process_input(true)
	
	# Create timer
	timer = Timer.new()
	timer.set_one_shot(false)
	timer.set_wait_time(1)
	timer.connect("timeout", self, "_countdown")
	timer.set_name("timer")
	get_parent().add_child(timer)
	
	# Load level
	load_level(global.config["level"]["current"])

# Input Events
func _input(event):
	# Pressed ACCEPT/USE
	if(event.is_action_pressed("ui_accept")):
		# If we are at INTRO state
		if(global.current_state == global.STATE.INTRO):
			# Enable player processing
			toggle_player_processing()
			
			# NB: Set state before we update UI
			global.current_state = global.STATE.PLAYING 
			
			# Update UI
			get_child(0).get_node("ui").update_state()
			
			# Start timer
			start_countdown() 
		
		# If we are in the PAUSE menu, return to main menu
		elif(global.current_state == global.STATE.PAUSE):
			# Unpause
			get_tree().set_pause(false)
			
			# Go to main menu
			get_parent().main_menu()
		
		# If the game has ended in one way or another, and we press accept
		elif(global.current_state == global.STATE.TIME_OUT || global.current_state == global.STATE.DEATH):
			# Set state
			global.current_state = global.STATE.INTRO
			
			# Reload level
			load_level(global.config["level"]["current"])
		
		# If victory conditions (per level) has meet
		elif(global.current_state == global.STATE.VICTORY):
			# Set state
			global.current_state = global.STATE.INTRO
			
			# Increment level by one
			var level = global.config["level"]["current"] + 1
			
			# If current level is higher than total levels, it means the game is complete! Final victory!
			if(level > global.config["level"]["total"]):
				get_tree().set_pause(false)
				get_parent().credits()
			else:
				# Load next level
				load_level(level)
	
	
	# Pressed START
	elif(event.is_action_pressed("ui_start")):
		# If we are playing and press START: Pause
		if(global.current_state == global.STATE.PLAYING):
			# Pause
			get_tree().set_pause(true)
			
			# Set state
			global.current_state = global.STATE.PAUSE
			
			# Update UI
			get_child(0).get_node("ui").update_state()
		
		# If we are in pause and press START: Resume
		elif(global.current_state == global.STATE.PAUSE):
			# Unpause
			get_tree().set_pause(false)
			
			# Set state
			global.current_state = global.STATE.PLAYING
			
			# Update UI
			get_child(0).get_node("ui").update_state()


# Spawn player
func spawn_player():
	# Get the cell position of the player SPAWN tile; found in the 'Extra' tileset
	var tilemap = get_child(0).get_node("extra")
	var used_cells = tilemap.get_used_cells()
	var cell_pos = null
	
	# Check all used cells inside the tilemap for 'extra'
	for c in used_cells:
		# If it is an spawn tile
		if(tilemap.get_cell(c.x, c.y) == 0):
			cell_pos = c # Store cell position (Vec2)
			break
	
	# If we have a spawn position, create a player and spawn it
	if(cell_pos != null):
		var spawn_pos = tilemap.map_to_world(cell_pos)
		var player = load("res://data/player/player.tscn").instance()
		get_child(0).add_child(player)
		player.set_pos(spawn_pos)
		player.set_fixed_process(false)
	 
	# No spawn tile found
	else:
		print("LEVEL ERROR: Level is missing a spawn position!")


# Toggles player processing (on / off) and returns the current activity result
func toggle_player_processing():
	var player = get_child(0).get_node("player")
	var fixed_processing = !player.is_fixed_processing() # Toggle
	player.set_fixed_process(fixed_processing)
	return fixed_processing


# Load level
func load_level(level):
	# If the level is invalid, return
	if(level > global.config.level.total && level < 0):
		print("ERROR: Level inserted into load_level is invalid")
		return false
	
	# Stop timer
	timer.stop()
	
	# Play music
	# global.play_music(global.MUSIC.LEVEL1)
	
	# Remove level if it already exist
	if(get_child(0)):
		remove_child(get_child(0))
	
	# Store selected level as current
	global.config.level.current = level

	# Create level scene
	var level_scene = load("res://data/level_manager/levels/" + str(level).pad_zeros(2) + "/level.tscn")
	if(level_scene != null):
		var scene = level_scene.instance()
		add_child(scene)
		update_tiles(scene)
		
		# Get total time from level
		current_time = scene.get_time()
		global.total_time = current_time
		
		# Set initial time to the total time
		get_child(0).get_node("ui").time_label.set_text(str(global.total_time).pad_zeros(3))
	else:
		print("Something went wrong, level does not exist: " + str(level).pad_zeros(2))
		# Go back to menu
		get_tree().set_pause(false)
		get_parent().main_menu()
	
	# Spawn player
	spawn_player()
	
	# Update UI
	get_child(0).get_node("ui").update_state()


# BLOCKS
var sandwich = preload("res://data/level_manager/entities/sandwich/sandwich.tscn")
var water_tile = preload("res://data/level_manager/entities/tiles/water/water.tscn")
var ice_tile = preload("res://data/level_manager/entities/tiles/ice/ice.tscn")
var fire_tile = preload("res://data/level_manager/entities/tiles/fire/fire.tscn")

# ENEMIES
var enemy_patrol = preload("res://data/level_manager/entities/enemy_patrol/enemy_patrol.tscn")

# Replace all special tiles with instances that may be interacted with
func update_tiles(level_scene):
	# World tilemap
	var world_tilemap = level_scene.get_node("world")
	var world_used_cells = world_tilemap.get_used_cells()
	
	# Extra tilemap
	var extra_tilemap = level_scene.get_node("extra")
	
	# Entities tilemap
	var entities_tilemap = level_scene.get_node("entities")
	var entities_used_cells = entities_tilemap.get_used_cells()
	
	# Enemies tilemap
	var enemies_tilemap = level_scene.get_node("enemies")
	var enemies_used_cells = null
	if(enemies_tilemap != null):
		enemies_used_cells = enemies_tilemap.get_used_cells()
	
	# Reset key data data
	global.reset_inventory()

	# If we dont have an items node, create it
	if(level_scene.get_node("items") == null):
		var items_node = Node2D.new()
		items_node.set_name("items")
		level_scene.add_child(items_node)
	
	# Iterate through all used entities in the map
	# This makes it easier for the level creator. Only have to place blocks and it will do as expected. 
	# No need to script or manually positioning of tiles.
	for cell_pos in entities_used_cells:
		var cell_id = entities_tilemap.get_cellv(cell_pos)
		var tile_pos = entities_tilemap.map_to_world(cell_pos)
		
		# Replace all SANDWICH blocks with an instance 
		if(cell_id == global.ENTITIES.BLOCK.SANDWICH):
			# Create sandwich
			sandwich_scene = sandwich.instance()
			
			# Set sandwich position on tile
			sandwich_scene.set_pos(tile_pos)
			
			# Add sandwich to scene
			level_scene.get_node("items").add_child(sandwich_scene)
			
			# Remove the original cell
			entities_tilemap.set_cellv(cell_pos, -1)
		
		# Count number of baloney tiles and add to total
		elif(cell_id == global.ENTITIES.BALONEY):
			global.inventory.BALONEY.TOTAL += 1
		
		# Fire
		elif(cell_id == global.ENTITIES.BLOCK.FIRE):
			var fire = fire_tile.instance()
			fire.set_pos(tile_pos)
			level_scene.get_node("items").add_child(fire)
			
			# Remove the original cell
			entities_tilemap.set_cellv(cell_pos, -1)
	
	# Iterate through all used world tiles in the map
	for cell_pos in world_used_cells:
		var cell_id = world_tilemap.get_cellv(cell_pos)
		var tile_pos = world_tilemap.map_to_world(cell_pos)
		
		if(cell_id == global.WORLD.WATER): # Water
			# Add animated water tiles
			var water = water_tile.instance()
			water.set_pos(tile_pos)
			world_tilemap.add_child(water)
		elif(cell_id == global.WORLD.ICE): # Ice
			var ice = ice_tile.instance()
			ice.set_pos(tile_pos)
			world_tilemap.add_child(ice)
	
	# Replace enemy cells with instances
	if(enemies_tilemap != null):
		for cell_pos in enemies_used_cells:
			var cell_id = enemies_tilemap.get_cellv(cell_pos)
			var tile_pos = enemies_tilemap.map_to_world(cell_pos)
			print("CELL_POS " + str(enemies_used_cells))
			if(cell_id == global.ENEMIES.PATROL):
				# Add enemy instances
				var enemy = enemy_patrol.instance()
				enemy.set_pos(tile_pos)
				enemies_tilemap.add_child(enemy)
				
				# Remove the original cellww
				enemies_tilemap.set_cellv(cell_pos, -1)


# Adds baloney on the sandwich - The sandwich which you will eat after collecting all the baloney.
func add_baloney():
	# If we have collected all baloneys, add bread on top to finish it all off
	if(sandwich_scene != null):
		sandwich_scene.add_baloney()
		
		if(global.inventory.BALONEY.CURRENT == global.inventory.BALONEY.TOTAL):
			sandwich_scene.finish()


# Victory
func victory():
	# Set state
	global.current_state = global.STATE.VICTORY
	
	# Stop timer
	timer.stop()
	
	# Update UI
	get_child(0).get_node("ui").update_state()
	
	# Sound
	global.play_sound(global.SOUND.PLAYER_VICTORY)


# Set game over
func death():
	# Set state
	global.current_state = global.STATE.DEATH
	
	# Update UI
	get_child(0).get_node("ui").update_state()
	
	# Sound
	global.play_sound(global.SOUND.PLAYER_DEATH)


# This is the lady of judgement. 
# She judges the quality of your code.
# Don't disappoint lady of judgement.
#. ... ... ... ... ... ... ... ... ,,----~~”'¯¯¯¯¯¯”'~~----,,
#... ... ... ... ... ...,,-~”¯::::::::::::::::::::::::::::::::::¯”'~,,
#... ... ... ... ..,,~”::::::::::::::::::::::::::::::::::::::::::::::::::::”~,,
#... ... ... ..,,-“:::::::::::::::/::::::/::::::::::::::::\::::::::::::\:::::::::\
#... ... ...,-“:::::,-“:::/:::::/::::::/:|::::::::::::::::\::::::::::::\:::::::::\
#... ... .,-“:::::::/:::::|:::::|:::::::|:|:::::::|:::::::\\:::::::::::|:|:::::\::\
#... ... /::::::/:::|::::::|:::::|::|::::\:\:::::/\::::/:::||:::::::::|:/::::::|:::|
#... .../::::::|:::::\::::::\::::\::\::::/\:\,::/::\::/::::|:|:::::::/\/::::::/::::|
#... ../::::::/::::::'\::::::\-,:::\/\::/: :\-,”/ : :\/:\:::/: |:::::/::/::::::|::::/
#... ./::::::|:::::::::\::::::\|::/: \/: : : \/: : : : : \,/: \/::_/\//:\:::::/:::/
#... /::::::/::/:::::::|::/,__/:/: :__/ . .: : : : : : :\__. \/: \:::::/::/:::/
#... |:::|::::::::::::/::/::::/;/ ;/ ,. .,\: : : : : : : / ,._., \ /::::::|::/:|
#...|:::/:::/::::::::/::/|:::|.\: |.|❤||; : : : : : :|.|.❤||;|::|:::\/:/
#...|::|:::|::::::::/:::\|:::'\,|: \."'" /: : : : : : : :'\." '"/ : \: |:::|::\
#...|::|:::|:::::::/:::::|::::|/: : “¯': : : : : : : : : :"¯'' : : :\ : :/::::'\
#...|::|:::|::::::/:::::/:::::'\: : : : : : : : : : : : : : :': : : : :| :/::::::|
#... \:|:::|:::::|::::::|::::::|,: : : : : : :~,___,~: : : : : :,-“:::::::|::|
#... .'\|::|:::::|::::::||::::::\'~,: : : : : : '~--~': : : : ,,~”\:::::::::|:/
#... ...'\:|:::::|::::::/.|::::::|: : “~,: : : : : : : : ,,-~,”::::::'\::::::::/
#... ... .\\:::::|”~,/-,|:::::::|: : : : ¯”~,-,,,-~”:::,,-'\::::::::\-,,_::|/
#... ... ..',\,::|~--'-~\:::::::|: : : : : : |::|,,-~”¯..__\::::::::\... .'|
#... ..,~”': : \|: : : : : \::::::|: : : : : : |¯”'~~”~,”,: : \:::::::|.. /
#..,-“: : : : : :|: : : : : :\::::::|: : : : : : \: : : : : : “~'-,:\::::::|\,
#..|: : : : : : : |: : : : : : |::::|,\,: : : : : : : : : : : : : :”-,-\::::|: \
#..| : : : : : : : : : : : : : |::::|:'-,\: : : : : : : : : : : : : : :”-'\,|: :|
#...\ : : : : : : : : : :'\: : :\:::|: : '\'\: : : : :~,,: : : : : : : : : “~-',_
#... \: : : : : : : : : : :\: /:|:/: : : :',-'-,_,: : : “-,: : : : : : : : :,/”'-,
#... .\: : : : : : : : : : :\|: |/: : : ,-“....”-,:\: : : : '\: : : : : : :,/.......”-,
#... ...\: : : : : : : : : : \: |: : :/...........\*/ : : : :|: : : : : :,-“...........'|
#... ... .\ : : : : : : : : : '\': : /..............\/ : : : : /: : : : : :,-“............./
#... ... ...\ : : : : : : : : : '\:/.................\: : :,/: : : : : /................./
#... ... .....\ : : : : : : : : : \........................\:,-“: : : : :,/............/
#... ... ... ...\ : : : : : : : : : \,_.............._,”======',_.................,-“\ 
#... ... ... ... \,: : : : : : : : : \: ¯”'~---~”¯: : : : : : : : : :¯”~~,': : : : \
#... ... ... ... ..'\,: : : : : : : : : \: : : : : : : : : : : : : : : : : : : '|: : \
#... ... ... ... ... .\, : : : : : : : : '\: : : : : : : : : : : : : : : : : : :|: : \
#... ... ... ... ... ...\,: : : : : : : : :\ : : : : : : : : : : : : : : : : : |: : :\
#... ... ... ... ... ... ..\ : : : : : : : : \: : : : : : : : : : : : : : : : :|: : : :\
#... ... ... ... ... ... ...\\,: : : : : : : :\, : : : : : : : : : : : : : : :/: : : : :\
#... ... ... ... ... ... ... .\\ : : : : : : : :'\ : : : : : : : : : : : : : :|: : : : : '|
#... ... ... ... ... ... ... ./:\: : : : : : : : :'\, : :;: : : : : :;: : : : |: : : : : :|
#... ... ... ... ... ... ... /: : \: : : : : : : : : '\,:;: : : : : :;: : : : |: : : : : :|
#... ... ... ... ... ... .../: : : '\: : : : : : : : : :'\,: : : : : :; : : : :|: : : : : : |
#... ... ... ... ... ... ../: : : : :\: : : : : : : : : : :\, : : : ;: : : : : |: : : : : /: |
#... ... ... ... ... ... ,/: : : : : : :\: : : : : : : : : : '\,:.. :: : : : : : |: : : :;:: |
#... ... ... ... ... ..,-“: : : : : : : :“-,: : : : : : : : : : \*, : : : : : :| : : : :\: |
#... ... ... ... ... ,/ : : : : : : : : : :”-, : : : : : : : : : :\: : : : : /: : : : : : /
#... ... ... ... ..,/ : : : : : : : : : : : : :”-, : : : : : : : : :'\: : : :| : : : : : ,/
#... ... ... ... ,/ : : : : : : : : : : : : : : : ;-,: : : : : : : : :'\: : |: : : : : : /
#... ... ... .../: : : : : : : : : : : : : : : : :;: “-,: : : : : : : : '\: |: : : : : /
#... ... ... ../: : : : : : : : : : : : : : : : : : : : :“-,: : : : : : : \,|: : : : :/
#... ... ... ,/: : : : : : : : : : : : : : : : : : : : : : :“-,: : : : : : :\: : : : /
#... ... .../-,-,”,,-,~-,,_: : : : : : : : : : : : : : : : : “-,: : : : : :'\: : :'|
#... ... ...|',/,/:||:\,\: : : “'~,,~~---,,,_: : : : : : : : '\: : : : : : : \,: :|
#... ... ..|: :”: ||: :”: : : : : : :”-,........ ¯¯”''~~~-~.|\: : : : : : : :  \:|
#... ... ..|: : : ||: : : : : : : : : : :”-,.......................|: : : : : : : \|
#... ... ..| : : : : : : : : : : : : : : : :”-,.....................\: : : : : : : :\,
#... ... ..| : : : : : : : : : : : : : : : :”-,\....................“\: : : : : : : : '\
#... ... ..| : : : : : : : : : : : : : : : : : :”-\...............,/: : :\: : : : : : :\ 
#... ... ..| : : : : : : : : : : : : : : : : : : : \,...........,/: : : : '\: : : : : : ||
#... ... ..| : : : : : : : : : : : : : : : : : : : : \.......,/: : : : ,-~/: : ,: |: /:|
#... ... ..'|: : : : : : : : : : : : : : : : : : : : : \~”¯: : : : : :|: ::|: :/::/:,/
#... ... ...|: : : : : : : : : : : : : : : : : : : : : |: : : : : : : :”-,,_/_,/-~”:|
#... ... ...|: : : : : : : : : : : : : : : : : : : : : |: : : : : : : : : : : : : : : :|
#... ... ... |: : : : : : : : : : : : : : : : : : : : : |: : : : : : : : : : : : : : : |
#... ... ... | : : : : : : : : : : : : : : : : : : : : :|: : : : : : : : : : : : : : :/