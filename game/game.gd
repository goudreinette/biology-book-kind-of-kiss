extends Node3D

@export var module_vein_straight: PackedScene 

# Global 
enum GAME_STATE {
	OUTFIT_SELECT,
	PLAYING
}

@export var game_state = GAME_STATE.OUTFIT_SELECT


# Movement
@export var forward_speed = 30
@export var forward_speed_menu = 3

var move_speed = 10
var velocity = Vector2(0,0)
var drag = 0.9



func _process(delta):
	# Playing
	if game_state == GAME_STATE.PLAYING:
		handle_ship_movement(delta)
		$LevelPosition.translate(Vector3(0,0, -forward_speed * delta))
	
	if game_state == GAME_STATE.OUTFIT_SELECT:
		$LevelPosition.translate(Vector3(0,0, -forward_speed_menu * delta))
	
	lerp_camera()
	update_track()
	
	
	
	
func handle_ship_movement(delta):
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_down", "ui_up")
	
	velocity.x += x * move_speed * delta
	velocity.y += y * move_speed * delta
	
	velocity *= drag
	
	$Ship.translate(Vector3(velocity.x, velocity.y, 0))



func lerp_camera():
	# Always move camera
	$LevelPosition/Camera3D.position.x = lerp($LevelPosition/Ship.position.x, $LevelPosition/Camera3D.position.x, 0.95)
	$LevelPosition/Camera3D.position.y = lerp($LevelPosition/Ship.position.y, $LevelPosition/Camera3D.position.y, 0.95)
	


func update_track():
	# Track logic
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
