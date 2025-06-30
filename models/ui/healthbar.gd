extends Node3D

@export var health_bar_meshes: Array[MeshInstance3D] = []

var current_health: float = 9

func update_health(health: float):
	current_health = health

func _process(delta):
	var i:float = 0
	for h in health_bar_meshes:
		h.transparency = remap(current_health, i, i+ 1.0, 1.0, 0.0)
		#print(h.transparency)
		#if i > floor(current_health) and i < ceil(current_health):
			#health_bar_meshes.
		#elif i < floor(current_health):
			#h.visible = true
		#else:
			#h.visible = false
		i+=1.0
