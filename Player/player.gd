extends CharacterBody2D

class_name Player

@onready var collider: CollisionShape2D = $CollisionShape2D2

@export var winned_scene: String = "res://Menu/winned.tscn"

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
@onready var dash_timer: Timer = $DashDuration
var dash_direction:Vector2 = Vector2.ZERO
@export var main_camera: G_camera
var is_dashing:bool = false
var input_direction = Vector2.ZERO

#$CollisionShape2D.set_deferred("disabled",true)

@export_category("Timer")
@export var battery_timer:Timer
@export var hit_cooldown: float = 1.0
var last_hit: float
var spawn_point: Vector2
var body_sprite: String = "res://Player/Assets/Robot_Mort.png"

@export_category("Upgrades")
@export var drilling: bool = false
@export var gunning: bool = false
@export var dashing: bool = false
@export var Ship_Part_1: bool = false
@export var Ship_Part_2: bool = false
@export var Ship_Part_3: bool = false
@export var Ship_Part_4: bool = false
@export var Ship_Part_5: bool = false

@export_category("Drill")
@export var drill: Drill
@export var distance_from_center: float = 50

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
	if not is_dashing:
		input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * SPEED
	else :
		velocity = dash_direction * SPEED * Dash_mult
	
	if Input.is_action_just_pressed("dash") and dashing:
		print("dash")
		set_collision_mask_value(5, false)
		velocity *= Dash_mult
		dash_timer.start()
		#dash_layer.global_position *= 9999999999999
		#dash_layer.process_mode = Node.PROCESS_MODE_DISABLE1D
		#set_collision_layer_value(5, false) # Disable dashable_gap collision
	
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
	if gunning:
		shooting()
	
	# Drill
	if drilling:
		process_drill()
	
	# Update Baterry HUD
	HUD.update_battery(battery_timer.time_left)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	main_camera.update_position(global_position)

func _on_dash_end() -> void:
	print("dash_end")
	is_dashing = false
	set_collision_mask_value(5, true)
	#dash_layer.global_position = dash_layer_pos
	#dash_layer.process_mode = Node.PROCESS_MODE_PAUSABLE
	#set_collision_layer_value(5, true)

func collect_part(part_name: String):
	match part_name:
		"Part_1":
			Ship_Part_1 = true
		"Part_2":
			Ship_Part_2 = true
		"Part_3":
			Ship_Part_3 = true
		"Part_4":
			Ship_Part_4 = true
		"Part_5":
			Ship_Part_5 = true
	if Ship_Part_1 and Ship_Part_2 and Ship_Part_3 and Ship_Part_4 and Ship_Part_5:
		win()

func stop_battery_timer():
	print("stop_timer")
	battery_timer.stop()

func start_battery_timer():
	print("start_timer")
	battery_timer.start(60)

# Death
func _on_battery_timeout() -> void:
	print("timer end")
	# TODO make return animation sequence and stuff
	var new_corpse: Sprite2D = Sprite2D.new()
	new_corpse.texture = ResourceLoader.load(body_sprite)
	get_tree().current_scene.add_child(new_corpse)
	new_corpse.global_position = global_position
	
	 # TP spawnpoint
	global_position = spawn_point
	battery_timer.stop()

func _on_hit_box_body_entered(_body: Node2D) -> void:
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

func win() -> void:
	get_tree().change_scene_to_file(winned_scene)
