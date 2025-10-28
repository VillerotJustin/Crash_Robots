extends CharacterBody2D

class_name Player

@export_category("Pistol")
@export var Bullet_Packed_Scene: PackedScene = ResourceLoader.load("res://Player/Bullet/bullet.tscn")
@export var player_center: Marker2D
@export var bullet_spawn_distance: float = 10
@export var bullet_speed: float = 500.0
@export var fire_rate: float = 0.5
@export var bullet_damage: float = 1.0
var last_fire: float

@export_category("Mouvement")
@export var SPEED: float = 300.0
@export var Dash_mult: float = 10
@export var main_camera: G_camera
var is_dashing:bool = false
var input_direction = Vector2.ZERO

@export_category("Timer")
@export var battery_timer:Timer
@export var hit_cooldown: float = 1.0
var last_hit: float
var spawn_point: Vector2


@export_category("Drill")
@export var drill: Drill
@export var distance_from_center: float = 1.5

@export_category("Animation")
@export var Animator:AnimatedSprite2D

func _ready() -> void:
	if Animator==null:
		Animator=$AnimatedSprite2D
	if battery_timer == null:
		battery_timer = $Battery
		
	spawn_point = global_position
	# TODO check / auto fill references
	
	last_hit = Time.get_unix_time_from_system()

func get_movement_input():
	if !is_dashing:
		input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * SPEED
	
	if Input.is_action_just_pressed("dash"):
		velocity *= Dash_mult
		set_collision_layer_value(5, false) # Disable dashable_gap collision
	if velocity.length()>0:
		Animator.play("walk")
	else:
		Animator.play("idle")
	
func shooting():
	if Time.get_unix_time_from_system()-fire_rate < last_fire:
		return
	
	var shooting_direction: Vector2 = Input.get_vector("shoot_left", "shoot_right", "shoot_up", "shoot_down")
	shooting_direction = round(shooting_direction)
	
	if shooting_direction != Vector2.ZERO:
		shooting_direction = shooting_direction.normalized()
		
		var bullet: Bullet = Bullet_Packed_Scene.instantiate()
		bullet.position = player_center.global_position + shooting_direction * bullet_spawn_distance
		bullet.initialize(bullet_speed , shooting_direction, bullet_damage)
		
		get_tree().current_scene.add_child(bullet)
		
		last_fire = Time.get_unix_time_from_system()
	

func process_drill():
	if Input.is_action_pressed("drill") and input_direction != Vector2.ZERO:
		# Drill position
		drill.position = player_center.position + input_direction * distance_from_center
		# Drill orientation
		# Use Vector2.angle() — returns radians measured from +X axis.
		var angle_rad := input_direction.angle()
		drill.rotation = angle_rad + PI / 2
		
		drill.monitoring = true
		drill.visible = true
		
	if Input.is_action_just_released("drill"):
		drill.monitoring = false
		drill.visible = false
	

func _physics_process(_delta: float) -> void:
	# Moving the Character
	get_movement_input()
	move_and_slide()
	
	# Shooting
	shooting()
	
	# Drill
	process_drill()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	main_camera.update_position(global_position)


func _on_dash_end() -> void:
	is_dashing = false
	set_collision_layer_value(5, true)

func stop_battery_timer():
	print("stop_timer")
	battery_timer.stop()

func start_battery_timer():
	print("start_timer")
	battery_timer.start(60)

func _on_battery_timeout() -> void:
	print("timer end")
	# TODO make return animation sequence and stuff
	
	 # TP spawnpoint
	global_position = spawn_point
	battery_timer.stop()


func _on_hit_box_body_entered(body: Node2D) -> void:
		print("hit")
		if Time.get_unix_time_from_system()-hit_cooldown > last_hit:
			print("Hit detected")
			last_hit = Time.get_unix_time_from_system()

			var remaining = battery_timer.time_left - 30.0
			if remaining > 0:
				battery_timer.start(remaining) # restart with reduced time
			else:
				battery_timer.start(0.00001)
				print("Battery empty!")

			print("New time left:", remaining)
