extends CharacterBody3D


const SPEED = 2.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $player_cam
@onready var pipe_node = get_tree().get_nodes_in_group("pipe")[0]

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2,PI/2)

var picked_object = null
var crate_picked = false

func _physics_process(delta):
	
	# Checks if mouse is pressed in the last frame, then checks if crate is not already picked up
	if Input.is_action_just_pressed("click") and picked_object == null and !crate_picked:
		# Checks if raycasting is colliding with something and if it is a RigidBody (which the crate is)
		if $player_cam/RayCast3D.get_collider() != null and $player_cam/RayCast3D.get_collider() is RigidBody3D:
			picked_object = $player_cam/RayCast3D.get_collider().get_path()
			get_node(picked_object).gravity_scale = 0.0
			crate_picked = true
	
	# Moves the crate if it is picked up
	if picked_object != null:
		#get_node(picked_object).set_linear_velocity(($player_cam/RayCast3D/Node3D.global_position-get_node(picked_object).global_position)*10.0)
		get_node(picked_object).global_position = $player_cam/RayCast3D/Node3D.global_position

	# Checks if player is interacting with valve on the pipe
	if Input.is_action_pressed("click") and picked_object == null and $player_cam/RayCast3D.get_collider() != null:
		if $player_cam/RayCast3D.get_collider() is StaticBody3D:
			get_node($player_cam/RayCast3D.get_collider().get_path()).get_node("valve").rotation_degrees.y -= 1
			if pipe_node.get_node("valve_audio").playing == false:
				pipe_node.get_node("valve_audio").play()
			if get_node($player_cam/RayCast3D.get_collider().get_path()).get_node("valve").rotation_degrees.y < -360.0:
				pipe_node.get_node("parts").emitting = false
				pipe_node.get_node("audio").playing = false
	else:
		pipe_node.get_node("valve_audio").playing = false
	
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if $walking_audio.playing == false:
			$walking_audio.play()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		$walking_audio.playing = false

	move_and_slide()
