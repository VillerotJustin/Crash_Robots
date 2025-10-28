extends Area2D

@export_enum("Drill", "Gun", "Dash", "Part_1", "Part_2", "Part_3", "Part_4", "Part_5") var collectible_type = "Part_5"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.





func _on_area_entered(area: Area2D) -> void:
	print("Collectible hit")
	if area.get_parent() is Player:
		var player: Player = area.get_parent()
		match collectible_type:
			"Drill":
				player.drilling = true
				HUD.toggle_upgrade("drill", true)
			"Gun":
				player.gunning = true
				HUD.toggle_upgrade("gun", true)
			"Dash":
				player.dashing = true
				HUD.toggle_upgrade("dash", true)
			_:
				push_warning("Invalid Collectible")
				
				
