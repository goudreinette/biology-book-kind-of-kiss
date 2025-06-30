extends Node3D

@export var color: Color


func _ready():
	var material = $CPUParticles3D.mesh.get_material()
	material.albedo_color = color
	await get_tree().create_timer(5).timeout
	queue_free()
	#$CPUParticles3D.color = color
