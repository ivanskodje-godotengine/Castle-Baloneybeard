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
		total = 3, # TODO: Load this in
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
}

# Music
enum MUSIC { 
	MENU, 
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

# Play Music
func play_music(music):
	if(music == MUSIC.MENU):
		print("play_music: MUSIC.MENU")
# ---------------