extends Node

var start = false

@onready var start_cam = $space/Camera3D
@onready var player_cam = $space/player/player_cam
@onready var player = $space/player

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	player.set_process_input(false)
	player.set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$fps.text = str(Engine.get_frames_per_second())
	
	
	if start:
		start_cam.global_position  = lerp(start_cam.global_position, player_cam.global_position, 5 * delta)
		start_cam.rotation.y  = lerp_angle(start_cam.rotation.y, player_cam.rotation.y, 5 * delta)
		if abs(start_cam.global_position.distance_to(player_cam.global_position)) < 0.25:
			player_cam.current = true
			start = false
			player.set_physics_process(true)
			player.set_process_input(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("nice")


func _on_button_pressed():
	start = true
	$main_menu/ui_layer.hide()


func _on_water_area_body_entered(body):
	if body.is_in_group("player"):
		$space/watersplash_sound.play()
		$black_layer.show()


func _on_watersplash_sound_finished():
	get_tree().reload_current_scene()


func _on_container_area_body_entered(body):
	if body.is_in_group("crate"):
		get_node($space/player.picked_object).gravity_scale = 1.0
		$space/player.picked_object = null
		get_tree().get_nodes_in_group("pipe")[0].get_node("parts").emitting = true
		get_tree().get_nodes_in_group("pipe")[0].get_node("audio").playing = true
