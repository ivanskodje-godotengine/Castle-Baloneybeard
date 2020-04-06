extends Sprite

func _on_ice_body_enter( body ):
	if(body.get_name() == "player"):
		body.slide_on_ice()

