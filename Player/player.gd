extends CharacterBody2D


@export var SPEED: float = 300.0

func get_movement_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	
func shooting():
	var is_shooting: bool = false
	var shooting_direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_just_pressed("shoot_left") and ! (Input.is_action_just_pressed("shoot_right") or Input.is_action_just_pressed("shoot_up") or Input.is_action_just_pressed("shoot_down")):
		is_shooting = true
		shooting_direction.x -= 1
	
	if Input.is_action_just_pressed("shoot_right") and ! (Input.is_action_just_pressed("shoot_left") or Input.is_action_just_pressed("shoot_up") or Input.is_action_just_pressed("shoot_down")):
		is_shooting = true
		shooting_direction.x += 1
	
	if Input.is_action_just_pressed("shoot_up") and ! (Input.is_action_just_pressed("shoot_left") or Input.is_action_just_pressed("shoot_right") or Input.is_action_just_pressed("shoot_down")):
		is_shooting = true
		shooting_direction.y -= 1
	
	if Input.is_action_just_pressed("shoot_down") and ! (Input.is_action_just_pressed("shoot_left") or Input.is_action_just_pressed("shoot_right") or Input.is_action_just_pressed("shoot_up")):
		is_shooting = true
		shooting_direction.y += 1
		
	if is_shooting and shooting_direction != Vector2.ZERO:
		shooting_direction = shooting_direction.normalized()
		
	

func _physics_process(_delta: float) -> void:
	# Moving the Character
	get_movement_input()
	move_and_slide()
