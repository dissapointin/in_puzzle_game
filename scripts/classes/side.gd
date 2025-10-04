# Side.gd
class_name Side
extends Node3D

# side directions
enum SIDE { TOP, BOTTOM, LEFT, RIGHT, FRONT, BACK }

var side: SIDE
var middle: Vector3 = Vector3.ZERO
var cube_parent: Cube

# returns the unit vector based of the SIDE enum
static func get_vector_from_side(s: SIDE) -> Vector3:
	match s:
		SIDE.TOP: return Vector3.UP
		SIDE.BOTTOM: return Vector3.DOWN
		SIDE.LEFT: return Vector3.LEFT
		SIDE.RIGHT: return Vector3.RIGHT
		SIDE.FRONT: return Vector3.BACK * -1
		SIDE.BACK: return Vector3.BACK
		_: return Vector3.ZERO

# rotates around given axe by "rot_deg" for "duration" seconds
func rotate_side(rot_deg: float, duration: float) -> void:
	pass

func set_enum(s: SIDE, c: Cube) -> void:
	side = s
	cube_parent = c
	
