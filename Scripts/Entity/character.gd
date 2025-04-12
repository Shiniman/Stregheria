extends a_Entity
class_name b_Character

# Movement properties
var speed = 5.0
const WALK_SPEED = 5.0 # Renamed to to prevent confusion
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5

# State machine
var state_machine = null
var movement_history = []
const MAX_HISTORY_SIZE = 100

const SENSITIVITY = 0.005

# Animation properties
const BOB_FREQ = 2.0 # how frequent it bobs
const BOB_AMP = 0.1 # how far does it bounce
var t_bob = 0.0 # sine wave location

# Physics properties
var gravity: float = 9.8
var direction: Vector3 = Vector3.ZERO

func _ready():
	super._ready()
	add_to_group("characters")

func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	process_movement(delta)
	
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
		
func process_movement(delta: float) -> void:
	pass
	
func get_movement_direction() -> Vector3:
	return Vector3.ZERO
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY
	
func apply_damage():
	take_damage(5.0)
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos
