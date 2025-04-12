# tracks what state we're in and some functions
# acts as an abstract class for statemachine class
extends Node
class_name State

# Reference to the state machine so we can communicate with it.
var state_machine = null

# Reference to the parent node Character so we have access to it in other states
var character = null

# State time tracking
var state_entered_time = 0
var state_duration = 0

func enter():
	state_entered_time = Time.get_ticks_msec()

func exit():
					# big num              - small number
	state_duration = Time.get_ticks_msec() - state_entered_time
	
func update(delta):
	pass
	
func physics_update(delta):
	pass
	
func handle_input(event):
	pass

func get_transition():
	return null
