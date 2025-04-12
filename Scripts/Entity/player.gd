extends b_Character
class_name c_Player

# FOV Vars
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# Mouse Cursor
var mouseState = false

#Node Reference Vars
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var ui_script = $UI
@onready var ray = $Head/Camera3D/RayCast3D # Bullet/Ray Origin

# Var holds bullet scene
var bullet = load("res://Scenes/Bullets/light_bullet.tscn")
#var fire_bullet = load()
#var ice_bullet = load()
var bullet_instance # Will hold an instance of the bullet object


# Hides mouse cursor by default
func _ready():
	super._ready()
	add_to_group("player") # Adds player to the player group
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	# Initialize player health/override entity vars
	health = 100.0
	max_health = 100.0
	
	# Initialise state machine
	state_machine = $StateMachineManager
	if state_machine:
		state_machine.character = self

func _unhandled_input(event: InputEvent) -> void:
	# Camera Controls: Obtains mouse movement and mapes it to move the camera and head
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY) # left right
		camera.rotate_x(-event.relative.y * SENSITIVITY) # up down
		# range movement between -40 - 60 degrees
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

	# Toggles cursor visiblity if ui_cancel key is pressed
	if event.is_action_pressed("ui_cancel"): #default: esc key
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		mouseState = !mouseState

		if mouseState:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	# Forward input to state machine
	if state_machine and state_machine.current_state:
		state_machine.current_state.handle_input(event)


func shoot() -> void:
	# .instantiate is a function in godot that creates an object of a scene
	bullet_instance = bullet.instantiate()
	bullet_instance.position = ray.global_position
	bullet_instance.transform.basis = ray.global_transform.basis
	get_parent().add_child(bullet_instance)
	
	# if player raycast colides with collision body of enemy that has "take_damage" func
	if ray.is_colliding() and ray.get_collider().has_method("take_damage"):
		ray.get_collider().take_damage(20.0, self) #run the take_damage() = dmg enemy

# Override the base class method and if damage is taken changes to a dif state
func take_damage(amount: float, damage_source = null) -> void:
	super.take_damage(amount, damage_source)
	print(health)
	
	# Change to damaged state when hit
	if state_machine and health > 0:
		state_machine.change_state("damaged")
	
func get_health() -> float:
	return health
