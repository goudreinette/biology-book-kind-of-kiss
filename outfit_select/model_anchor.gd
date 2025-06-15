extends Node3D


@export var speed: float = 3
@export var vx: float = 0
@export var auto_rotate_speed = 0.25

@export var auto_rotating = false


func _process(delta):
	print($Timer.time_left)
	var x = Input.get_axis("ui_left", "ui_right")
		
	if x == 0.0 and $Timer.is_stopped():
		$Timer.start()
	
	if x != 0.0:
		auto_rotating = false
		$Timer.stop()
		

	if auto_rotating:
		vx = lerp(vx, auto_rotate_speed, .01)	
	else:
		vx = lerp(vx, x, .1)

	rotate_y(vx * delta * speed)
	

func _on_timer_timeout():
	auto_rotating = true
