extends State
class_name PlayerCastingState

var cast_time = 0.3
var timer = 0.0

# Call parent func and reset timers and call shoot function found in player.gd
func enter():
	super.enter()
	timer = 0.0
	character.shoot()

func physics_update(delta):
	timer += delta # timer increase
	
	# After casting time, return to moving state
	if timer >= cast_time:
		return "moving"
		
	# Still allow movement while casting
	if Input.is_action_just_pressed("attack") and character.ui_script.can_shoot:
		# Reset timer to continue casting
		timer = 0.0
		character.shoot()
	
	# Handle movement (same as moving state cause running and shooting is fun)
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
	
	return null
