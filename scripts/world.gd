extends Node

var start = false

@onready var start_cam = $space/Camera3D
@onready var player_cam = $space/player/player_cam
@onready var player = $space/player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.set_process(false)
	player.set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if start:
		start_cam.global_position  = lerp(start_cam.global_position, player_cam.global_position, 5 * delta)
		start_cam.rotation.y  = lerp_angle(start_cam.rotation.y, player_cam.rotation.y, 5 * delta)
		if abs(start_cam.global_position.distance_to(player_cam.global_position)) < 0.25:
			player_cam.current = true
			start = false
			player.set_process(true)
			player.set_process_input(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			print("nice")


func _on_button_pressed():
	start = true
	$main_menu/ui_layer.hide()
