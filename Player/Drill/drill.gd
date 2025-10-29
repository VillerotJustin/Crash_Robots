extends Area2D

class_name Drill

@export var drill_cooldown: float = 1
var last_drill: float

var drilling:bool = false
var target_rock:Rock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_drill = Time.get_unix_time_from_system()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if drilling and (target_rock != null) and (Time.get_unix_time_from_system() - drill_cooldown > last_drill):
		target_rock.take_damage(1)
		last_drill = Time.get_unix_time_from_system()
		print("damage_rock")

func _on_body_entered(body: Node2D) -> void:	
	#print(_body.name)
	if body is Rock:
		drilling = true
		target_rock = body

func _on_body_exited(body: Node2D) -> void:
	if body is Rock:
		drilling = false
		target_rock = null
