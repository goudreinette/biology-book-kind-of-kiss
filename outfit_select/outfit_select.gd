extends Node3D


@export var cursor_x = 0
@export var cursor_y = 0
@export var chose_a_model = false
@export var title_screen = true

@export var speed: float = 3
@export var vx: float = 0
@export var auto_rotate_speed = 0.25

@export var auto_rotating = false

@export var zoom = Vector3(0,0,0)
	

func _on_timer_timeout():
	auto_rotating = true

func _ready():
	$SelectCharacterText.scale = Vector3.ZERO
	$Outfits.scale = Vector3.ZERO


func _process(delta):
	var index = cursor_y * 4 + cursor_x
	var chosen_outfit : Outfit = $Outfits.get_child(index)
	
	$SelectCharacterText/CaseName.mesh.text = chosen_outfit.case_name
	
	if title_screen:
		$BiologyBookText.scale = lerp(Vector3(1.5, 1.5, 1.5), $BiologyBookText.scale, 0.9)
		$SelectCharacterText.scale = lerp(Vector3(0, 0, 0), $SelectCharacterText.scale, 0.9)
		$Outfits.scale = lerp(Vector3(0, 0, 0), $Outfits.scale, 0.9)
		$SelectCharacterText/CaseName.scale = Vector3(0, 0, 0)
	else:
		$BiologyBookText.scale = lerp(Vector3(0, 0, 0), $BiologyBookText.scale, 0.9)
		$Outfits.scale = lerp(Vector3(1, 1, 1), $Outfits.scale, 0.9)
		$SelectCharacterText.scale = lerp(Vector3(1, 1, 1), $SelectCharacterText.scale, 0.9)
		$SelectCharacterText/CaseName.scale = Vector3(1, 1, 1)
		
		
		if chose_a_model:
			#print($Timer.time_left)
			var x = $"../../../".get_axis_x()
			var y = $"../../../".get_axis_y()
				
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
			
			$SelectCharacterText.position.y = lerp(3.5, $SelectCharacterText.position.y, .9)
			#chosen_outfit.get_children()[0].scale = 
			
			
			for outfit in $Outfits.get_children():
				if outfit as Node3D == chosen_outfit:
					outfit.scale = lerp(Vector3(1.6, 1.6, 1.6) + zoom, outfit.scale, 0.9)
					outfit.position.x = lerp(0.0, outfit.position.x, 0.9)
					outfit.position.y = lerp(-1.8, outfit.position.y, 0.9)
					#outfit.get_child(0).scale = lerp(Vector3(2, 2, 2), outfit.get_child(0).scale, 0.9)
				else:
					outfit.scale = lerp(Vector3(0, 0, 0), outfit.scale, 0.9)
					#outfit.find_child("MeshInstance3D").scale = lerp(Vector3(1, 1, 1), outfit.get_child(0).scale, 0.9)
		else:
			#print(cursor_x, cursor_y, chosen_outfit)
			
			$SelectCharacterText.position.y = lerp(1.75, $SelectCharacterText.position.y, .9)
			
			for outfit in $Outfits.get_children():
				outfit.rotation = lerp(Vector3(0,0,0), outfit.rotation, .95)
				outfit.position = lerp(outfit.start_pos, outfit.position, .9)
					
				if outfit as Node3D == chosen_outfit:
					outfit.scale = lerp(Vector3(.6, .6, .6), outfit.scale, 0.9)
					outfit.position.z = lerp(.5, outfit.position.z, .9)
				else:
					outfit.scale = lerp(Vector3(.5, .5, .5), outfit.scale, 0.9)
					outfit.position.z = lerp(0.0, outfit.position.z, .9)



var left_just_pressed = false
var right_just_pressed = false
var up_just_pressed = false
var down_just_pressed = false


func back_to_overview():
	var index = cursor_y * 4 + cursor_x
	var chosen_outfit : Outfit = $Outfits.get_child(index)
		
	chose_a_model = false
	zoom = Vector3(0,0,0)
	chosen_outfit.stop_animation(false)
	$Back.play()
	


func _input(event):
	if title_screen:
		if event.is_action_pressed("ui_accept"):
			title_screen = false
			$Ok.play()
	else:
		var index = cursor_y * 4 + cursor_x
		var chosen_outfit : Outfit = $Outfits.get_child(index)
				
		if chose_a_model:
			if event.is_action_pressed("ui_cancel"):
				back_to_overview()
				#.remove_child()
				
			if event.is_action_pressed("ui_accept"):
				#chosen_outfit.stop_animation(false)
				$"../../../".new_game(chosen_outfit)
				
		else:
			if event.is_action_pressed("ui_cancel"):
				title_screen = true
				$Back.play()
			
			if event.is_action_pressed("ui_left") and not left_just_pressed:
				cursor_x-= 1
				left_just_pressed = true
				$Cursor.play()
			if event.is_action_pressed("ui_right") and not right_just_pressed:
				cursor_x+=1
				right_just_pressed = true
				$Cursor.play()
			if event.is_action_pressed("ui_up") and not up_just_pressed:
				cursor_y-=1
				up_just_pressed = true
				$Cursor.play()
			if event.is_action_pressed("ui_down") and not down_just_pressed:
				cursor_y+=1
				down_just_pressed = true
				$Cursor.play()
				
			if event.is_action_released("ui_left"): left_just_pressed = false
			if event.is_action_released("ui_right"): right_just_pressed = false
			if event.is_action_released("ui_up"): up_just_pressed = false
			if event.is_action_released("ui_down"): down_just_pressed = false
				
			cursor_x = clamp(cursor_x, 0, 3)
			cursor_y = clamp(cursor_y, 0, 2)
			
			# Selecting a model
			if event.is_action_pressed("ui_accept"):
				chose_a_model = true
				chosen_outfit.play_animation()
				$Ok.play()
				
	
