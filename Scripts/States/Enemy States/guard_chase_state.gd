extends State
class_name GuardChaseState

var attack_range = 7.0
var sprite = "AnimatedSprite3D"

# Calls parent func and plays sprite's "chase" animation.
func enter():
	super.enter()
	character.get_node(sprite).play("chase")
	
func physics_update(delta):
	var player = get_tree().get_first_node_in_group("player") # finds player node in scene
	if not player:		# if it can't transitions back to idle state
		return "idle"	# transitions back to idle state
		
	# Calculate direction/distance to player
	var to_player = player.global_position - character.global_position
	var distance = to_player.length()
	
	# Check if guard is within attack range
	if distance <= attack_range:
		return "attack"
		
	# Move towards player
	to_player.y = 0 # No elevation so enemy will always move at y
	to_player = to_player.normalized()
	
	# Movement based on speed given
	character.velocity.x = to_player.x * character.speed
	character.velocity.z = to_player.z * character.speed
	
	# Make the enemy face the player
	character.look_at(player.global_position, Vector3.UP)
	
	character.move_and_slide()
	
	# If player is too far away, go back to idle
	if distance > 20.0:
		return "idle"
		
	return null
