extends Sprite

func _on_fire_body_enter( body ):
	if(body.get_name() == "player"):
		body.in_fire(self)
