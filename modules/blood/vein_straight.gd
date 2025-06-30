class_name TrackModule extends Node3D


@onready var end = $end

#@export var props: Array[PackedScene] = []
@export var red_blood_cell: PackedScene

@export var played_die_anim = false

#
#const speed = 3
#
func _ready():
	var cell: Node3D = red_blood_cell.instantiate()
	#cell.global_position = end.global_position + Vector3(randi_range(-1, 1), randi_range(-1, 1), randi_range(-1, 1))
	cell.position = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	cell.scale = Vector3(0.05, 0.05, 0.05)
	add_child(cell)
	print(cell)


func _process(delta):
	pass
	#print($AnimationPlayer.current_animation)

func play_die_anim():
	$AnimationPlayer.play("Die")
	played_die_anim = true
	
func reset():
	$AnimationPlayer.play("Pulse")
	
func playing_die_anim() -> bool:
	return played_die_anim

#func _process(delta):
	#translate(Vector3(delta*-speed,0,0))
	#
	#if position.x < -3:
		#position.x = 3
