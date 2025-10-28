extends Node2D

@export_category("References")
@export var enemy_spawn_points: Array[Marker2D]
@export var enemy_scene: PackedScene
var enemy_spawned: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func spawn_enemies() -> void:
	if enemy_spawn_points.size() <= 0:
		print("No Enemy to spawn")
		return
	
	for spawn_point: Marker2D in enemy_spawn_points:
		# Building patrol list
		
		var path_follow: PathFollow2D = null

		if spawn_point and spawn_point.get_child_count() > 0:
			var first_child = spawn_point.get_child(0)
			if first_child and first_child.get_child_count() > 0:
				var second_child = first_child.get_child(0)
				if second_child is PathFollow2D:
					path_follow = second_child
				
		if path_follow == null:
			push_warning("No enemy path can't instanciate")
			continue
			
		var new_enemy: Enemy = enemy_scene.instantiate()
		new_enemy.initialize(path_follow)
		
		path_follow.rotates = false
		path_follow.add_child(new_enemy)
		
		new_enemy.global_rotation = 0
				

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (!enemy_spawned):
		spawn_enemies()
		enemy_spawned = true
		
