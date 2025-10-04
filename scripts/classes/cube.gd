# Cube.gd
class_name Cube
extends Node3D

var sides: Dictionary = {}  # Dictionary[Side.SIDE, Side] in comment for clarity
var subcubs: Array[Subcube] = []
var is_rotating: bool = false

func set_side(side_node: Node3D, side_enum: Side.SIDE) -> void:
	var s: Side = side_node
	s.set_enum(side_enum, self)
	sides[side_enum] = s

func set_subcube(subcube_node: Node3D, side_enums: Array[Side.SIDE]) -> void:
	var s: Subcube = subcube_node
	s.set_side_membership(side_enums)
	



func rotate_cube(side: Side.SIDE) -> void:
	if is_rotating:
		return
		
	var side_node: Side = sides[side]
	if not side_node:
		printerr("side doesnt exist, define the side using Cube.set_side(Node3D, Side.SIDE)")
		return
	
	is_rotating = true
	await side_node.rotate_side(90.0, 0.5)
	is_rotating = false
