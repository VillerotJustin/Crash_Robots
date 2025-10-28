extends Control

@export_category("References")
@export var battery_bar: TextureProgressBar
@export var drill_upgrade: TextureRect
@export var gun_upgrade: TextureRect
@export var dash_upgrade: TextureRect

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
		
	HUD.battery_bar = battery_bar
	HUD.drill_upgrade = drill_upgrade
	HUD.gun_upgrade = gun_upgrade
	HUD.dash_upgrade = dash_upgrade
	HUD.init()
	
