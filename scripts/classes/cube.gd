# Cube.gd
class_name Cube
extends Node3D

var sides: Dictionary = {}

# using Dict, instead of list for faster adding/popping - hashtable
var subcubs: Dictionary = {
	Side.SIDE.TOP: {},
	Side.SIDE.BOTTOM: {},
	Side.SIDE.FRONT: {},
	Side.SIDE.BACK: {},
	Side.SIDE.LEFT: {},
	Side.SIDE.RIGHT: {},
}

var is_rotating: bool = false

func set_side(side_node: Node3D, side_enum: Side.SIDE) -> void:
	var s: Side = side_node
	s.set_enum(side_enum, self)
	sides[side_enum] = s

func set_subcube(subcube_node: Node3D, side_enums: Array[Side.SIDE]) -> void:
	var s: Subcube = subcube_node
	s.set_side_membership(side_enums)
	
# TODO: make this signal, because its called by kids.
func subcubes_dict_modify(subcube: Subcube, side_enum: Side.SIDE, add: bool) -> void:
	if add:
		subcubs[side_enum][subcube] = true;
	elif subcubs[side_enum][subcube]:
		subcubs[side_enum].erase(subcube)

# calculatng middle point of all sides using the average of all subcubes
func get_current_middle(subcubes_given_side: Array[Subcube]) -> Vector3:
	var total := Vector3.ZERO
	var count := 0
	for subcube: Node3D in subcubes_given_side:
		total += subcube.global_position
		count += 1
	return total / count if count > 0 else Vector3.ZERO
	
func rotate_cube(side: Side.SIDE) -> void:
	if is_rotating:
		return
	is_rotating = true
	
	rotate_subcubes(side, 90.0, 0.5)
	is_rotating = false
	
func rotate_subcubes(side: Side.SIDE, rot_deg: float, duration: float):
	var subcubes_given_side: Array[Subcube] = []
	for key in subcubs[side]:
		subcubes_given_side.append(key)
		
	var middle: Vector3 = get_current_middle(subcubes_given_side)
	var axis := Side.get_vector_from_side(side)

	# temp pivot to rotate around
	var pivot := Node3D.new()
	pivot.position = middle
	get_parent().add_child(pivot)
	pivot.global_position = middle
	
	# adds all subcubes to the pivot
	for subcube: Node3D in subcubes_given_side:
		subcube.reparent(pivot)
		
	# rotates the pivot (and all of the subsides)
	var tween = get_tree().create_tween()
	tween.tween_property(
		pivot, 
		"rotation_degrees", 
		pivot.rotation_degrees + axis * rot_deg, 
		duration
	)
	
	await tween.finished # wait for the rotation to end

	# returns the sturcture to the origianl state
	for subcube: Node3D in subcubes_given_side:
		subcube.reparent(self)

	pivot.queue_free()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
	"""
		
	var side_node: Side = sides[side]
	if not side_node:
		printerr("side doesnt exist, define the side using Cube.set_side(Node3D, Side.SIDE)")
		return
	
	
	await side_node.rotate_side(90.0, 0.5)
	is_rotating = false"""
