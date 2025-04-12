extends Area3D

@export var ring_type: String = "fire"

func _ready():
	# Explicitly connect the signal
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node3D):
	# Check if the collided body is the player
	if body.is_in_group("player"):
		print("Collected ring:", ring_type)  # Debug
		Global.add_ring(ring_type)
		queue_free()
