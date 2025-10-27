extends Camera2D

class_name G_camera

var original_position: Vector2
var tile_width: float
var tile_height: float

var last_position: Vector2

func _ready() -> void:
	original_position = global_position
	last_position = original_position
	tile_width = original_position.x * 2
	tile_height = original_position.y * 2
	
func update_position(player_global_pos: Vector2):
	#print(player_global_pos)
	# Player Infor
	var p_x_pos: float = player_global_pos.x
	var p_y_pos: float = player_global_pos.y
	
	# Player distance from center tile
	var dist_x = (p_x_pos - original_position.x)
	var dist_y = (p_y_pos - original_position.y)
	
	print("dist_x: ", dist_x, " dist_y:  ", dist_y)
	
	var tile_x: int = dist_x / (tile_width / 2)
	var tile_y: int = dist_y / (tile_height / 2)
	
	print("tile_x: ", tile_x, " tile_y:  ", tile_y)
	print("tile_width: ", tile_width, " tile_height:  ", tile_height)
	print("tile_width/2: ", tile_width/2, " tile_height/2:  ", tile_height/2)
	
	last_position = global_position
	
	var new_pos_x = tile_x * tile_width + original_position.x
	var new_pos_y = tile_y * tile_height + original_position.y
	
	
	print("new_pos_x: ", new_pos_x, " new_pos_y:  ", new_pos_y)
	
	global_position = Vector2(
		new_pos_x,
		new_pos_y
	)
