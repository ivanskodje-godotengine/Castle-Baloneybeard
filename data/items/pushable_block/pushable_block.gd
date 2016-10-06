extends Node2D

var tile_size = 16
var previous_pos
func _ready():
	pass

func move(direction):
	var pos = get_pos()
	previous_pos = pos
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

# If player enters body
func _on_Area2D_body_enter( body ):
	if(body.get_name() == "player"):
		var player_pos = body.get_pos()
		var pos = get_pos()
		# Left
		if(player_pos.x > pos.x):
			if(can_move(0)):
				move(0)
			else:
				# Push player back
				body.move_back()
		# Right
		elif(player_pos.x < pos.x):
			if(can_move(1)):
				move(1)
			else:
				# Push player back
				body.move_back()
		# Up
		elif(player_pos.y > pos.y):
			if(can_move(2)):
				move(2)
			else:
				# Push player back
				body.move_back()
		# Down
		elif(player_pos.y < pos.y):
			if(can_move(3)):
				move(3)
			else:
				# Push player back
				body.move_back()
	else:
		print("----> " + str(body.get_name()))

var SOLID_TILES = {
	WORLD = [1,3,5],
	ENTITIES = [0,1,2,3]
}

func can_move(direction):
	var world_tilemap = get_parent().get_parent().get_node("world")
	var entities_tilemap = get_parent().get_parent().get_node("entities")
	var cell_pos = world_tilemap.world_to_map(get_pos())
	print("Cell Pos: " + str(cell_pos))
	
	var world_tile_id
	var entities_tile_id
	# Left
	if(direction == 0):
		var new_pos = Vector2(cell_pos.x - 1, cell_pos.y)
		world_tile_id = world_tilemap.get_cellv(new_pos)
		entities_tile_id = entities_tilemap.get_cellv(new_pos)
	# Right
	elif(direction == 1):
		var new_pos = Vector2(cell_pos.x + 1, cell_pos.y)
		world_tile_id = world_tilemap.get_cellv(new_pos)
		entities_tile_id = entities_tilemap.get_cellv(new_pos)
	# Up
	elif(direction == 2):
		var new_pos = Vector2(cell_pos.x, cell_pos.y - 1)
		world_tile_id = world_tilemap.get_cellv(new_pos)
		entities_tile_id = entities_tilemap.get_cellv(new_pos)
	# Down
	elif(direction == 3):
		var new_pos = Vector2(cell_pos.x, cell_pos.y + 1)
		world_tile_id = world_tilemap.get_cellv(new_pos)
		entities_tile_id = entities_tilemap.get_cellv(new_pos)
	
	for tile in SOLID_TILES["WORLD"]:
		if(tile == world_tile_id):
			return false
	
	for tile in SOLID_TILES["ENTITIES"]:
		if(tile == entities_tile_id):
			return false
	
	return true

func _on_Area2D_area_enter( area ):
	print("----xxx > " + str(area.get_name()))
	if(previous_pos != null):
		set_pos(previous_pos)
	pass # replace with function body
