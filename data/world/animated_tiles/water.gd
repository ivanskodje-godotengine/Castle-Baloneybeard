extends Sprite

func _ready():
	pass


func _on_water_body_enter( body ):
	if(body.get_name() == "player"):
		body.in_water()
	pass # replace with function body
