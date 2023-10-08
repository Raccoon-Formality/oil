extends Node

var start = false

@onready var start_cam = $space/Camera3D
@onready var player_cam = $space/player/player_cam
@onready var player = $space/player

@onready var oil_sound = $space/base/oil_piston_sound
@onready var comp_sound = $space/base/comp_sound
@onready var oil_pistion_ani = $space/base/oil_piston/AnimationPlayer

#@onready var final = $final_anim
@onready var boat = $Fisher_Boat2 

@onready var end_cam = $space/base/final_des/final_cam
@onready var end_cam_pos = $space/base/final_des/final_cam.global_position
@onready var end_cam_rot = $space/base/final_des/final_cam.global_rotation
var finally = false


var tasks = {
	"block": false,
	"valve": false,
	"button": false
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	player.set_process_input(false)
	player.set_physics_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$fps.text = str(Engine.get_frames_per_second())
	if Input.is_action_pressed("escape"):
		get_tree().quit()

	if start:
		start_cam.global_position  = lerp(start_cam.global_position, player_cam.global_position, 5 * delta)
		start_cam.rotation.y  = lerp_angle(start_cam.rotation.y, player_cam.rotation.y, 5 * delta)
		if abs(start_cam.global_position.distance_to(player_cam.global_position)) < 0.25:
			player_cam.current = true
			start = false
			player.set_physics_process(true)
			player.set_process_input(true)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			$game_ui.show()
	
	if finally:
		end_cam.global_position  = lerp(end_cam.global_position, end_cam_pos, 2 * delta)
		end_cam.global_rotation.y  = lerp_angle(end_cam.global_rotation.y, end_cam_rot.y, 2 * delta)
		if abs(end_cam.global_position.distance_to(end_cam_pos)) < 0.1:
			end_cam.global_position = end_cam_pos
			end_cam.global_rotation = end_cam_rot
			finally = false
			

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
		$space/player.picked_object.gravity_scale = 1.0
		$space/player.picked_object = null
		get_tree().get_nodes_in_group("valve")[0].get_node("parts").emitting = true
		get_tree().get_nodes_in_group("valve")[0].get_node("audio").playing = true
		show_text("There, good. Wait- that's not right,\nI should fix that with that red valve.")


func show_text(text):
	var test = ""
	for i in text.length():
		#working = true
		test += text[i]
		#$boop.play()
		$game_ui/ui/text.text = test
		await get_tree().create_timer(0.05).timeout
		


func _on_final_des_body_entered(body):
	if body.is_in_group("player") and tasks["button"]:
		end_cam.global_position = player_cam.global_position
		end_cam.global_rotation.y = player_cam.global_rotation.y
		end_cam.current = true
		show_text("Hey, wait,\nwasn't there a ship out there just a few minutes ago?")
		finally = true
		await get_tree().create_timer(6.0).timeout
		$space/base/oil_piston_sound.playing = false
		$space/player/metal_audio.playing = false
		$game_ui.hide()
		$black_layer.show()
		await get_tree().create_timer(1.0).timeout
		$final_sound.play()
		await get_tree().create_timer(5.0).timeout
		$black_layer/black_control/name.show()
		await get_tree().create_timer(10.0).timeout
		get_tree().reload_current_scene()
		




func _on_v_slider_value_changed(value):
	$space/WorldEnvironment.get_environment().ambient_light_energy = value
