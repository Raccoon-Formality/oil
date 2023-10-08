extends Interactable


var constant = false

func interact():
	if !player.crate_picked:
		world.show_text("This has a place it's supposed to go \nand now it's my job to put it there.")
		get_parent().gravity_scale = 0.0
		player.crate_picked = true
		player.picked_object = get_parent()
		world.tasks["block"] = true
