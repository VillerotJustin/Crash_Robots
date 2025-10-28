extends StaticBody2D

@export_category("Teleporters")
@export var teleporter_inside: Area2D
@export var teleporter_outside: Area2D
@export var entry_point: Marker2D
@export var exit_point: Marker2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if teleporter_inside != null:
		teleporter_inside.body_entered.connect(_on_entry)
	
	if teleporter_outside != null:
		teleporter_outside.body_entered.connect(_on_exit)


func _on_entry(_body: Node) -> void:
	if _body is Player:
		_body.global_position = entry_point.global_position
		_body.stop_battery_timer()


func _on_exit(_body: Node) -> void:
	if _body is Player:
		_body.global_position = exit_point.global_position
		_body.start_battery_timer()
	
	
