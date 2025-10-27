extends CharacterBody2D

@export_category("Pistol")
@export var Bullet_Packed_Scene: PackedScene = ResourceLoader.load("res://Player/Bullet/bullet.tscn")
@export var player_center: Marker2D
@export var bullet_spawn_distance: float = 10
@export var bullet_speed: float = 500.0
@export var fire_rate: float = 0.5
var last_fire: float

@export_category("Mouvement")
@export var SPEED: float = 300.0
@export var main_camera: G_camera



func _ready() -> void:
	pass
	# TODO check / auto fill references

func get_movement_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	
func shooting():
	if Time.get_unix_time_from_system()-fire_rate < last_fire:
		return
	
	var is_shooting: bool = false
	var shooting_direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("shoot_left") and ! (Input.is_action_pressed("shoot_right") or Input.is_action_pressed("shoot_up") or Input.is_action_pressed("shoot_down")):
		is_shooting = true
		shooting_direction.x -= 1
	
	if Input.is_action_pressed("shoot_right") and ! (Input.is_action_pressed("shoot_left") or Input.is_action_pressed("shoot_up") or Input.is_action_pressed("shoot_down")):
		is_shooting = true
		shooting_direction.x += 1
	
	if Input.is_action_pressed("shoot_up") and ! (Input.is_action_pressed("shoot_left") or Input.is_action_pressed("shoot_right") or Input.is_action_pressed("shoot_down")):
		is_shooting = true
		shooting_direction.y -= 1
	
	if Input.is_action_pressed("shoot_down") and ! (Input.is_action_pressed("shoot_left") or Input.is_action_pressed("shoot_right") or Input.is_action_pressed("shoot_up")):
		is_shooting = true
		shooting_direction.y += 1
		
	if is_shooting and shooting_direction != Vector2.ZERO:
		shooting_direction = shooting_direction.normalized()
		
		var bullet: Bullet = Bullet_Packed_Scene.instantiate()
		bullet.position = player_center.position + shooting_direction * bullet_spawn_distance
		bullet.initialize(bullet_speed , shooting_direction)
		
		add_child(bullet)
		
		last_fire = Time.get_unix_time_from_system()
	

func _physics_process(_delta: float) -> void:
	# Moving the Character
	get_movement_input()
	move_and_slide()
	
	# Shooting
	shooting()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	main_camera.update_position(global_position)
