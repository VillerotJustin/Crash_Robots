extends Control

var battery_bar: TextureProgressBar
var drill_upgrade: TextureRect
var gun_upgrade: TextureRect
var dash_upgrade: TextureRect
var Part_1: TextureRect
var Part_2: TextureRect
var Part_3: TextureRect
var Part_4: TextureRect
var Part_5: TextureRect
var label: Label
var label_clear_timer: Timer

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
	Part_1.visible = false
	Part_2.visible = false
	Part_3.visible = false
	Part_4.visible = false
	Part_5.visible = false
	
	label_clear_timer.connect("timeout", clear_label)


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
		"part_1":
			Part_1.visible = state
		"part_2":
			Part_2.visible = state
		"part_3":
			Part_3.visible = state
		"part_4":
			Part_4.visible = state
		"part_5":
			Part_5.visible = state
		_:
			push_warning("Unknown upgrade: %s" % upgrade_name)

func show_message(message:String):
	label.text = message

func clear_label():
	label.text = ""
