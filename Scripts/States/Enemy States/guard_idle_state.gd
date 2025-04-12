# Random wandering to find player
extends State
class_name GuardIdleState

var wander_timer = 0.0				# length of current wandering
var wander_interval = 3.0 			# time between wandering
var wander_duration = 2.0 			# total amount of time to wandered
var is_wandering = false 			# false = standing still
var wander_direction = Vector3.ZERO # Constant x, y, z found in Godot
var view_distance = 15.0 			# how far the enemy scum can see
var view_angle = 45.0 				# view cone - left/right angle
var sprite = "AnimatedSprite3D"

# Calls parent func and plays sprite's "idle" animation. 
func enter():
	super.enter()
	character.get_node(sprite).play("idle")
	wander_timer = 0.0
	is_wandering = false
	
func physics_update(delta):
	# Update wander timer
	wander_timer += delta # increased based on the time passed since the last frame
	
	if is_wandering: # if is wandering
		if wander_timer >= wander_duration: # and if wandering for full duration or longer then
			# Stop wandering
			is_wandering = false	# standing still
			wander_timer = 0.0		# length of wandering reset
			character.get_node(sprite).play("idle")
		else: # if not fully done wandering
			# Move in the wander direction
			character.velocity.x = wander_direction.x * character.speed
			character.velocity.z = wander_direction.z * character.speed
			character.move_and_slide()
	else: # ain't wandering
		if wander_timer >= wander_interval: # is the time between wandering fulfilled? 
			# Start wandering
			is_wandering = true
			wander_timer = 0.0
			wander_direction = get_random_direction() # get a random direction
			character.get_node(sprite).play("chase") # Chase animation for wandering
			
			# Enemy faces the wander direction
			if wander_direction != Vector3.ZERO:
				character.look_at(character.global_position + wander_direction, Vector3.UP)
	
	# Check if player is in view vone
	var player = get_tree().get_first_node_in_group("player")
	if player and can_see_player(player): # if player is within enemy view cone
		return "chase" # return chase for state transition to chase_state
		
	return null

func get_random_direction():
	var rand_angle = randf_range(0, 2 * PI) # Random function between 360 degrees
	return Vector3(cos(rand_angle), 0, sin(rand_angle)).normalized() # normalize that shit on a horizontal plane
	
func can_see_player(player): # takes in player node
	# distance between player and character saved in var
	# global position gives the world-space coordinates of each character
	var to_player = player.global_position - character.global_position
	var distance = to_player.length() # straight line distance betwen the guard and player
	
	# Detection Check: Checks if player is within view distance using above var
	if distance > view_distance:
		return false # cannot see player is not within specified (15) view distance
	
	# Check if player is within view angle
	to_player = to_player.normalized()
	var forward = -character.global_transform.basis.z # enemie's forward direction
	var dot_product = forward.dot(to_player) # calcs dot product of guard frwd direction and player direction
	dot_product = clamp(dot_product, -1.0, 1.0)  # Something about cosine values and how we need to clamp them within a range just incase
	var angle_to_player = rad_to_deg(acos(dot_product)) # convert to an angle then degree
	
	# Detection Check 2: Checks if the angle to the player is within view cone
	if angle_to_player > view_angle:
		return false # cannot see player it is not within the view cone
	
	# Check if there's a clear line of sight
	var space_state = character.get_world_3d().direct_space_state # built in physics space info found in Godot game server. Object detection
	# Statements for above server query
	var query = PhysicsRayQueryParameters3D.new()
	query.from = character.global_position + Vector3(0, 1, 0) # Sets start point to eye level of guard
	query.to = player.global_position + Vector3(0, 1, 0) # Sets end point to eye level of player
	query.collision_mask = 1 # which collision mask we should check
	
	var result = space_state.intersect_ray(query) # this tells us what the ray hits
	if result and result["collider"] == player: # if it collided with a player
		return true # can see player

	return false
