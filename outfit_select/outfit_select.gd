extends Node3D


@export var cursor_x = 0
@export var cursor_y = 0
@export var chose_a_model = false


@export var speed: float = 3
@export var vx: float = 0
@export var auto_rotate_speed = 0.25

@export var auto_rotating = false

@export var zoom = Vector3(0,0,0)
	

func _on_timer_timeout():
	auto_rotating = true


func _process(delta):
	var index = cursor_y * 4 + cursor_x
	var chosen_outfit : Node3D = $Outfits.get_child(index)
	
		
	if chose_a_model:
		print($Timer.time_left)
		var x = Input.get_axis("ui_left", "ui_right")
		var y = Input.get_axis("ui_up", "ui_down")
			
		if x == 0.0 and $Timer.is_stopped():
			$Timer.start()
		
		if x != 0.0:
			auto_rotating = false
			$Timer.stop()
			
		
		zoom += Vector3(y * delta, y * delta, y * delta)
			

		if auto_rotating:
			vx = lerp(vx, auto_rotate_speed, .01)	
		else:
			vx = lerp(vx, x, .1)

		chosen_outfit.rotate_y(vx * delta * speed)
		
		$SelectCharacter.position.y = lerp(3.5, $SelectCharacter.position.y, .9)
		
		for outfit in $Outfits.get_children():
			if outfit as Node3D == chosen_outfit:
				outfit.scale = lerp(Vector3(1.4, 1.4, 1.4) + zoom, outfit.scale, 0.9)
				outfit.position.x = lerp(0.0, outfit.position.x, 0.9)
				outfit.position.y = lerp(-1.5, outfit.position.y, 0.9)
			else:
				outfit.scale = lerp(Vector3(0, 0, 0), outfit.scale, 0.9)
				
	else:
		print(cursor_x, cursor_y, chosen_outfit)
		
		$SelectCharacter.position.y = lerp(1.75, $SelectCharacter.position.y, .9)
		
		for outfit in $Outfits.get_children():
			outfit.rotation = lerp(Vector3(0,0,0), outfit.rotation, .95)
			outfit.position = lerp(outfit.start_pos, outfit.position, .9)
				
			if outfit as Node3D == chosen_outfit:
				outfit.scale = lerp(Vector3(.6, .6, .6), outfit.scale, 0.9)
				outfit.position.z = lerp(.5, outfit.position.z, .9)
			else:
				outfit.scale = lerp(Vector3(.4, .4, .4), outfit.scale, 0.9)
				outfit.position.z = lerp(0.0, outfit.position.z, .9)



func _input(event):
	if chose_a_model:
		if event.is_action_pressed("ui_cancel"):
			chose_a_model = false
			zoom = Vector3(0,0,0)
	else:
		if event.is_action_pressed("ui_left"):
			cursor_x-= 1
		if event.is_action_pressed("ui_right"):
			cursor_x+=1
		if event.is_action_pressed("ui_up"):
			cursor_y-=1
		if event.is_action_pressed("ui_down"):
			cursor_y+=1
			
		cursor_x = clamp(cursor_x, 0, 3)
		cursor_y = clamp(cursor_y, 0, 2)
		
		if event.is_action_pressed("ui_accept"):
			chose_a_model = true
	
