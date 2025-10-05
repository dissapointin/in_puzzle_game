extends StaticBody3D

func _process(delta: float) -> void:
	rotation.x = rotation.x + delta*PI
