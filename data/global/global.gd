extends Node

# Configuration
var config = {
	screen_width = 160,
	screen_height = 144,
	screen_scale = 3,
	tile_size = 16,
	music = {
		current = 100,
		total = 100
	},
	level = {
		current = 1,
		total = 1,
		total_max = 6,
	}
}

# Colors dark to bright
var color = [
	"#043e00",
	"#006a00",
	"#7d8527",
	"c8c943",
]

# Direction to move
enum DIRECTION {
LEFT,
RIGHT,
UP,
DOWN,
}

# ----- GAME STATES -----
# Game States
enum STATE {
	SPLASH,
	TITLE,
	INTRO,
	PLAYING,
	PAUSE,
	DEATH,
	TIME_OUT,
	VICTORY,
	CREDITS,
}

var current_state = STATE.INTRO

# Time in the level
var total_time = 0
# ----------------------


# ----- PLAYER -----
# Time between moving
var player_speed = 0.25

# Player Inventory
const INVENTORY = {
	KEYS = {
		DIAMOND = 0,
		SPADE = 0,
		CLUB = 0,
		HEART = 0,
	},
	ITEMS = {
		ANTI_WATER = 0,
		ANTI_FIRE = 0,
		ANTI_ICE = 0,
		ANTI_SLIDE = 0,
	},
	BALONEY = {
		CURRENT = 0,
		TOTAL = 0,
	},
	TOOL = {
		WATER = 0,
		FIRE = 0,
	},
}

var inventory = INVENTORY

func reset_inventory():
	inventory = INVENTORY

# ----------------------------

# Entities and their ID
var ENTITIES = {
	DOOR = {
		HEART = 0,
		CLUB = 1,
		SPADE = 2,
		DIAMOND = 3,
	},
	KEY = {
		HEART = 4,
		CLUB = 5,
		SPADE = 6,
		DIAMOND = 7,
	},
	BALONEY = 8,
	BLOCK = {
		SANDWICH = 9,
		PUSHABLE_BLOCK = 10,
		FIRE = 11,
	},
	ITEM = {
		ANTI_FIRE = 12,
		ANTI_ICE = 13,
		ANTI_WATER = 14,
		ANTI_SLIDE = 15,
	}
}

var WORLD = {
	FLOOR = {
		FLOOR_A = 0,
		FLOOR_B = 2,
		FLOOR_C = 4
	},
	WALL = {
		WALL_A = 1,
		WALL_B = 3,
		WALL_C = 5,
	},
	WATER = 6,
	SUBMERGED_BLOCK = 7,
	ICE = 8,
	SLIDER = 9,
}

var ENEMIES = {
	PATROL = 0,
}

var EXTRA = {
	SPAWN = 0,
	PATROL = 1,
}


# Fill in tile IDs for solid tiles
var SOLID_TILES = {
	WORLD = [1,3,5],
	ENTITIES = [0,1,2,3,10]
}



# ---- AUDIO ----
# Sounds
enum SOUND {
	ITEM_CHANGED,
	ITEM_SELECTED,
	PLAYER_MOVE,
	PLAYER_SWIM,
	PLAYER_HIT_WALL,
	PLAYER_PICKUP_ITEM,
	PLAYER_PICKUP_BALONEY,
	PLAYER_PICKUP_SPECIAL,
	PLAYER_PUSH_BLOCK,
	PLAYER_PUSH_BLOCK_IN_WATER,
	PLAYER_OPEN_DOOR,
	PLAYER_VICTORY,
	PLAYER_DEATH,
	MENU_TITLE_START,
	SPECIAL,
}

# Music
enum MUSIC { 
	MENU,
	LEVEL1,
}

# Play sound
var sfx = null
func play_sound(sound):
	if(sfx == null):
		sfx = load("res://data/SFX/SFX.tscn").instance()
	
	if(sfx != null):
		if(sound == SOUND.ITEM_CHANGED):
			sfx.play("menu_move")
		elif(sound == SOUND.ITEM_SELECTED):
			sfx.play("menu_select")
		elif(sound == SOUND.MENU_TITLE_START):
			sfx.get_node("secondary_sfx").play("menu_start_from_title_screen")
		elif(sound == SOUND.PLAYER_MOVE):
			sfx.get_node("movement").play("player_movement")
		elif(sound == SOUND.PLAYER_SWIM):
			sfx.get_node("movement").play("player_swimming")
		elif(sound == SOUND.PLAYER_HIT_WALL):
			sfx.play("player_hit_solid_wall")
		elif(sound == SOUND.PLAYER_PICKUP_ITEM):
			sfx.play("player_pickup_item")
		elif(sound == SOUND.PLAYER_PICKUP_BALONEY):
			sfx.play("player_pickup_baloney")
		elif(sound == SOUND.PLAYER_PICKUP_SPECIAL):
			sfx.play("player_pickup_special_item")
		elif(sound == SOUND.PLAYER_PUSH_BLOCK):
			sfx.play("player_push_block")
		elif(sound == SOUND.PLAYER_PUSH_BLOCK_IN_WATER):
			sfx.play("player_push_block_in_water")
		elif(sound == SOUND.PLAYER_OPEN_DOOR):
			sfx.play("door_open")
		elif(sound == SOUND.PLAYER_VICTORY):
			sfx.play("player_victory")
		elif(sound == SOUND.PLAYER_DEATH):
			sfx.play("player_death")
		elif(sound == SOUND.SPECIAL):
			sfx.get_node("secondary_sfx").play("player_special")

# Play Music
var music = null
func play_music(song, new = false):
	if(music != null):
		if(music.get_name() == "game_music" && song == 1 && !new):
			return
		music.queue_free()
	
	if(song == 0):
		music = load("res://data/SFX/music/music_menu.tscn").instance()
		music.set_name("menu_music")
	elif(song == 1):
		music = load("res://data/SFX/music/music.tscn").instance()
		music.set_name("game_music")
	
	get_parent().add_child(music)
	update_music_volume()
	music.play()

func stop_music():
	if(music != null):
		music.stop()
		music = null

func update_music_volume():
	if(music != null):
		var volume_in_percent = float(config.music.current) / config.music.total
		music.set_volume(volume_in_percent)


# File Manager
const FILE_MANAGER = preload("res://data/file_manager.gd")

func load_data():
	var total_levels = FILE_MANAGER.new().get_total_levels()
	
	# If we get false, it means no previous levels stored
	if(!total_levels):
		FILE_MANAGER.new().set_total_levels(1) # Set access to level 1
		config.level.total = 1
	else:
		config.level.total = total_levels

func save_data():
	FILE_MANAGER.new().set_total_levels(config.level.total)