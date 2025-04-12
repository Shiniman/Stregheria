extends State
class_name GuardDeathState

var death_animation_played = false

var sprite = "AnimatedSprite3D"

# Calls parent func and plays "dead" animation
func enter():
	super.enter()
	character.get_node(sprite).play("dead")
	character.get_node("CollisionShape3D").disabled = true # disables collision shape so you can walk through bodies
	death_animation_played = false
	Global.add_score(25)
	Global.increment_enemies_killed()

# if dead prevent looping
func update(delta):
	if !death_animation_played and character.get_node(sprite) and not character.get_node(sprite).is_playing():
		death_animation_played = true
		await get_tree().create_timer(10.0).timeout # Wait 10 Secs
		character.queue_free() # Delete
	
	return null
