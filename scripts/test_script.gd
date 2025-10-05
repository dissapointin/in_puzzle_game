# TEMP script to test the cube rotation

extends Node3D

@onready var cube: Cube = $Cube
@onready var subcube_3: Subcube = $Cube/Subcube6 

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready() -> void:
	for d: Cube.SIDE in Cube.SIDE.values():
		await wait(2)
		cube.rotate_cube_based_of_subcube(subcube_3, d)
