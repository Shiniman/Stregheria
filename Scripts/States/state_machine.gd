extends Node
class_name StateMachine

# Var stores the character this state machine controls
var character = null

# Library of states - empty and filled will all available states
var states = {}

# Vars track the current and prevous state
var current_state = null
var previous_state = null

# State transition history vars
var transition_history = []
const MAX_HISTORY = 20

# signal will emmit whenever the state changes and provide the previous and new state names
signal state_changed(from_state, to_state)

func _ready():
	# Waits until the parent is ready
	await get_parent().ready
	character = get_parent()
	
	# Register child nodes as states by loop through all child nodes of the state machine
	for child in get_children():
		if child is State: 							# if child is a state
			states[child.name.to_lower()] = child 	# add it to the states library using the name in lower case
			child.state_machine = self 				# Sets state_machine pointer to this state machine
			child.character = character 			# the new character = the character object that controls the new state
	
	# Set initial State
	if states.has("idle"):				# does it have an idle?
		change_state("idle") 			# if yes then set it idle as initial state
	elif states.size() > 0: 			# if not
		change_state(states.keys()[0]) 	# set it to the first available state saved in the array

func _process(delta): 					# delta = called every frame
	if current_state != null: 			# if there's an active state
		current_state.update(delta) 	# call its update method (og state.gd method overridden by each state)
		
		# Check for transitions
		var new_state = current_state.get_transition()
		if new_state != null and new_state != current_state.name.to_lower(): # If the state wants to be changed and isn't the
			change_state(new_state)											 # same state that's currently set then change it

func _physics_process(delta):
	# If there's an active state call its physics_update method (og state.gd method overridden by each state)
	if current_state != null:
		# Stores and processes the return value provided by the physics_update metho
		var new_state = current_state.physics_update(delta)
		
		# If a state name is returned, then it attempts to transition to the new state
		if new_state is String and new_state.length() > 0:
			# Convert to lowercase for consistency
			new_state = new_state.to_lower()
			# Only change if it's a different state
			if new_state != current_state.name.to_lower():
				# Debug statement: Mentions what state we're trying to transition to
				print("State machine transitioning to: ", new_state)
				change_state(new_state)

# Forward input events to the current state
func _unhandled_input(event):
	if current_state != null:
		var new_state = current_state.handle_input(event)
		if new_state is String and new_state.length() > 0:
			new_state = new_state.to_lower()
			if new_state != current_state.name.to_lower():
				print("State machine transitioning from intput to: ", new_state)
				change_state(new_state)

# Function handles changing states
func change_state(new_state_name: String):
	# Ensure the state transition requested exists
	if !states.has(new_state_name.to_lower()): # prints error if state does not exist
		push_error("'State '" + new_state_name + "' not found in state machine")
		return false
		
	# Get the new state node from the library using the name
	var new_state = states[new_state_name.to_lower()]
	
	# Exit the current state before switching
	if current_state != null:
		current_state.exit()
		
	# Records/stores current state for history later
	previous_state = current_state
	
	# Enter new state and saves store snew state - New current
	current_state = new_state
	current_state.enter()
	
	# Log transition - Uses above vars to log
	record_transition(previous_state.name if previous_state else "none", current_state.name)
	
	# Emit signal for state change
	emit_signal("state_changed", previous_state.name if previous_state else "none", current_state.name)
	
	return true # it worked

# Function creates a new arraylist library with state transition information
func record_transition(from_state, to_state):
	transition_history.append({
		"from": from_state,
		"to": to_state,
		"time": Time.get_ticks_msec()
	})
	
	# Limits it and pops_front() fucntion pops the oldest entry instead of the newest entry
	if transition_history.size() > MAX_HISTORY:
		transition_history.pop_front()

# Function returns the entire trasition history array
func get_transition_history():
	return transition_history

# Returns the name of the current state
func get_current_state_name():
	if current_state:
		return current_state.name
	return "none"
