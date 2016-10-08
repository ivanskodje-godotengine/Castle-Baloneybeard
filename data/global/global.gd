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
		total = 2, # TODO: Load this in
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
		HEART = 0
	},
	BALONEY = {
		CURRENT = 0,
		TOTAL = 0
	},
	TOOL = {
		WATER = 0,
		FIRE = 0
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
		SUBMERGED_BLOCK = 11,
	}
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
func play_sound(sound):
	if(sound == SOUND.ITEM_CHANGED):
		print("play_sound: SOUND.ITEM_CHANGE")
	elif(sound == SOUND.ITEM_SELECTED):
		print("play_sound: SOUND.ITEM_SELECTED")

# Play Music
func play_music(music):
	if(music == MUSIC.MENU):
		print("play_music: MUSIC.MENU")
# ---------------