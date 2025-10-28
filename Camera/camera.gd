extends Camera2D

class_name G_camera

var original_position: Vector2
var tile_width: float
var tile_height: float

var last_position: Vector2

func _ready() -> void:
	original_position = global_position
	last_position = original_position

	# If tile size is not explicitly set, assume viewport size
	tile_width = get_viewport_rect().size.x
	tile_height = get_viewport_rect().size.y

	print("Camera ready. Tile size: ", tile_width, "x", tile_height)
	
func update_position(player_global_pos: Vector2):
	# Calculate which screen/tile the player is in
	var tile_x:int = round((player_global_pos.x - original_position.x) / tile_width)
	var tile_y:int = round((player_global_pos.y - original_position.y) / tile_height)

	# Calculate camera’s new snapped position
	var new_pos_x = original_position.x + tile_x * tile_width
	var new_pos_y = original_position.y + tile_y * tile_height
	var new_pos = Vector2(new_pos_x, new_pos_y)

	# Only move if camera actually changes tile
	if new_pos != last_position:
		global_position = new_pos
		last_position = new_pos
		print("Camera moved to tile (", tile_x, ",", tile_y, ") at pos: ", new_pos)
