extends CharacterBody3D
class_name a_Entity

# Base properties for all entities in the game
var entity_id: int
var health: float = 100.0
var max_health: float = 100.0
var is_destroyed: bool = false # alive

func _ready():
	entity_id = get_instance_id()
	add_to_group("entities")
	on_ready()
	
# will be overridden
func on_ready():
	pass
	
func take_damage(amount: float, damage_source = null):
	health -= amount
	if health <= 0:
		health = 0
		die()
	
	# Log the damage event
	DataLogger.log_event("damage", {
		"entity_id": entity_id,
		"amount": amount,
		"source": damage_source,
		"remaining_health": health
	})
		
func heal(amount: float):
	health = min(health + amount, max_health)
	
func die():
	is_destroyed = true
	# Set victory status to false
	Global.victory_status = false
	
	# Log death event
	DataLogger.log_event.call("death", {
		"location: Level ": Global.current_level,
		"entity_id": entity_id,
		"position": global_transform.origin,
		"score": Global.player_score,
		"enemies_killed": Global.enemies_killed
	})
	get_tree().change_scene_to_file("res://Scenes/Menu/end_screen.tscn")
