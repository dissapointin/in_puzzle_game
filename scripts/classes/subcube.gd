class_name Subcube

extends Node3D

var side_membership: Dictionary = {}
var previous_position: Vector3
var cube_parent: Cube

func _ready():
	print("ready " + str(self))

func get_current_middle(subcubes: Array[Subcube]) -> Vector3:
	var total := Vector3.ZERO
	var count := 0
	for subcube: Node3D in subcubes:
		total += subcube.global_position
		count += 1
	return total / count if count > 0 else Vector3.ZERO
