# Side.gd
class_name Side
extends Node3D

# side directions
enum SIDE { TOP, BOTTOM, LEFT, RIGHT, FRONT, BACK }


var side: SIDE
var middle: Vector3 = Vector3.ZERO
var cube_parent: Cube

func _ready() -> void:
	middle = get_current_middle() # sets th current middle

# calculatng middle point of all sides using the average of all subcubes
func get_current_middle() -> Vector3:
	var total := Vector3.ZERO
	var count := 0
	for subcube: Node3D in get_children():
		total += subcube.global_position
		count += 1
	return total / count if count > 0 else Vector3.ZERO

# returns the unit vector based of the SIDE enum
func get_vector_from_side(s: SIDE) -> Vector3:
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
	var axis := get_vector_from_side(side)
	middle = get_current_middle()

	# temp pivot to rotate around
	var pivot := Node3D.new()
	pivot.position = middle
	get_parent().add_child(pivot)
	pivot.global_position = middle
	
	# adds all subcubes to the pivot
	for subcube: Node3D in get_children():
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
	for subcube: Node3D in pivot.get_children():
		subcube.reparent(self)

	pivot.queue_free()
	
func set_enum(s: SIDE, c: Cube) -> void:
	side = s
	cube_parent = c
