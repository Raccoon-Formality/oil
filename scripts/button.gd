extends Interactable

@onready var anim = $button/AnimationPlayer

var constant = false
var done = false

func interact():
	anim.play("press")
	if world.tasks["valve"] and !done:
		world.comp_sound.playing = false
		world.oil_sound.playing = true
		world.oil_pistion_ani.play()
		world.tasks["button"] = true
		done = true
		world.boat.hide()
		world.show_text("Good, now...\nI should check the watchtower.")
		#world.final.play("final")
