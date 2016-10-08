extends Sprite

func _on_water_body_enter( body ):
	if(body.get_name() == "player"):
		body.in_water()



func _on_water_body_exit( body ):
	if(body.get_name() == "player"):
		body.out_of_water()
