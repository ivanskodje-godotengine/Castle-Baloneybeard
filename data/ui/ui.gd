extends CanvasLayer

# Time Label
onready var time_label = get_node("background/hbox_time/label_time_value")

# Screens
var intro_screen = preload("res://data/ui/screens/intro/intro.tscn")
var pause_screen = preload("res://data/ui/screens/pause/pause.tscn")
var time_out_screen = preload("res://data/ui/screens/time_out/time_out.tscn")
var death_screen = preload("res://data/ui/screens/death/death.tscn")
var victory_screen = preload("res://data/ui/screens/victory/victory.tscn")

func update_state():
	# Scene to display (if any)
	var scene = null
	
	# Clear previous scene(s)
	for c in get_node("screens").get_children():
		c.queue_free()
	
	# Add new scene
	if(global.current_state == global.STATE.INTRO):
		scene = intro_screen.instance()
		scene.get_node("label").set_text("Level: " + str(global.config.level.current))
	elif(global.current_state == global.STATE.PLAYING):
		get_tree().set_pause(false)
	elif(global.current_state == global.STATE.PAUSE):
		scene = pause_screen.instance()
	elif(global.current_state == global.STATE.DEATH):
		scene = death_screen.instance()
	elif(global.current_state == global.STATE.TIME_OUT):
		scene = time_out_screen.instance()
	elif(global.current_state == global.STATE.VICTORY):
		scene = victory_screen.instance()
	
	if(scene != null):
		get_node("screens").add_child(scene)
		get_tree().set_pause(true)

# Updates the keys based on a keys dictionary
func update_keys():
	var dict = global.inventory.KEYS
	if(dict.SPADE > 0):
		get_node("background/hbox_keys/Container1/key_2").show()
	else:
		get_node("background/hbox_keys/Container1/key_2").hide()
	
	if(dict.DIAMOND > 0):
		get_node("background/hbox_keys/Container/key_1").show()
	else:
		get_node("background/hbox_keys/Container/key_1").hide()
	
	if(dict.CLUB > 0):
		get_node("background/hbox_keys/Container2/key_3").show()
	else:
		get_node("background/hbox_keys/Container2/key_3").hide()
	
	if(dict.HEART > 0):
		get_node("background/hbox_keys/Container3/key_4").show()
	else:
		get_node("background/hbox_keys/Container3/key_4").hide()

func update_items():
	var dict = global.inventory.ITEMS
	if(dict.ANTI_WATER > 0):
		get_node("background/hbox_items/Container/anti_water" ).show()
	else:
		get_node("background/hbox_items/Container/anti_water").hide()
	
	if(dict.ANTI_FIRE > 0):
		get_node("background/hbox_items/Container1/anti_fire").show()
	else:
		get_node("background/hbox_items/Container1/anti_fire").hide()
	
	if(dict.ANTI_ICE > 0):
		get_node("background/hbox_items/Container2/anti_ice").show()
	else:
		get_node("background/hbox_items/Container2/anti_ice").hide()
	
	if(dict.ANTI_SLIDE > 0):
		get_node("background/hbox_items/Container3/anti_slide").show()
	else:
		get_node("background/hbox_items/Container3/anti_slide").hide()

# Updates baloney counter (There are x baloneys remaining)
func update_baloney():
	var remaining = global.inventory.BALONEY.TOTAL - global.inventory.BALONEY.CURRENT
	get_node("background/hbox_baloney/label_baloney_value").set_text(str(remaining))