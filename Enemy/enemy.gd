extends CharacterBody2D

@export_category("HP/Attack")
@export var max_HP:float = 3
var current_HP:float = 3
@export var attack_damage:float = 1

@export_category("Mouvement")
@export var SPEED:float = 300.0
@export var patrol_checkpoints: Array[Marker2D]
@export var distance_to_checkpoint_validation:float = 10.0
var current_checkpoint_progress: int = 0



func _ready() -> void:
	current_HP = max_HP

func _physics_process(_delta: float) -> void:
	if patrol_checkpoints.size() > 0:
		var target: Vector2 = patrol_checkpoints[current_checkpoint_progress].position
		if target.length_squared() < distance_to_checkpoint_validation**2:
			current_checkpoint_progress += 1
			target = patrol_checkpoints[current_checkpoint_progress].position
		
		var direction: Vector2 = (target - position).normalized()
		
		velocity = direction * SPEED
		
	

	move_and_slide()
	
func die() -> void:
	# TODO add death animation
	queue_free()
	
func take_damage(amount: float) -> void:
	current_HP -= amount
	if current_HP <= 0:
		die()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
