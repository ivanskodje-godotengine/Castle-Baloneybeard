extends Sprite

var timer = Timer.new()
var player = null

func _ready():
	timer = Timer.new()
	timer.set_one_shot(true)
	timer.set_wait_time(0.15)
	timer.connect("timeout", self, "_move_player")
	timer.set_name("ice_delay_timer")
	add_child(timer)

func _on_ice_body_enter( body ):
	if(body.get_name() == "player"):
		player = body
		player.set_ice(true)
		timer.start()

func _move_player():
	player.on_ice()