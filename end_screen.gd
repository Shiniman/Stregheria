extends Control

# UI Node References
@onready var status_label = $Panel/VBoxContainer/StatusLabel
@onready var score_value = $Panel/VBoxContainer/Stats/ScoreRow/ScoreValue
@onready var kills_value = $Panel/VBoxContainer/Stats/KillsRow/KillsValue
@onready var rings_value = $Panel/VBoxContainer/Stats/RingsRow/RingsValue
@onready var total_value = $Panel/VBoxContainer/TotalRow/TotalValue

# Track player victory state
var victory = false
var bonus_score = 0 # if final lvl is completed additional score

func _ready():
	# Make mouse visible again
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# Get victory status from Global
	victory = Global.victory_status
	
	# Update UI based on victory status
	if victory:
		status_label.text = "VICTORY"
		status_label.add_theme_color_override("font_color", Color(0.2, 0.8, 0.2))
		bonus_score = 100
	else:
		status_label.text = "DEFEAT"
		status_label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))
	
	# Update stats display
	update_stats()
	
func update_stats():
	# Display score
	score_value.text = str(Global.player_score)
	
	# Display kills
	kills_value.text = str(Global.enemies_killed)
	
	# Display ring collection
	rings_value.text = str(Global.collected_rings.size())
	
	# Calc total score
	var total_score = Global.player_score + bonus_score

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/level_1.tscn")


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menu/main_menu.tscn")
	print("Main Menu pressed")
