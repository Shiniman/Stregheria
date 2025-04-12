extends State
class_name PlayerMovingState

func enter():
	super.enter()
	
func handle_input(event):
	# Handles Jump Input
	if event.is_action_pressed("jump") and character.is_on_floor():
		character.jump()
		
	# Handles Attack Input
	if event.is_action_pressed("attack") and character.ui_script.can_shoot:
		return "casting"
		
func physics_update(delta):
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction = (character.head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if character.is_on_floor(): # adds inertia so jump doesn't stop in mid air
		if direction:
			character.velocity.x = direction.x * character.speed # Changed from const because its based on whether shift is pressed
			character.velocity.z = direction.z * character.speed
		else: # how long it takes for a character to stop
			character.velocity.x = lerp(character.velocity.x, direction.x * character.speed, delta * 4.0)
			character.velocity.z = lerp(character.velocity.z, direction.z * character.speed, delta * 4.0)
	else:
		# Changes speed incrementally
		# initial velocity, target velocity, the % distance that is covered
		character.velocity.x = lerp(character.velocity.x, direction.x * character.speed, delta * 2.0)
		character.velocity.z = lerp(character.velocity.z, direction.z * character.speed, delta * 2.0)
	
	character.move_and_slide()
	
	# Handle Sprint
	if Input.is_action_pressed("sprint"):
		character.speed = character.SPRINT_SPEED
	else:
		character.speed = character.WALK_SPEED
		
	# Head bob
	#		time   * character speed * only bobs on the floor
	character.t_bob += delta * character.velocity.length() * float(character.is_on_floor())
	character.camera.transform.origin = character._headbob(character.t_bob)

	#FOV
	var velocity_clamped = clamp(character.velocity.length(), 0.5, character.SPRINT_SPEED * 2) # prevents velocity from spazzing out
	var target_fov = character.BASE_FOV + character.FOV_CHANGE * velocity_clamped
	#                original, target, % distance we want covered
	character.camera.fov = lerp(character.camera.fov, target_fov, delta * 8.0)
	
	# Damage handled in take_damage method in player which changes states
	
	return null
