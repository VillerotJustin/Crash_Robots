extends Control

@export_category("References")
@export var battery_bar: TextureProgressBar
@export var drill_upgrade: TextureRect
@export var gun_upgrade: TextureRect
@export var dash_upgrade: TextureRect
@export var label: Label
@export var label_clear_timer: Timer
@export var ship_part_1: TextureRect
@export var ship_part_2: TextureRect
@export var ship_part_3: TextureRect
@export var ship_part_4: TextureRect
@export var ship_part_5: TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if battery_bar == null:
		battery_bar = $Top_HUD/TextureProgressBar
	
	if drill_upgrade == null:
		drill_upgrade = $Top_HUD/Bonuses/Upgrade_Drill
	
	if gun_upgrade == null:
		gun_upgrade = $Top_HUD/Bonuses/Upgrade_Gun
	
	if dash_upgrade == null:
		dash_upgrade = $Top_HUD/Bonuses/Upgrade_Dash
		
	if label == null:
		label = $VBoxContainer/Bottom_HUD/Label
	
	if label_clear_timer == null:
		label_clear_timer = $VBoxContainer/Bottom_HUD/Label/Timer
	
	if ship_part_1 == null:
		ship_part_1 = $VBoxContainer/Bottom_HUD/HBoxContainer/Ship_Part_1
	
	if ship_part_2 == null:
		ship_part_2 = $VBoxContainer/Bottom_HUD/HBoxContainer/Ship_Part_2
	
	if ship_part_3 == null:
		ship_part_3 = $VBoxContainer/Bottom_HUD/HBoxContainer/Ship_Part_3
	
	if ship_part_4 == null:
		ship_part_4 = $VBoxContainer/Bottom_HUD/HBoxContainer/Ship_Part_4
	
	if ship_part_5 == null:
		ship_part_5 = $VBoxContainer/Bottom_HUD/HBoxContainer/Ship_Part_5

	# --- Assign all to the global HUD singleton (autoload) ---
	HUD.battery_bar = battery_bar
	HUD.drill_upgrade = drill_upgrade
	HUD.gun_upgrade = gun_upgrade
	HUD.dash_upgrade = dash_upgrade
	HUD.label = label
	HUD.label_clear_timer = label_clear_timer
	HUD.Part_1 = ship_part_1
	HUD.Part_2 = ship_part_2
	HUD.Part_3 = ship_part_3
	HUD.Part_4 = ship_part_4
	HUD.Part_5 = ship_part_5
	HUD.init()
