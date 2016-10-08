extends Sprite

func _on_water_body_enter( body ):
	if(body.get_name() == "player"):
		body.in_water()
	
	print("Body entered water " + str(body.get_name()))
