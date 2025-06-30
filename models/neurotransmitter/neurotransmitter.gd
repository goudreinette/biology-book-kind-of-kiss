extends Node3D

@export var speed = 3

func _process(delta):
	translate(Vector3(0,-speed * delta, 0))
