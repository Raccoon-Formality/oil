extends StaticBody3D
class_name Interactable


@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var world = get_tree().root.get_node("world")

func interact():
	pass

func continuos_interact():
	pass

func not_interact():
	pass
