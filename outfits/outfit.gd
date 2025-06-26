class_name Outfit extends Node3D


@onready var start_pos = position
@export var blob_offset_y = 0

#@export var animation_name = ""

@export var chosen = false

@export var orb_initial_position: Vector3
@export var orb_initial_scale: Vector3


func _ready():
	orb_initial_position = $Orb.position
	orb_initial_scale = $Orb.scale

func play_animation():
	#$AnimationPlayer.animations
	if $Empty/Armature/Skeleton3D:
		$Empty/Armature/Skeleton3D.show_rest_only = false
		$AnimationPlayer.play("Armature|mixamo_com|Layer0")
		chosen = true
	
	


func _process(delta):
	if chosen:
		$Orb.scale = lerp(Vector3(1.5, 1.5, 1.5), $Orb.scale , 0.9)
		$Orb.position = lerp(Vector3(0,blob_offset_y, 0), $Orb.position, .9)
	else:
		$Orb.scale = lerp(orb_initial_scale, $Orb.scale , 0.9)
		$Orb.position = lerp(orb_initial_position, $Orb.position, .9)


func stop_animation():
	if $Empty/Armature/Skeleton3D:
		$AnimationPlayer.stop()
		$Empty/Armature/Skeleton3D.show_rest_only = true
		chosen = false
