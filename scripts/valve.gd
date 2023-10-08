extends Interactable

@onready var valve_mesh = $valve
@onready var audio = $valve_audio
@onready var part_audio = $audio
@onready var part = $parts

var constant = true
var done = false

func interact():
	pass

func not_interact():
	audio.playing = false

func continuos_interact():
	if world.tasks["block"]:
		valve_mesh.rotation_degrees.y -= 1
		if audio.playing == false:
			audio.play()
		if valve_mesh.rotation_degrees.y < -360.0 and !done:
			part.emitting = false
			part_audio.playing = false
			world.comp_sound.play()
			world.oil_sound.playing = false
			world.oil_pistion_ani.pause()
			world.tasks["valve"] = true
			done = true
			world.show_text("Good, good... hold on...\nwhy can't I hear the rig running?")
