extends Node3D

@export var module_vein_straight: PackedScene 

func _process(delta):
	var first_track_piece: TrackModule = $Track.get_children().get(0)
	var second_track_piece: TrackModule = $Track.get_children().get(1)
	var last_track_piece: TrackModule = $Track.get_children().get(3)
	

	if second_track_piece.end.global_position.distance_to($LevelPosition.global_position) < 10:
		print($Track.get_child_count())

		for t in $Track.get_children():
			print(t.position)
		
		
		second_track_piece.queue_free()
		var new_module : TrackModule = module_vein_straight.instantiate()
		new_module.position = last_track_piece.position - Vector3(0,0,70)
		#new_module.rotate(Vector3(0,1,0), 90)
		$Track.add_child(new_module)
		
	
