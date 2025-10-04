extends Node3D

# funguje to tak, ze do array pieces se zapisou 8 sub krychlicek. 
# pak se najde stred pro pivot.
# musel jsem pridat Node3D (MeshContainer) abych mohl posunout je aby byly uprostred ale
# klidne to muzete zmenit aby to bylo jinak
var pieces = []
var stable_cube_center: Vector3

func _ready():
	await get_tree().process_frame

	for child in get_children():
		if child is Node3D:
			pieces.append(child)
	
	stable_cube_center = _calculate_true_center()
	# animations for testing // TODO input
	# 1 is clock wise, -1 is counter lock wise
	await get_tree().create_timer(1.0).timeout
	await animate_face_rotation(Vector3.BACK, 1)
	await animate_face_rotation(Vector3.RIGHT, -1)

# find pivot, avg of subcube positions
func _calculate_true_center() -> Vector3:
	if pieces.is_empty():
		return self.global_position
	
	var sum_of_positions = Vector3.ZERO
	for piece in pieces:
		sum_of_positions += piece.global_position
	
	return sum_of_positions / pieces.size()

# process the rotation
func animate_face_rotation(rotation_axis: Vector3, direction: int = 1):
	var pieces_to_rotate = []
	
	var face_normal_in_world = self.global_transform.basis * rotation_axis.normalized()
	for piece in pieces:
		var vector_to_piece = piece.global_transform.origin - stable_cube_center
		if vector_to_piece.dot(face_normal_in_world) > 0.1:
			pieces_to_rotate.append(piece)
			
	if pieces_to_rotate.is_empty():
		return

	var pivot = Node3D.new()
	pivot.global_position = stable_cube_center
	get_tree().root.add_child(pivot)

	for piece in pieces_to_rotate:
		var original_transform = piece.global_transform
		remove_child(piece)
		pivot.add_child(piece)
		piece.global_transform = original_transform

	var tween = create_tween()
	tween.tween_property(pivot, "rotation_degrees", pivot.rotation_degrees + rotation_axis * 90 * direction, 1.5)\
		 .set_trans(Tween.TRANS_CUBIC)\
		 .set_ease(Tween.EASE_IN_OUT)

	await tween.finished

	for piece in pieces_to_rotate:
		var final_transform = piece.global_transform
		pivot.remove_child(piece)
		add_child(piece)
		piece.global_transform = final_transform

	pivot.queue_free()
