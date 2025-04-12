extends CanvasLayer

var mana = 500
var current_weapon = "hand"
var time_since_last_shot = 0.0 # cooldown
var fire_rate = 1.0 #speed
var can_shoot = true

# Mana Cost Vars
const HAND_MANA_COST = 0
const FIRE_MANA_COST = 10
const ICE_MANA_COST = 15
const LIGHTENING_MANA_COST = 25

@onready var ring_icons = {
	"fire": $Control/WeaponIndicator/FireRingIcon,
	"ice": $Control/WeaponIndicator/IceRingIcon,
	"lightening": $Control/WeaponIndicator/LighteningRingIcon
}

#_ready is done once
func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)
	$AnimatedSprite2D.play(current_weapon + "_idle")
	
	#Initialise UI Elements
	$Control/Margins/Stats/ManaRow/ManaBar.max_value = 500
	$Control/Margins/Stats/ManaRow/ManaBar.value = mana
	
	Global.connect("rings_updated", _on_rings_updated)
	Global.connect("score_updated", _on_score_updated)
	
	_on_rings_updated() # Initial update
	$Control/Control/VBoxContainer/SCORE.text = str(Global.player_score)
	update_weapon_indicator() # Ring Highlight
	
func _on_rings_updated():
	# Hide ring icons
	for icon in ring_icons.values():
		icon.visible = false
		icon.modulate = Color(0.5, 0.5, 0.5)  # Dim all
		
	# Show collected rings and highlight the current one
	for i in range(Global.collected_rings.size()):
		var ring = Global.collected_rings[i]
		if ring in ring_icons:
			ring_icons[ring].visible = true
			if i == Global.current_ring_index:
				ring_icons[ring].modulate = Color(1, 1, 1) # Highlight
			else:
				ring_icons[ring].modulate = Color(0.5, 0.5, 0.5_) # Dim the others

# _process is run every frame
func _process(delta):
	time_since_last_shot += delta # delta = framerate
	can_shoot = time_since_last_shot >= (1.0 / fire_rate)
	
	# base hand uses no mana
	if current_weapon != "hand" and mana <= 0:
		current_weapon = "hand"
		$AnimatedSprite2D.play("hand_idle")
		update_weapon_indicator()
	
	# Weapon Switching
	var weapon_changed = false
	if Input.is_action_just_pressed("weapon_1"): # 1 Num Key
		current_weapon = "hand"
		weapon_changed = true
		#$AnimatedSprite2D.play("hand_idle")
		update_weapon_indicator()
	elif Input.is_action_just_pressed("weapon_2") and "fire" in Global.collected_rings: # 2 Num Key
		current_weapon = "fire"
		weapon_changed = true
		#$AnimatedSprite2D.play("fire_idle")
		update_weapon_indicator()
	elif Input.is_action_just_pressed("weapon_3") and "ice" in Global.collected_rings: # 3 Num Key
		current_weapon = "ice"
		weapon_changed = true
		#$AnimatedSprite2D.play("ice_idle")
		update_weapon_indicator()
	elif Input.is_action_just_pressed("weapon_4") and "lightening" in Global.collected_rings: # 4 Num Key
		current_weapon = "lightening"
		weapon_changed = true
		#$AnimatedSprite2D.play("lightening_idle")
		update_weapon_indicator()
	
	# Only update if weapon changed
	if weapon_changed:
		$AnimatedSprite2D.play(current_weapon + "_idle")
		update_weapon_indicator()
	
	if Input.is_action_pressed("attack") and can_shoot:
		var mana_cost = get_weapon_mana_cost(current_weapon)
		
		# Only allow attacking if there's enough mana
		if mana >= mana_cost:
			if current_weapon == "hand":
				$AnimatedSprite2D.play("hand_attack")
			else:
				$AnimatedSprite2D.play(current_weapon + "_attack")
			
			time_since_last_shot = 0.0
			
			# Subtract the appropriate mana cost based on weapon type
			mana -= mana_cost
			update_mana_bar()
		else:
			pass
	
	match current_weapon:
		"fire":
			fire_rate = 3.0
		"ice":
			fire_rate = 3.0
		"lightening":
			fire_rate = 5.0
		"hand":
			fire_rate = 3.0
			
	update_player_health()
	
# Get mana cost for weapon type
func get_weapon_mana_cost(weapon_type):
	match weapon_type:
		"hand":
			return HAND_MANA_COST
		"fire":
			return FIRE_MANA_COST
		"ice":
			return ICE_MANA_COST
		"lightening":
			return LIGHTENING_MANA_COST

func _on_AnimatedSprite2D_animation_finished():
	$AnimatedSprite2D.play(current_weapon + "_idle")

# Update Health Bar
func update_player_health():
	if get_parent().has_method("get_health"):
		var health = get_parent().get_health()
		$Control/Margins/Stats/HealthRow/HealthBar.value = health
	elif get_parent().has_variable("player_health"):
		$Control/Margins/Stats/HealthRow/HealthBar.value = get_parent().player_health

func update_mana_bar():
	$Control/Margins/Stats/ManaRow/ManaBar.value = mana

# UI Update Active Weapon
func update_weapon_indicator():
	# First handle the base ring (hand)
	$Control/WeaponIndicator/BaseRingIcon.modulate = Color(1.0, 1.0, 1.0, 1.0) if current_weapon == "hand" else Color(0.5, 0.5, 0.5, 1.0)
	
	# Then handle collected rings
	for ring_type in Global.collected_rings:
		if ring_type in ring_icons:
			var is_active = (current_weapon == ring_type)
			ring_icons[ring_type].modulate = Color(1.0, 1.0, 1.0, 1.0) if is_active else Color(0.5, 0.5, 0.5, 1.0)
			ring_icons[ring_type].visible = true

# Update score
func _on_score_updated():
	$Control/Control/VBoxContainer/SCORE.text = str(Global.player_score)
