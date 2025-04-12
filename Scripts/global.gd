extends Node

# Scoring
var current_level = 1
var player_score = 0
var enemies_killed = 0

# Signals
signal rings_updated
signal score_updated

# Ring colelction
var collected_rings = [] # ring collection
var current_ring_index = -1 # Track which ring is currently active

var ring_textures = {
	"fire": preload("res://Textures/UI/FireRingIcon.png"),
	"ice": preload("res://Textures/UI/IceRingIcon.png"),
	"lightening": preload("res://Textures/UI/LighteningRingIcon.png")
}

# Track victory
var victory_status = false
var game_start_time = 0

func _ready():
	player_score = 0
	enemies_killed = 0
	current_level = 1
	collected_rings = []
	current_ring_index = -1
	victory_status = false

# Adds ring to array and prints debug information
func add_ring(ring_type: String):
	if not ring_type in collected_rings:
		collected_rings.append(ring_type)
		if current_ring_index == -1: # First ring collected
			current_ring_index = 0
		emit_signal("rings_updated")
		print("Current rings collected: ", collected_rings)

func cycle_next():
	if collected_rings.size() > 1:
		current_ring_index = (current_ring_index + 1) % collected_rings.size()
		emit_signal("rings_updated")

func cycle_prev():
	if collected_rings.size() > 1:
		current_ring_index = (current_ring_index - 1) % collected_rings.size()
		emit_signal("rings_updated")
	
func get_current_ring() -> String:
	if current_ring_index == 0:
		return "hand" # Default weapon
	current_ring_index = clamp(current_ring_index, 0, collected_rings.size()-1)
	return collected_rings[current_ring_index]

func add_score(amount: int):
	player_score += amount
	emit_signal("score_updated")

# Track enemy deaths
func increment_enemies_killed():
	enemies_killed += 1
	emit_signal("score_updated")
	
# Reset game state for new game
func reset_game():
	player_score = 0
	enemies_killed = 0
	current_level = 1
	collected_rings = []
	current_ring_index = -1
	victory_status = false
