class_name TrackModule extends Node3D


@onready var end = $end

#@export var props: Array[PackedScene] = []
@export var red_blood_cell: PackedScene

#
#const speed = 3
#
func _ready():
	var cell: Node3D = red_blood_cell.instantiate()
	cell.global_position = end.global_position
	add_child(cell)



#func _process(delta):
	#translate(Vector3(delta*-speed,0,0))
	#
	#if position.x < -3:
		#position.x = 3
