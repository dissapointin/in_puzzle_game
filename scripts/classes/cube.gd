class_name Cube

extends Node3D

const SMALL_ZERO: float = 0.000000001    

# side directions
enum SIDE { TOP, BOTTOM, LEFT, RIGHT, FRONT, BACK }

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

static func get_side_from_vector(v : Vector3) -> SIDE:
	match v:
		Vector3.UP : return SIDE.TOP
		Vector3.DOWN : return SIDE.BOTTOM
		Vector3.LEFT : return SIDE.LEFT
		Vector3.RIGHT : return SIDE.RIGHT
		Vector3.BACK * -1 :  return SIDE.FRONT 
		Vector3.BACK: return SIDE.BACK
		_: 	print("error invalid vector");	return SIDE.TOP

# using Dict, instead of list for faster adding/popping - hashtable
var subcubs: Dictionary = {
	SIDE.TOP: {},
	SIDE.BOTTOM: {},
	SIDE.FRONT: {},
	SIDE.BACK: {},
	SIDE.LEFT: {},
	SIDE.RIGHT: {},
}

var is_rotating: bool = false

#code------------------------------------------

func _ready() -> void:
	for subcube: Node3D in get_children():
		set_subcube(subcube,find_sides(subcube))

func set_subcube(subcube_node: Node3D, side_enums: Array[SIDE]) -> void:
	for s: SIDE in side_enums:
		subcubes_dict_modify(subcube_node, s, true)

#add or remove cube from side
func subcubes_dict_modify(subcube: Subcube, side_enum: SIDE, add: bool) -> void:
	if add:
		subcubs[side_enum][subcube] = true;
	elif subcubs[side_enum].get(subcube):
		subcubs[side_enum].erase(subcube)

# calculatng middle point of all sides using the average of all subcubes
func get_current_middle(subcubes_given_side: Array[Subcube]) -> Vector3:
	var total := Vector3.ZERO
	var count := 0
	for subcube: Node3D in subcubes_given_side:
		total += subcube.position
		count += 1
	print("pivot" + str(total/count))
	return total / count if count > 0 else Vector3.ZERO
	
func rotate_cube(side: SIDE) -> void:
	if is_rotating:
		return
	is_rotating = true
	print(str(side))
	await _rotate_subcubes(side, 90.0, 0.5)
	is_rotating = false
	
func _rotate_subcubes(side: SIDE, rot_deg: float, duration: float) -> void:
	var subcubes_given_side: Array[Subcube] = []
	for key: Node3D in subcubs[side]:
		subcubes_given_side.append(key)
		
	var middle: Vector3 = get_current_middle(subcubes_given_side)
	var axis: Vector3 = get_vector_from_side(side)
	var pivot: Node3D = Node3D.new() # temp pivot to rotate around
	add_child(pivot)
	pivot.position = middle
	
	# adds all subcubes to the pivot
	for subcube: Subcube in subcubes_given_side:
		subcube.reparent(pivot)
		
	# rotates the pivot (and all of the subsides)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(
		pivot, 
		"rotation_degrees", 
		pivot.rotation_degrees + axis * rot_deg, 
		duration
	)
	
	await tween.finished # wait for the rotation to end

	# returns the sturcture to the origianl state
	for subcube: Subcube in subcubes_given_side:
		subcube.reparent(self)

	pivot.queue_free()
	
	#reside
	for c: Subcube in subcubes_given_side:
		for d: SIDE in SIDE.values():
			subcubes_dict_modify(c, d, false)
	
	for c: Subcube in subcubes_given_side:
		set_subcube(c,find_sides(c))

func find_sides(subcube: Subcube) -> Array[SIDE]:
	var result: Array[SIDE] = []
	
	if subcube.position.x > SMALL_ZERO:
		result.append(SIDE.RIGHT)
	elif subcube.position.x < -SMALL_ZERO:
		result.append(SIDE.LEFT)
	if subcube.position.y > SMALL_ZERO:
		result.append(SIDE.TOP)
	elif subcube.position.y < -SMALL_ZERO:
		result.append(SIDE.BOTTOM)
	if subcube.position.z > SMALL_ZERO:
		result.append(SIDE.BACK)
	elif subcube.position.z < -SMALL_ZERO:
		result.append(SIDE.FRONT)
	
	return result
