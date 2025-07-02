class_name Game extends Node3D



# Global / game state
enum GAME_STATE {
	OUTFIT_SELECT,
	PLAYING,
	MINIGAME,
	GAMEOVER
}

@export var game_state = GAME_STATE.OUTFIT_SELECT
@export var current_minigame: bool

@export var gameover = false

# Biomes and track
enum BIOME {
	VEINS, 
	GRAPHWORLD,
	CELL,
	BRAIN
}

var current_biome = BIOME.VEINS
var modules_in_current_biome = 0
var modules_until_switch = randi_range(5, 10)

@export var module_vein_straight: PackedScene 


# Health
@export var max_health: float = 9
@export var health: float = 9
@export var dying_speed: float = 0.25

# Movement
@export var initial_forward_speed = 20
@export var forward_speed = initial_forward_speed
@export var forward_speed_menu = 3

var move_speed = 5
var velocity = Vector2(0,0)
var drag = 0.85

@export var limit_from_center: float = 15.0


# Important UI elements
@onready var healthbar = $LevelPosition/Camera3D/healthbar
@onready var patient_lost_text = $LevelPosition/Camera3D/PatientLost
@onready var outfit_select = $LevelPosition/Camera3D/OutfitSelect

# Pickups and obstacles
@export var pickups_packedscenes: Array[PackedScene] = []
@export var pickups: Array[Pickup] = []
@export var pickup_vfx: PackedScene

@export var obstacles_packedscenes: Array[PackedScene] = []
@export var obstacles: Array[Obstacle] = []
@export var bloodvessels: PackedScene

@export var initial_vein_chance = 400
@export var vein_chance = initial_vein_chance

@export var initial_obstacle_chance = 400
@export var obstacle_chance = initial_obstacle_chance

# Input correction ------
@onready var has_joystick = Input.get_connected_joypads().size() > 0

func get_axis_x() -> float:
	if has_joystick:
		var x:float = Input.get_joy_axis(0,0)# + 0.45
		if x > 0.1 or x < -0.1:
			return x
		else:
			return 0
	else:
		return Input.get_axis("ui_left", "ui_right")
		
		
func get_axis_y() -> float:
	if has_joystick:
		var y:float = Input.get_joy_axis(0,1) #+ 0.4
		if y > 0.1 or y < -0.1:
			return y * -1
		else:
			return 0
	else:
		return Input.get_axis("ui_down", "ui_up")
		
		
		
# Main ---------
func _ready():
	healthbar.scale = Vector3(0,0,0)
	patient_lost_text.scale = Vector3(0,0,0)
	game_state = GAME_STATE.OUTFIT_SELECT


func _process(delta):	
	# Playing
	if game_state == GAME_STATE.PLAYING:
		handle_ship_movement(delta)
		$LevelPosition.translate(Vector3(0,0, -forward_speed * delta))
		outfit_select.scale = lerp(Vector3(0.0, 0.0, 0.0), outfit_select.scale, 0.9)
		$LevelPosition/Ship.visible = true
		update_health(delta)
		update_pickups()
		update_obstacles()
	
	# Outfit select
	if game_state == GAME_STATE.OUTFIT_SELECT:
		outfit_select.scale = lerp(Vector3(1, 1, 1), outfit_select.scale, 0.9)
		$LevelPosition.translate(Vector3(0,0, -forward_speed_menu * delta))
		$LevelPosition/Ship.visible = false
		
	# Gameover
	if game_state == GAME_STATE.GAMEOVER:
		pass
		#$LevelPosition.translate(Vector3(0,0, -forward_speed_menu * delta))
	
	lerp_camera()
	update_track()
	
	# Healthbar
	if game_state == GAME_STATE.PLAYING:
		healthbar.scale = lerp(Vector3(.9, .9, .9), healthbar.scale, 0.9)
	else: 
		healthbar.scale = lerp(Vector3(0, 0, 0), healthbar.scale, 0.9)
	
	
	healthbar.update_health(health)
	
	print(game_state)
	if game_state == GAME_STATE.GAMEOVER:
		patient_lost_text.scale = lerp(Vector3(1, 1, 1), patient_lost_text.scale, 0.9)
	else:
		patient_lost_text.scale = lerp(Vector3(0, 0, 0), patient_lost_text.scale, 0.9)
	


func update_health(delta):
	# Auto reduce health 
	health -= delta * dying_speed
	
	# Gameover state
	if health <= 0:
		game_state = GAME_STATE.GAMEOVER
		
		
func update_pickups():
	# Spawning
	if randi_range(0,100) == 0:	
		var random_pickup_packedscene = pickups_packedscenes.pick_random()
		var new_pickup: Pickup = random_pickup_packedscene.instantiate()
		new_pickup.position = $LevelPosition.position + Vector3(randf_range(-limit_from_center, limit_from_center),randf_range(-limit_from_center, limit_from_center), -150)
		add_child(new_pickup)
	
	# Magnet
	for child in get_children():
		if child is Pickup:
			if child.global_position.distance_to($LevelPosition/Ship.global_position) < 7.5:
				child.global_position = lerp(child.global_position, $LevelPosition/Ship.global_position, 0.1)
		


func update_obstacles():
	# Spawning obstacles
	if randi_range(0,100) == 0:	
		var random_obstacle_packedscene = obstacles_packedscenes.pick_random()
		var new_obstacle = random_obstacle_packedscene.instantiate()
		new_obstacle.position = $LevelPosition.position + Vector3(randf_range(-limit_from_center, limit_from_center),randf_range(-limit_from_center, limit_from_center), -150)
		new_obstacle.rotation = Vector3(randf_range(-limit_from_center, limit_from_center),randf_range(-limit_from_center, limit_from_center), -150)
		add_child(new_obstacle)
		obstacle_chance -= 5
		
	if randi_range(0,vein_chance) == 0:	
		var blood = bloodvessels.instantiate()
		blood.position = $LevelPosition.position + Vector3(randf_range(-limit_from_center*4, limit_from_center*4),randf_range(-limit_from_center*4, limit_from_center*4), -150)
		blood.rotation = Vector3(randf_range(-limit_from_center, limit_from_center),randf_range(-limit_from_center, limit_from_center), -150)
		add_child(blood)
		vein_chance -= 10

	# Picking up
	#for pickup in pickups:
		#print($LevelPosition.position)

var streak = 0
func _on_ship_area_entered(area):
	print(area)
	if area is Pickup:
		# Health and speed
		print("its a pickup!")
		print(area.health_boost)
		health += area.health_boost
		health = min(max_health, health)
		
		# VFX
		var fx = pickup_vfx.instantiate()
		fx.global_position = area.global_position
		fx.color = area.color
		add_child(fx)
		$GradientDash/AnimationPlayer.play("flash")
		$GradientDash.self_modulate = area.color
		
		# Speed
		forward_speed += .2
		
		# Streak
		$StreakTimer.start()
		streak += 1
		
		# SFX
		#$Pickup2.pitch_scale = 1 + streak / 2.0
		if streak == 4: 
			$Pickup2.pitch_scale = 2
		else: 
			$Pickup2.pitch_scale = 1
		$Pickup2.play()
		
		area.queue_free()
		
	# ObMGstacle damage!
	if area is Obstacle:
		# Health and speed
		print("its an obstacle!!")
		print(area.damage)
		health -= area.damage
		health = min(max_health, health)
		
		# VFX
		#var fx = pickup_vfx.instantiate()
		#fx.global_position = area.global_position
		#fx.color = Color.
		#add_child(fx)
		$GradientDash/AnimationPlayer.play("flash")
		$GradientDash.self_modulate = Color.RED
		
		# Speed
		forward_speed -= 1
		
		# SFX
		#$Pickup2.pitch_scale = 1 + streak / 2.0
		#if streak == 4: 
			#$Pickup2.pitch_scale = 2
		#else: 
			#$Pickup2.pitch_scale = 1
		#$Pickup2.play()
		#
		$Damage.play()
		
		#if $LevelPosition:
			#if $LevelPosition.global_position.distance_to(pickup.global_position) < 5:
				#health += pickup.health_boost


func handle_ship_movement(delta):
	var x = get_axis_x()
	var y = get_axis_y()
	
	velocity.x += x * move_speed * delta
	velocity.y += y * move_speed * delta
	
	velocity *= drag
	
	
	$LevelPosition/Ship.translate(Vector3(velocity.x, velocity.y, 0))
	# Limit position
	$LevelPosition/Ship.position.x = clamp($LevelPosition/Ship.position.x, -limit_from_center, limit_from_center)
	$LevelPosition/Ship.position.y = clamp($LevelPosition/Ship.position.y, -limit_from_center, limit_from_center)
	


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
		#print($Track.get_child_count())
		#for t in $Track.get_children():
			#print(t.position)
		
		second_track_piece.queue_free()
		var new_module : TrackModule = module_vein_straight.instantiate()
		new_module.position = last_track_piece.position - Vector3(0,0,70)
		#new_module.rotate(Vector3(0,1,0), 90)
		$Track.add_child(new_module)
		modules_in_current_biome += 1
		
		# Biome switching
		if modules_in_current_biome == modules_until_switch:
			current_biome = [ BIOME.VEINS, BIOME.GRAPHWORLD, BIOME.CELL, BIOME.BRAIN ].pick_random()


	if game_state == GAME_STATE.GAMEOVER:
		for t in $Track.get_children():
			if not t.playing_die_anim():
				t.play_die_anim()


func new_game(outfit: Outfit):
	if game_state == GAME_STATE.GAMEOVER:
		restart()
		
	elif game_state != GAME_STATE.PLAYING:
		game_state = GAME_STATE.PLAYING
		forward_speed = initial_forward_speed
		var copy: Outfit = outfit.duplicate()
		$LevelPosition/Ship.add_child(copy)
		#copy.stop_animation(true)
		copy.position = Vector3(0,0,0)
		copy.scale = Vector3(3,3,3)
		copy.rotation_degrees = Vector3(0,180,0)
		health = max_health
		$Start.play()
		
		obstacle_chance = initial_obstacle_chance
		vein_chance = initial_vein_chance
	
	
	

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		game_state = GAME_STATE.GAMEOVER



func _input(event):
	if game_state == GAME_STATE.PLAYING and event.is_action_pressed("ui_cancel"):
		game_state = GAME_STATE.OUTFIT_SELECT
		
	if game_state == GAME_STATE.GAMEOVER and event.is_action_pressed("ui_accept"):
		restart()
		
	if event.is_action_pressed("start minigame"):
		for t in $Track.get_children():
			t.play_die_anim()
	
	
func restart():
	game_state = GAME_STATE.OUTFIT_SELECT
	
	$LevelPosition/Camera3D/OutfitSelect.chose_a_model = false
	$LevelPosition/Camera3D/OutfitSelect.back_to_overview()
	
	# Reset ship position
	$LevelPosition/Ship.position.x = 0
	$LevelPosition/Ship.position.y = 0
	
	for child in $LevelPosition/Ship.get_children():
		child.queue_free()
	
	for t in $Track.get_children():
		var tt = t as TrackModule
		tt.reset()


func _on_streak_timer_timeout():
	streak = 0
