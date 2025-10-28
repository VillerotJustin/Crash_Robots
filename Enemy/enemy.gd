extends CharacterBody2D

class_name Enemy

@export_category("HP/Attack")
@export var max_HP:float = 3
var current_HP:float = 3
@export var attack_damage:float = 1

@export_category("Mouvement")
@export var SPEED:float = 0.05
@export var patrol: PathFollow2D
@export_enum("loop", "linear") var patrol_type = "loop"
var is_patroling:bool = true

func initialize(patrol_path: PathFollow2D):
	patrol = patrol_path

func _ready() -> void:
	print("EnemySpawned: ", position)
	current_HP = max_HP
	if patrol == null:
		push_warning("Enemy has no patrol path")

func patroling(delta) -> void:
	if patrol_type == "loop":
		patrol.progress_ratio += SPEED * delta
	

func _physics_process(_delta: float) -> void:
	if is_patroling:
		patroling(_delta)

	move_and_slide()
	
func die() -> void:
	# TODO add death animation
	queue_free()
	
func take_damage(amount: float) -> void:
	current_HP -= amount
	if current_HP <= 0:
		die()

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print(body.name)
	if body is Player:
		body._on_hit_box_body_entered(self)
	
