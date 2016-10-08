extends Sprite

func _on_water_body_enter( body ):
	# Informs player that he is on water on each step
	if(body.get_name() == "player"):
		body.in_water()