extends Node3D


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		Global.current_level = 2
		print("Current level: ", Global.current_level)
		get_tree().change_scene_to_file("res://Scenes/Levels/level_2.tscn")

		Global.add_score(15)
