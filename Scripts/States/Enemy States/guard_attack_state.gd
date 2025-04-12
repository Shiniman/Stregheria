extends State
class_name GuardAttackState

var attack_cooldown = 1.5
var attack_timer = 0.0
var attack_range = 7.0
var has_attacked = false

var sprite = "AnimatedSprite3D"

# Calls parent func and resets attack flags.
func enter():
	super.enter()
	attack_timer = 0.0
	has_attacked = false
	
func physics_update(delta):
	var player = get_tree().get_first_node_in_group("player") # find player
	if not player: # if can't transition to "idle" state
		return "idle"
		
	# Calculate distance to player
	var to_player = player.global_position - character.global_position
	var distance = to_player.length()
	
	# If player moved out of range, chase them
	if distance > attack_range:
		return "chase" # switch to chase state
	
	# Make the enemy face the player
	character.look_at(player.global_position, Vector3.UP)
	
	# Attack cooldown by increasing timer
	attack_timer += delta
	
	# if the cooldown is completed
	if attack_timer >= attack_cooldown and not has_attacked:
		# Attack
		character.get_node(sprite).play("shoot")
		has_attacked = true
		
		# Check if raycast hits player
		var raycast = character.get_node("RayCast3D")
		if raycast.is_colliding() and raycast.get_collider().has_method("take_damage"): # call player function to do damage
			raycast.get_collider().take_damage(10.0, character) # do damage if it hit by calling parent func
			
	# Reset after anioimation finished
	if has_attacked and not character.get_node(sprite).is_playing():
		has_attacked = false
		attack_timer = 0.0
		character.get_node(sprite).play("idle")
	return null
