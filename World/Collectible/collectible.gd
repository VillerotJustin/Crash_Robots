extends Area2D

@export_category("References")
@export_enum("Drill", "Gun", "Dash", "Part_1", "Part_2", "Part_3", "Part_4", "Part_5") var collectible_type: String = "Part_5"
@export var sprite_list: Array[String] = [
	"res://World/Collectible/Assets/Drill_Collectible.png",
	"res://World/Collectible/Assets/Gun_Placeholder.png",
	"res://World/Collectible/Assets/Dash_Placeholder.png",
	"res://World/Collectible/Assets/Ship_Part_1.png",
	"res://World/Collectible/Assets/Ship_Part_2.png",
	"res://World/Collectible/Assets/Ship_Part_3.png",
	"res://World/Collectible/Assets/Ship_Part_4.png",
	"res://World/Collectible/Assets/Ship_Part_5.png"
]
@export var sprite: Sprite2D

func _ready() -> void:
	sprite = $Sprite2D
	_set_sprite_texture()
	connect("area_entered", Callable(self, "_on_area_entered"))

func _set_sprite_texture() -> void:
	var index:int
	match collectible_type:
		"Drill": index = 0
		"Gun": index = 1
		"Dash": index = 2
		"Part_1": index = 3
		"Part_2": index = 4
		"Part_3": index = 5
		"Part_4": index = 6
		"Part_5": index = 7
		_: index = -1

	if index >= 0 and index < sprite_list.size():
		var tex := load(sprite_list[index])
		if tex:
			sprite.texture = tex
		else:
			push_warning("Failed to load texture for collectible type: %s" % collectible_type)
	else:
		push_warning("Invalid collectible type: %s" % collectible_type)


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
			"Part_1", "Part_2", "Part_3", "Part_4", "Part_5":
				player.collect_part(collectible_type)
				HUD.toggle_upgrade(collectible_type, true)
			_:
				push_warning("Invalid collectible type encountered: %s" % collectible_type)
		
		HUD.show_message("Collected %s!" % collectible_type)
		queue_free()
