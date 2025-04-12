extends Area3D

func _on_body_entered(body: Node3D) -> void:
	$AnimatedSprite3D.play("default")
	# Checks if the collided body is the player
	if body.is_in_group("player"):
		# Access UI script and save it to variable
		var ui_script = body.ui_script
		
		if ui_script:
			# Increase player mana
			ui_script.mana += 100
			# Clamp value so it doesn't exceed max mana bar amount
			ui_script.mana = min(ui_script.mana, ui_script.get_node("Control/Margins/Stats/ManaRow/ManaBar").max_value)
			# Update UI
			ui_script.update_mana_bar()
			print("Mana increased by ", ui_script.mana)
			
			# Queue the mana object for deletion
			queue_free()
		else:
			print("ERROR: Could not find player ui.gd")
