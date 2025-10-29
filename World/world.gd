extends Node2D

@export_category("References")
@export var collectible_packed_scene: PackedScene = ResourceLoader.load("res://World/Collectible/collectible.tscn")
@export var ship_part_locations: Array[Marker2D] # Give 5 or more and choose random
@export var upgrade_locations: Array[Marker2D] # In order (Drill, Gun, Dash)
@export var enemy_spawn_points: Array[Marker2D]
@export var enemy_scene: PackedScene

var collectible_spawned: bool = false
var enemy_spawned: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# -------------------- ENEMY SPAWNING --------------------
func spawn_enemies() -> void:
	if enemy_spawn_points.is_empty():
		print("No Enemy spawn points found.")
		return
	
	for spawn_point: Marker2D in enemy_spawn_points:
		var path_follow: PathFollow2D = null

		if spawn_point and spawn_point.get_child_count() > 0:
			var first_child = spawn_point.get_child(0)
			if first_child and first_child.get_child_count() > 0:
				var second_child = first_child.get_child(0)
				if second_child is PathFollow2D:
					path_follow = second_child
				
		if path_follow == null:
			push_warning("No valid PathFollow2D under %s. Skipping enemy spawn." % spawn_point.name)
			continue
			
		var new_enemy: Enemy = enemy_scene.instantiate()
		new_enemy.initialize(path_follow)
		
		path_follow.rotates = false
		path_follow.add_child(new_enemy)
		new_enemy.global_rotation = 0

# -------------------- SHIP PART SPAWNING --------------------
func spawn_ship_parts() -> void:
	if ship_part_locations.size() < 5:
		push_warning("Not enough ship part markers! Need at least 5.")
		return

	# Pick 5 unique random indices
	var random_indices := []
	while random_indices.size() < 5:
		var idx = randi() % ship_part_locations.size()
		if idx not in random_indices:
			random_indices.append(idx)
	
	var part_names = ["Part_1", "Part_2", "Part_3", "Part_4", "Part_5"]

	for i in range(5):
		var marker: Marker2D = ship_part_locations[random_indices[i]]
		var part_collectible: collectible = collectible_packed_scene.instantiate()
		part_collectible.collectible_type = part_names[i]
		part_collectible._set_sprite_texture()
		get_tree().current_scene.add_child(part_collectible)
		part_collectible.global_position = marker.global_position

# -------------------- UPGRADE SPAWNING --------------------
func spawn_upgrades() -> void:
	if upgrade_locations.size() < 3:
		push_warning("Not enough upgrade markers! Need at least 3 (Drill, Gun, Dash).")
		return

	var types = ["Drill", "Gun", "Dash"]

	for i in range(3):
		var marker: Marker2D = upgrade_locations[i]
		var upgrade: collectible = collectible_packed_scene.instantiate()
		upgrade.collectible_type = types[i]
		upgrade._set_sprite_texture()
		get_tree().current_scene.add_child(upgrade)
		upgrade.global_position = marker.global_position

# -------------------- MAIN PROCESS --------------------
func _process(_delta: float) -> void:
	if not enemy_spawned:
		spawn_enemies()
		enemy_spawned = true
		
	if not collectible_spawned:
		spawn_upgrades()
		spawn_ship_parts()
		collectible_spawned = true
