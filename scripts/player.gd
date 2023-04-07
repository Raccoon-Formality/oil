extends CharacterBody3D


const SPEED = 2.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $player_cam

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2,PI/2)

var picked_object = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	if Input.is_action_just_pressed("click") and picked_object == null:
		if $player_cam/RayCast3D.get_collider() != null:
			print($player_cam/RayCast3D.get_collider())
			if $player_cam/RayCast3D.get_collider() is RigidBody3D:
				picked_object = $player_cam/RayCast3D.get_collider().get_path()
				get_node(picked_object).freeze = true
	elif Input.is_action_just_pressed("click") and picked_object != null:
		get_node(picked_object).freeze = false
		picked_object = null
	#print(picked_object)
	if picked_object != null:
		get_node(picked_object).global_position = $player_cam/RayCast3D/Node3D.global_position
		
		
	
	#print($player_cam/RayCast3D.get_collider())
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
