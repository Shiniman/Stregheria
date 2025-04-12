extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(delta):
	pass

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")
	print("Start pressed")


func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/instructions.tscn")
	print("Instructions pressed")


func _on_exit_pressed() -> void:
	get_tree().quit()
