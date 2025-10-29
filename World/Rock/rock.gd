extends StaticBody2D

class_name Rock

@export_category("References")
@export var sprite_list: Array[String] = [
	"res://World/Rock/Assets/Roche_1.png",
	"res://World/Rock/Assets/Roche_2.png",
	"res://World/Rock/Assets/Roche_3.png",
]
@export var sprite: Sprite2D

@export_category("Health")
@export var max_health:float = 5.0
var current_health:float = 5.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite == null:
		sprite = $Sprite2D
	
	# Set random texture
	if sprite != null:
		sprite.texture = ResourceLoader.load(sprite_list[randi_range(0, sprite_list.size()-1)])
	
	current_health = max_health
	
func take_damage(ammout:float) -> void:
	current_health -= ammout
	if current_health <= 0:
		queue_free()
	
