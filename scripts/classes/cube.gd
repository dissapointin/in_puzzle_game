# Cube.gd
class_name Cube
extends Node3D

var is_rotating: bool = false
# sides : Dictionary[Side] = {}

func rotate_cube(side_node: Side, side: Side.SIDE) -> void:
	if is_rotating:
		return
	
	is_rotating = true
	await side_node.rotate_side(90.0, 0.5)
	is_rotating = false

#func _init(sides Side[]) -> void:
	#for side in sides:
		#side
	
	
