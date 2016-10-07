extends Node

# Configuration
var config = {
	screen_width = 160,
	screen_height = 144,
	screen_scale = 3,
	tilesize = 16,
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