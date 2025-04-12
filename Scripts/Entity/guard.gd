extends b_Character
class_name Guard

# Animation vars
@onready var sprite = $AnimatedSprite3D
@onready var ray = $RayCast3D

func _ready():
	super._ready()
	# Add guard to the enemy node group
	add_to_group("enemy")
	
	# Override health and speed stats from character class
	health = 50.0
	max_health = 50.0
	speed = 3.0
	
	# Initialize state machine
	state_machine = $StateMachineManager
	if state_machine:
		state_machine.character = self
		# Debug Statement: Calls debug statement func
		state_machine.connect("state_changed", _on_state_changed)

# Debug Func: Prints the to and from states
func _on_state_changed(from_state, to_state):
	print("Guard state changed from ", from_state, " to ", to_state)
	
func take_damage(amount: float, damage_source = null):
	super.take_damage(amount, damage_source)
	print(health)
	
	# If health is depleted, change to death state
	if health <= 0 and state_machine:
		state_machine.change_state("death")

func shoot():
	# Function is called from the attack state
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(10.0, self)
			

# Overwrites the die function in entity.gd
# Must be overwritten to play animation
func die():
	is_destroyed = true
	
	# If state_machine exists change to death state instead removing the enemy
	if state_machine and state_machine.get_current_state_name().to_lower() != "death":
		state_machine.change_state("death")
		return
	# Log Death Event
	DataLogger.log_event.call("death", {
		"entity_id": entity_id,
		"position": global_transform.origin
	})
