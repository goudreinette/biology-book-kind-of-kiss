extends Node3D

var forward_speed = 30

var move_speed = 10
var velocity = Vector2(0,0)
var drag = 0.9



	
func _process(delta):
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_down", "ui_up")
	
	#print(x, y)
	
	velocity.x += x * move_speed * delta
	velocity.y += y * move_speed * delta
	
	velocity *= drag
	
	$Ship.translate(Vector3(velocity.x, velocity.y, 0))
	
	$Camera3D.position.x = lerp($Ship.position.x, $Camera3D.position.x, 0.95)
	$Camera3D.position.y = lerp($Ship.position.y, $Camera3D.position.y, 0.95)
	
	translate(Vector3(0,0, -forward_speed * delta))
