extends CharacterBody3D
class_name player

const SPEED = 2.5
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera = $player_cam
@onready var pipe_node = get_tree().get_nodes_in_group("pipe")[0]
@onready var button_node = get_tree().get_nodes_in_group("button")[0]
@onready var valve_node = get_tree().get_nodes_in_group("valve")[0]

@onready var raycast = $player_cam/RayCast3D
@onready var hold_pos = $player_cam/RayCast3D/Node3D

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.005)
		camera.rotate_x(-event.relative.y * 0.005)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2,PI/2)

var picked_object = null
var crate_picked = false

func _physics_process(delta):
	
	if !picked_object:
		var raycast_got = raycast.get_collider()
		if raycast.is_colliding() and raycast_got is Interactable:
			if Input.is_action_just_pressed("click"):
				raycast_got.interact()
			if Input.is_action_pressed("click"):
				raycast_got.continuos_interact()
			else:
				raycast_got.not_interact()
	else:
		picked_object.global_position = lerp(picked_object.global_position, hold_pos.global_position, 0.1)
	
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



#get_node(picked_object).set_linear_velocity(($player_cam/RayCast3D/Node3D.global_position-get_node(picked_object).global_position)*10.0)
