extends Node3D

@onready var cube: Cube = $Cube

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func _ready() -> void:
	for d: Cube.SIDE in Cube.SIDE.values():
		await wait(2)
		print(d)
		cube.rotate_cube(d)
