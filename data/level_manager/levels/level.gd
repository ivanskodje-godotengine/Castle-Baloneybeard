extends Control

# Level properties
export(int) var time = 999
export(int) var level = 999
export(int) var song = 0 setget set_music
var ui = preload("res://data/ui/ui.tscn")
var screen_overlay = preload("res://data/screen/screen.tscn") # Adds a "old school"ish effect on the screen

signal game_over()

func _ready():
	# Add UI to screen
	var ui_scene = ui.instance()
	add_child(ui_scene)
	
	var screen_scene = screen_overlay.instance()
	add_child(screen_scene)
	
	global.play_music(1)

func get_level():
	return level

func get_time():
	return time

var music = null
func set_music(new_song):
	song = new_song

func play_music():
	if(music == null):
		music = load("res://data/SFX/music/music.tscn").instance()
		add_child(music)
	
	if(song == 0):
		music.play()