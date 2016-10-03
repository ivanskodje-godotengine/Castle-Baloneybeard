extends Sprite

var tile_size = 16

func _ready():
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
	
	set_pos(pos)