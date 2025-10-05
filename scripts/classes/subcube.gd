class_name Subcube

extends Node3D

var side_membership: Dictionary = {}
var previous_position: Vector3
var cube_parent: Cube

func get_current_middle(subcubes: Array[Subcube]) -> Vector3:
	var total: Vector3 = Vector3.ZERO
	var count: int = 0
	for subcube: Subcube in subcubes:
		total += subcube.global_position
		count += 1
	if count > 0:
		return total/count
	else:
		return Vector3.ZERO
