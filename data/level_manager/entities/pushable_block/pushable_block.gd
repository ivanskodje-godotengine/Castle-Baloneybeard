extends Node2D

# Tile size
var tile_size = global.config.tile_size

func _ready():
	patrol()

func patrol(counterclock = false):
	# Check for nearest patrol route
	if(!counterclock):
		
		
		# Check north
		var next_pos = get_pos()
		next_pos.y -= global.config.tile_size
		
		# Check east
		
		# Check south
		
		# Check west
		pass
	else:
		pass

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


func _on_enemy_area_enter( area ):
	print("On Enemy area entering... --> " + str(area.get_name()))


func _on_enemy_body_enter( body ):
	if(body.get_name() == "player"):
		print("Kill player")
	else:
		print("----> " + str(body.get_name()))
