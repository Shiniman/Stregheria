extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		# Set victory status
		Global.victory_status = true
		
		# Log completion
		DataLogger.log_event("game_completed", {
			"victory": true,
			"score": Global.player_score,
			"enemies_killed": Global.enemies_killed,
			"rings_collected": Global.collected_rings.size()
		})
		print(Global.victory_status)
		get_tree().change_scene_to_file("res://Scenes/Menu/end_screen.tscn")
