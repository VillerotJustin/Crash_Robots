extends Area2D

class_name Bullet

@export var bullet_speed: float = 500.0
@export var bullet_direction: Vector2 = Vector2.UP

func initialize(speed: float, direction: Vector2):
	bullet_speed = speed
	bullet_direction = direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	position = position + bullet_direction * bullet_speed * _delta

func die():
	# print("projectile end")
	# TODO add end particle
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()


func _on_body_entered(_body: Node) -> void:
	# Process colision
	# print("hit: ", _body.name)
	# TODO Add Enemy check
	die()
	
	
