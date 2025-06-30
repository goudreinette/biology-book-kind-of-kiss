class_name Pickup extends Area3D

@export var health_boost = 1
@export var rotation_velocity: Vector3
@export var color: Color


func _ready():
	rotation_velocity = Vector3(
		randf_range(-1, 1),
		randf_range(-1, 1),
		randf_range(-1, 1)
	)
	
func _process(delta):
	$"model".rotate(Vector3(0,1,0), delta * 3)
	
