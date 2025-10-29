extends Control

@export_category("References")
@export var Story_rect_1: TextureRect
@export var Story_rect_2: TextureRect
@export var Story_rect_3: TextureRect
@export var Story_rect_4: TextureRect
@export var Story_rect_5: TextureRect

var current_story: int = 0

@export var Scene_Path: String = "res://World/world.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Story_rect_1 = $Control/Story_1
	Story_rect_2 = $Control/Story_2
	Story_rect_3 = $Control/Story_3
	Story_rect_4 = $Control/Story_4
	Story_rect_5 = $Control/Story_5

func next_story_panel() -> void:
	current_story += 1
	match current_story:
		1: 
			Story_rect_1.visible = true
		2: 
			Story_rect_1.visible = false
			Story_rect_2.visible = true
		3: 
			Story_rect_2.visible = false
			Story_rect_3.visible = true
		4: 
			Story_rect_3.visible = false
			Story_rect_4.visible = true
		5: 
			Story_rect_4.visible = false
			Story_rect_5.visible = true
		6: 
			Story_rect_5.visible = false
			load_game()

func load_game() -> void:
	get_tree().change_scene_to_file(Scene_Path)

func _on_button_pressed() -> void:
	$Button.visible = false
	next_story_panel()
	$Timer.start()
