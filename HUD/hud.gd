extends Control

var battery_bar: TextureProgressBar
var drill_upgrade: TextureRect
var gun_upgrade: TextureRect
var dash_upgrade: TextureRect

# Called when the node enters the scene tree for the first time.
func init() -> void:
	
	# Initialize default values
	battery_bar.min_value = 0
	battery_bar.max_value = 60
	battery_bar.value = 60  # start full
	
	# Hide all upgrades by default (optional)
	drill_upgrade.visible = false
	gun_upgrade.visible = false
	dash_upgrade.visible = false


# 🔋 Update the battery bar value (0–60)
func update_battery(value: float) -> void:
	battery_bar.value = clamp(value, 0, 60)


# 💡 Toggle upgrade visibility
# Usage: toggle_upgrade("drill", true) or toggle_upgrade("gun", false)
func toggle_upgrade(upgrade_name: String, state: bool) -> void:
	match upgrade_name.to_lower():
		"drill":
			drill_upgrade.visible = state
		"gun":
			gun_upgrade.visible = state
		"dash":
			dash_upgrade.visible = state
		_:
			push_warning("Unknown upgrade: %s" % upgrade_name)
