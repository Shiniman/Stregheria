extends Area3D

@export var heal_amount = 50

func _on_body_entered(body: Node3D) -> void:
	$AnimatedSprite3D.play("default")
	# Checks if the collided body is the player
	if body.is_in_group("player"):
		# Get the player's entity script
		var player_entity = body as a_Entity
		if player_entity:
			# Heal player
			player_entity.heal(heal_amount)
			print("Health increased by ", heal_amount, " New health: ", player_entity.health)
			
			# Queue the health object for deletion
			queue_free()
