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

var inventory = INVENTORY.duplicate(true)

func reset_inventory():
	inventory = INVENTORY.duplicate(true)

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
		self.add_child(sfx)

	if(sfx != null):
		if(sound == SOUND.ITEM_CHANGED):
			play_sfx("menu_move")
		elif(sound == SOUND.ITEM_SELECTED):
			play_sfx("menu_select")
		elif(sound == SOUND.MENU_TITLE_START):
			play_sfx("menu_start_from_title_screen")
		elif(sound == SOUND.PLAYER_MOVE):
			play_sfx("player_movement")
		elif(sound == SOUND.PLAYER_SWIM):
			play_sfx("player_swimming")
		elif(sound == SOUND.PLAYER_HIT_WALL):
			play_sfx("player_hit_solid_wall")
		elif(sound == SOUND.PLAYER_PICKUP_ITEM):
			play_sfx("player_pickup_item")
		elif(sound == SOUND.PLAYER_PICKUP_BALONEY):
			play_sfx("player_pickup_baloney")
		elif(sound == SOUND.PLAYER_PICKUP_SPECIAL):
			play_sfx("player_pickup_special_item")
		elif(sound == SOUND.PLAYER_PUSH_BLOCK):
			play_sfx("player_push_block")
		elif(sound == SOUND.PLAYER_PUSH_BLOCK_IN_WATER):
			play_sfx("player_push_block_in_water")
		elif(sound == SOUND.PLAYER_OPEN_DOOR):
			play_sfx("door_open")
		elif(sound == SOUND.PLAYER_VICTORY):
			play_sfx("player_victory")
		elif(sound == SOUND.PLAYER_DEATH):
			play_sfx("player_death")
		elif(sound == SOUND.SPECIAL):
			play_sfx("player_special")

func play_sfx(audio_node):
	sfx.find_node(audio_node).play()

# Play Music
var music = null

func play_menu_music():
	if(music != null):
		music.queue_free()

	music = load("res://data/SFX/music/music_menu.tscn").instance()
	music.set_name("menu_music")
	get_parent().add_child(music)
	update_music_volume()
	music.play()


func play_level_music(): # TODO: Replace this horrid "music" system. Each level/scene should own the music that is being played.
	if(music != null):
		music.queue_free()
		music = null

	music = load("res://data/SFX/music/music.tscn").instance()
	music.set_name("game_music")
	get_parent().add_child(music)
	update_music_volume()
	music.play()

func stop_music():
	if(music != null):
		music.stop()
		music.queue_free()
		music = null


# TODO: Fixme, does not work as expected. Want to set the volume in percentage!!
func update_music_volume():
	if(music != null):
		var volume = float(config.music.current) / config.music.total
		var volume_in_percent = linear2db(volume)
		music.set_volume_db(volume_in_percent)


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
