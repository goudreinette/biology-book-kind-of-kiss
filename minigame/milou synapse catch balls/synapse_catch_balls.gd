class_name SynapseCatchBalls extends Node

@export var neurotransmitter_scenes: Array[PackedScene]
@export var neurotransmitters: Array[Node3D]
@export var spawn_range = 1

var move_speed = 1
var velocity = Vector2(0,0)
var drag = 0.85



func _ready():
	pass
	
	
func _process(delta):
	if randi_range(0, 200) == 0:
		var random = neurotransmitter_scenes.pick_random()
		var transmitter = random.instantiate()
		transmitter.global_position = $Synapse/Spawnpoint.global_position + Vector3(randf_range(-spawn_range, spawn_range), 0, 0)
		$Synapse/Spawnpoint.add_child(transmitter)
		
		print(transmitter)
		#transmitter.position = 
	
	var x = Input.get_axis("ui_left", "ui_right")
	var y = Input.get_axis("ui_down", "ui_up")
	
	velocity.x += x * move_speed * delta
	velocity.y += y * move_speed * delta
	
	velocity *= drag
	
	#$LevelPosition/Ship)
	
	$bucket.translate(Vector3(velocity.x, velocity.y, 0))
