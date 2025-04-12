# When damage is taken this state is activated and an overlay and camera shake occurs
extends State
class_name PlayerDamagedState

var stagger_time = 0.5 # amount of stagger time
var timer = 0.0 # tracks amount of time spent in damaged state
var shake_strength = 0.3 # max intensity of camera shake
var original_camera_position = Vector3.ZERO # holds cam og position

func enter():
	super.enter()
	timer = 0.0
	original_camera_position = character.camera.transform.origin # stores og cam position
	
	# Flash the damage overlay
	if character.ui_script.has_node("DamageOverlay"): # if node exists
		var overlay = character.ui_script.get_node("DamageOverlay")
		overlay.color = Color(0.8, 0, 0, 0.3) # change colour
		overlay.visible = true # make it visible

func physics_update(delta):
	timer += delta
	
	# Camera shake effect: After stagger time is completed, return to moving state
	if timer < stagger_time:
		var shake_amount = shake_strength * (1 - (timer / stagger_time)) # calcs shake amount
		var random_shake = Vector3( # random offsets
			randf_range(-1, 1) * shake_amount,
			randf_range(-1, 1) * shake_amount,
			0
		)
		# apply above stuff
		character.camera.transform.origin = original_camera_position + random_shake
		
		# Fade out the overlay over time
		if character.ui_script.has_node("DamageOverlay"):
			var overlay = character.ui_script.get_node("DamageOverlay")
			if overlay.visible:
				var alpha = lerp(0.3, 0.0, timer / stagger_time) # lerp creates smooth transition
				overlay.color.a = alpha
	else:
		# Reset camera position if above time is done
		character.camera.transform.origin = original_camera_position
		
		# Hide overlay
		if character.ui_script.has_node("DamageOverlay"):
			var overlay = character.ui_script.get_node("DamageOverlay")
			overlay.visible = false
		
		return "moving"
	
	# Knockback effect
	character.velocity *= 0.8
	character.move_and_slide()
	
	return null
