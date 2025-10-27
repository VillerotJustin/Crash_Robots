extends RigidBody2D

class_name Bullet

@export var bullet_speed: float = 500.0
@export var bullet_direction: Vector2 = Vector2.UP

func initialize(speed: float, direction: Vector2):
	bullet_speed = speed
	bullet_direction = direction
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = bullet_direction * bullet_speed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
